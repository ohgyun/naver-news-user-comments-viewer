###
익스텐션과 컨텐트 스크립트의 커뮤니케이션을 담당하는 모듈

크롬에서 이미 API를 제공하고 있지만,
(http://developer.chrome.com/extensions/messaging.html)
익스텐션과 탭을 구분해야 하는 것이 좀 혼란스럽다.

익스텐션과 탭의 구분 없이 간편하게 사용할 수 있도록,
Pub/Sub 스타일로 추상화한다.

pubsub 모듈은 반드시 main 모듈에서만 사용한다.
###
define ->
  # 메시지를 보관할 맵
  # 
  #  key: [ callback, callback, ...]
  #  key: [ ... ]
  #
  # 형태로 보관한다.
  _map = {}

  # 메시지 값을 저장할 스트링
  MSG_KEY = "_key_"
  
  # 메시지를 발행(publish)한다.
  # 메시지는 반드시 '명령형'이 아닌, '완료형'으로 보낸다.
  # 예) '단어를 검색하라' 대신, '단어가 검색됐다'를 사용한다.
  #   'ext.searchWord' 대신, 'ext.wordSearched'를 사용한다.
  # 
  # @param {String} msg 전달할 메시지명, 아래 컨벤션을 따른다.
  #   ext.* 형태이면, 익스텐션에서 발생한 메시지이다.
  #   cscript.* 형태이면, 컨텐트 스크립트에서 발생한 메시지이다.
  # @param {Object} data 전달할 데이터
  pub = (msg, data) ->
    data or= {}
    data[MSG_KEY] = msg
    
    # 익스텐션과 컨텐트 스크립트 양쪽으로 메시지를 보낸다.
    tryToPubToExtension msg, data
    tryToPubToContentScript msg, data
  
  tryToPubToExtension = (msg, data) ->
    chrome.extension.sendMessage data
  
  tryToPubToContentScript = (msg, data) ->  
    # 크롬이 업데이트 되면서 컨텐트 스크립트에서 `chrome.tabs` 변수에
    # 접근하기만 해도 오류를 발생한다.
    # https://github.com/ohgyun/nendic-ext/issues/17

    # cscript_main 에서 현재 샌드박스가 컨텐트 스크립트인지 여부를 설정한다.
    return if gIsContentScript?

    if chrome.tabs # chrome.tabs 속성은 익스텐션에서만 갖는다.
      # 현재 활성화되어 있는 탭에만 메시지를 보낸다.
      chrome.tabs.getSelected null, (tab) ->
        chrome.tabs.sendMessage tab.id, data
  
  # 메시지를 구독(subscribe)한다.
  # 구독할 메시지를 키값으로, 맵에 콜백을 저장한다.
  #
  # @param {String} msg 메시지명
  # @param {Function} callback(data)
  sub = (msg, callback) ->
    _map[msg] or= []
    _map[msg].push callback
  
  # 익스텐션 메시지의 리스너를 등록한다.
  registerListener = ->
    chrome.extension.onMessage.addListener (request, sender, sendResponse) ->  
      # 탭 아이디는 컨텐트 스크립트에서 보낼 때에만 존재한다.
      request.tabId = sender.tab and sender.tab.id or ""
      onResponse request
      # sendResponse는 사용하지 않는다.
  
  # 메시지를 받아 처리한다.
  # 전달받은 데이터에 저장되어 있는 메시지값(KEY_MSG 속성)으로
  # 호출할 콜백을 찾는다.
  onResponse = (data) ->
    callbacks = _map[data[MSG_KEY]]
    cb data for cb in callbacks if callbacks
  
  # 모듈이 로드되면, 리스너를 등록한다.
  registerListener()

  pub: pub
  sub: sub