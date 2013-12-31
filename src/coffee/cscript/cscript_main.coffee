# pubsub 모듈에서 chrome.tabs 이슈를 해결하기 위한 패치 코드
gIsContentScript = true

###
컨텐트 스크립트의 메인 모듈
###
require [
  "jquery"
  "underscore"
  "common/pubsub"
  "handlebars"
  "cscript/viewer"
  "tmpl/tmpl"
  "cscript/webFont"
], ($, _, pubsub, Handlebars, viewer, tmpl) ->

  # 뉴스 댓글 엘리먼트의 래퍼를 가져온다.
  _$wrapper = $(document).find(".commentlist_wrap")

  # 댓글 클래스 패턴
  _rCommentNo = /_commentReplyNo\((\d+)\)/

  # 주소라인에서 기사명을 가져오는 패턴
  _rGno = /gno=(news[0-9,]+)/

  # 댓글에 대한 래퍼가 존재하지 않으면 나머지는 실행하지 않는다.
  return unless _$wrapper and _$wrapper.length
 
  # 작성자 이름 오른쪽에 버튼을 생성한다. 
  createViewerButton = _.debounce(->
    _$wrapper.find(".author").each ->
      $t = $(this)
      return if $t.data('__list-viewer') is 'on'
      # 아이콘을 표시하기 위해 유니코드 형식으로 추가한다. (`e00c`)
      $t.append('<span class="__list-viewer">\ue00c</span>')
      $t.data('__list-viewer', 'on')
  , 300)

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
    gno = RegExp.$1 if _rGno.test(location.search)

    # 사용자가 선택되었음을 백그라운드에 알린다.
    pubsub.pub "@-user-selected",
      commentNo: commentNo
      gno: gno

    # 뷰어를 연다.    
    top = $(this).offset().top
    viewer.loading(top)

  viewer.modal.on "click", ".more button", (e) ->
    pubsub.pub "@-more-button-clicked",
      currentPage: $(this).data("current-page")


  # 템플릿 헬퍼 등록
  # ------------
  Handlebars.registerHelper "date", ->
    [date, ampm, time] = @sRegDate.split(" ")

    """
    <span class="date">#{date}</span>
    <span class="ampm">#{ampm}</span>
    <span class="time">#{time}</span>
    """

  Handlebars.registerHelper "moreButton", ->
    currentCount = @page * @pageSize

    return "" if @userCommentReplyCount <= currentCount

    """
    <li class="more">
      <button data-current-page="#{@page}">더보기</button>
    </li>
    """

  # 메시지 정의
  # --------

  # 규칙
  # 1. 완료형으로만 보낸다.
  # 2. 소문자와 대시(-)를 사용한다.
  # 3. 컨텐트 스크립트에서 보낸 경우, 앞에 @- 를 붙인다.
  # 4. 백그라운드에서 보낸 경우, 앞에 *- 를 붙인다.

  pubsub.sub "*-comments-searched", (data) ->
    html = tmpl.comments data
    viewer.print html

  pubsub.sub "*-more-comments-searched", (data) ->
    html = tmpl.comments data
    viewer.update html

  pubsub.sub "*-comments-denied", ->
    html = tmpl.denied()
    viewer.print html

  pubsub.sub "*-comments-error", ->
    html = "알 수 없는 오류가 발생했습니다. 다시 시도해주세요."
    viewer.print html