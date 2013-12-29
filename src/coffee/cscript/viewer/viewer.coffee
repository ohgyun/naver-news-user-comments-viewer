###
사전 뷰어 모듈
###
define [
  "jquery"
  "cscript/viewer/template"
  "cscript/viewer/action"
  "cscript/viewer/shortcut"
  "cscript/viewer/webFont"
], ($, template, action, shortcut) ->
  
  _isOpened = false

  # 열고 닫을 때 적용할 타이머
  # 사전이 열린 상태에서 바로 사전을 열 때에
  # 열린 상태에서 내용만 바뀔 수 있도록 타이머를 적용한다.
  # 매 클릭마다 열리고 닫히는 것이 반복되면 정신이 없다.
  _timer = null
  
  # 사전을 표시할 래퍼 엘리먼트
  _$wrapper = $("<div>")
      .attr("id", "endic_ext_wrapper")
      .appendTo(document.body)
  
  # 뷰어는 사전을 열고 닫는 것만 처리한다.
  # 실제 액션은 action 객체에 위임하며,
  # 뷰어가 초기화될 때 액션 객체도 초기화해준다.
  action.init _$wrapper
  
  # 이벤트를 바인딩한다.
  _$wrapper.on "click", "[data-cmd]", (e) ->
    # 템플릿에서 이벤트를 바인딩할 엘리먼트는,
    # data-cmd 속성에 명령어를,
    # data-cmdval 속성에 전달할 값을 설정한다.
    # viewer 외부에서 setHandler(cmd, handler)를 호출해
    # 각 명령에 대한 콜백을 설정할 수 있다.
    $t = $(this)
    cmd = $t.data("cmd")
    value = $t.data("cmdval")
    action.doAction cmd, value
    e.preventDefault()
  

  # 단축키 이벤트
  # ----------
  # 창이 열려있을 때에만 동작하도록 등록한다.
  shortcutMap = action.getShortcutMap()
  ((k) ->
    shortcut.on k, (->
      cmd = shortcutMap[k]
      action.doAction cmd
    ), ->
      _isOpened
  )(key) for key of shortcutMap

  # 스페셜 단축키에 대한 이벤트를 등록한다.
  shortcut.on "esc", (->
    close()
  ), ->
    _isOpened

  shortcut.on "enter", (->
    action.doAction "searchWord"
  ), (e) ->
    $(e.target).is "#endic_ext_search_query"

  
  # 사전을 연다.
  # @param {object} dicData 사전 데이터
  open = (dicData) ->
    clearTimeout _timer
    _timer = null
    _$wrapper.html template.getHtml(dicData) if dicData
    _$wrapper.show()
    _isOpened = true

  # 사전을 닫는다.
  close = ->
    if _isOpened
      _$wrapper.hide 0, ->
        $(this).empty()

      _isOpened = false

 
  return (
    open: open
    close: close
    hasElement: (el) ->
      _$wrapper.has(el).length > 0

    # 액션 핸들러를 할당한다.
    onAction: (cmd, callback) ->
      action.on cmd, callback
  )