###
뷰어에서 발생하는 액션을 처리하는 모듈
###
define [
  "jquery"
  "cscript/viewer/pronAudio"
], ($, pronAudio) ->
  
  _$wrapper = null

  # 액션 호출 시 실행할 콜백 목록
  _callbackMap = {}
  
  # 액션 목록
  _actionMap =
    # 영영/영한 사전을 토글한다.
    toggleDicType: ->
      runCallback "toggleDicType"

    # 단어 발음 오디오를 재생한다.
    playAudio: (audioIdx) ->
      pronAudio.play audioIdx

    # 단축키 가이드를 토글한다.
    toggleShortcutGuide: ->
      $guide = _$wrapper.find ".shortcut"
      $guide.slideToggle "fast"

    # 사전 페이지로 이동한다.
    goToDictionaryPage: ->
      $title = _$wrapper.find ".title:first"
      href = $title.attr("href")
      window.open href if href

    # 검색창을 연다.
    openSearchBar: ->
      $bar = _$wrapper.find ".search"
      $bar.addClass "show"
      _$wrapper.find("#endic_ext_search_query").focus()

    # 단어를 검색한다.
    searchWord: (query) ->
      query = _$wrapper.find("#endic_ext_search_query").val()
      runCallback "searchWord", query if query

  
  # 단축키와 액션의 맵
  _shortcutToCommandMap =
    s: "toggleDicType"
    h: "toggleShortcutGuide"
    a: "playAudio"
    g: "goToDictionaryPage"
    f: "openSearchBar"
  
  # 액션에 할당되어 있는 콜백을 실행한다.
  runCallback = (cmd, args...) ->
    callback = _callbackMap[cmd]
    callback.apply(callback, args) if typeof callback is "function"
  

  return (
    init: ($wrapper) ->
      _$wrapper = $wrapper

    on: (cmd, callback) ->
      _callbackMap[cmd] = callback

    doAction: (cmd, value) ->
      action = _actionMap[cmd]
      action value if typeof action is "function"

    getShortcutMap: (key) ->
      _shortcutToCommandMap
  )
