###
컨텐트 스크립트에서 RequireJS를 사용하기 위한 패치

크롬 익스텐션의 컨텐트 스크립트는,
웹페이지 스크립트와는 독립된 샌드박스를 가지고 있다.
두 스크립트의 환경은 독립되어 있기 때문에
변수를 공유할 수 없다.
하지만, 두 샌드박스 모두 DOM에는 접근할 수 있고, 공유할 수 있다.

RequireJS가 비동기로 스크립트를 로드하는 일반적인 방법은
DOM에 script 태그를 추가하는 방식이다.
일반적인 환경에서는 문제가 되지 않지만,
RequireJS가 컨텐트 스크립트의 샌드박스에서 로드할 때에는 상황이 다르다.

컨텐트 스크립트에 require.js를 추가하면,
RequireJS는 컨텐트 스크립트의 샌드박스에 존재한다.
하지만, require()로 다른 스크립트 파일을 로드하면,
웹페이지와 공유하고 있는 DOM에 스크립트 태그를 추가하게 되고,
로드된 스크립트는 웹페이지 스크립트의 샌드박스에 존재한다.

이처럼 다른 샌드박스에 스크립트가 로드되는 문제를 해결하기 위해,
컨텐트 스크립트에서는 XHR로 다른 파일을 로드하도록 한다.
불러온 스크립트 텍스트는 eval()로 실행해,
컨텐트 스크립트의 샌드박스에서 동작하도록 한다.

참고
- 크롬 익스텐션의 샌드박스: http://www.youtube.com/watch?v=laLudeUmXHM
- requirejs 그룹스 포스트:
  https://groups.google.com/forum/?fromgroups=#!topic/requirejs/elU_NYjunRw
###
require.load = (context, moduleName, path) ->
  xhr = new XMLHttpRequest()
  
  # 익스텐션 폴더의 리소스를 가져올 수 있도록
  # chrome.extension.getURL()을 사용한다.
  # 익스텐션 폴더의 리소스에 접근하기 위해서는,
  # 반드시 web_accessible_resources에 접근할 리소스를 명시해줘야한다.
  # manifest v2부터 변경된 내용이며,
  # 자세한 사항은 아래 URL을 참고한다.
  # http://developer.chrome.com/extensions/manifest/web_accessible_resources.html
  url = chrome.extension.getURL(path)
  nocache = "?" + (+new Date())
  xhr.open "GET", url + nocache, true
  xhr.onreadystatechange = (e) ->
    if xhr.readyState is 4 and xhr.status is 200
      # eval 이 전역으로 실행될 수 있게 간접 호출한다.
      _indirectEval xhr.responseText
      context.completeLoad moduleName

  xhr.send null

_indirectEval = eval