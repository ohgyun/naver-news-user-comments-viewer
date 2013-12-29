###
백그라운드 모듈에서 사용하는 유틸리티 모듈
###
define ->

  # 부모 엘리먼트에서 셀렉터에 해당하는 엘리먼트를 찾은 후,
  # 타입에 해당하는 값을 가져온다.
  # 
  # @param {Element} parent 부모 엘리먼트
  # @param {String} selector 셀렉터
  # @param {String} type 검색할 타입
  #   text: 해당 DOM의 텍스트를 가져온다.
  #   href: href 값에 영어사전 주소를 붙여 가져온다.
  #   기본값: 속성을 가져온다.
  find: (parent, selector, type) ->
    target = (parent.find(selector) if selector) or parent
    host = "http://endic.naver.com"

    switch type
      when "text"
        target.text().trim()
      when "href"
        href = target.attr("href") or ""
        href = host + href if href
        href
      else
        attr = target.attr(type) or ""
        attr

  # 임의의 고유 아이디를 생성한다.
  guid: ->
    (Math.random() * (1 << 30)).toString(32).replace(".", "")