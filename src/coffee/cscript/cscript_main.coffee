# pubsub 모듈에서 chrome.tabs 이슈를 해결하기 위한 패치 코드
gIsContentScript = true

###
컨텐트 스크립트의 메인 모듈
이 스크립트는 iframe을 포함한 모든 프레임에 추가된다.
###
require [
  "jquery"
  "underscore"
  "common/pubsub"
], ($, _, pubsub) ->

  # 뉴스 댓글 엘리먼트의 래퍼를 가져온다.
  _$wrapper = $(document).find(".commentlist_wrap")

  # 댓글 클래스 패턴
  _rCommentNo = /_commentReplyNo\((\d+)\)/

  # 댓글에 대한 래퍼가 존재하지 않으면 나머지는 실행하지 않는다.
  return unless _$wrapper and _$wrapper.length

  # 사전의 폰트로는 구글의 Lato 폰트를 사용하며,
  # 폰트 파일은 익스텐션과 함께 배포한다.
  # CSS에서는 익스텐션의 URL을 알 수 없기 때문에,
  # 스크립트에서 동적으로 웹폰트를 스타일로 추가한다.
  _style = document.createElement("style")
  _style.appendChild document.createTextNode("")
  document.getElementsByTagName("head")[0].appendChild _style
  
  insertRule = (def) ->
    _style.sheet.insertRule def, 0

  # Flat UI Icons
  insertRule """
    @font-face {
      font-family: "Flat-UI-Icons";
      src: url(#{chrome.extension.getURL("font/flat-ui-icons.woff")}) format("woff");
      font-weight: normal;
      font-style: normal;
    }
  """
 
  # 작성자 이름 오른쪽에 버튼을 생성한다. 
  createViewerButton = _.debounce(->
    console.log "버튼 생성"
    _$wrapper.find(".author").each ->
      $t = $(this)
      return if $t.data('___list-viewer') is 'on'
      # 아이콘을 표시하기 위해 유니코드 형식으로 추가한다. (`e00c`)
      $t.append('<span class="__list-viewer">\ue00c</span>')
      $t.data('__list-viewer', 'on')
  , 500)

  # 초기화되면 버튼을 한 번 생성하고,
  createViewerButton()

  # DOM이 변경될 때마다 다시 넣어준다.
  # TODO: 나중에 `Mutaion Observer`로 변경한다.
  # https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver
  _$wrapper.on "DOMSubtreeModified", ->
    createViewerButton()


  # 이벤트를 바인딩
  _$wrapper.on "click", ".author .__list-viewer", (e) ->
    $li = $(this).closest("li")
    commentNo = RegExp.$1 if _rCommentNo.test($li[0].className)
    console.log ">>>", commentNo
    pubsub.pub "@-user-selected", commentNo

  # 메시지 정의
  # --------

  # 규칙
  # 1. 완료형으로만 보낸다.
  # 2. 소문자와 대시(-)를 사용한다.
  # 3. 컨텐트 스크립트에서 보낸 경우, 앞에 @- 를 붙인다.
  # 4. 백그라운드에서 보낸 경우, 앞에 *- 를 붙인다.
  pubsub.sub "*-hoho", ->
    console.log "hoho- rrr"


  # 현재 프레임 정보를 수집해 전송한다. 
  pubsub.sub "*-comments-searched", (data) ->
    console.log '---->', data
