###
프레임 관리자

도큐먼트 내에는 iframe을 포함해 여러 프레임이 존재하기 때문에,
영어사전을 표시하기에 가장 적합한 프레임을 찾아서 보여줘야 한다.
이 모듈에서는, 각 탭 별 프레임들의 사이즈를 저장하고,
요청 시 적합한 프레임을 찾아주는 역할을 한다.
###
define ->
  # 프레임 정보를 저장해둘 리파지터리
  #
  #   탭아이디:
  #     activated:
  #       # 현재 활성화된 프레임 정보
  #       tabId: 탭아이디
  #       frameId: 프레임아이디
  #       width: 프레임너비
  #       height: 프레임높이
  #     list: [ frameId, frameId, ... ]
  #
  _repos = {}
  
  # 프레임 정보를 리파지터리에 등록한다.
  # @param {Object} data 프레임 정보
  # @param {String} data.frameId 프레임 아이디
  # @param {Number} data.width 프레임 너비
  # @param {Number} data.height 프레임 높이
  # @param {String} tabId 프레임을 포함한 탭 아이디
  registerFrame = (data) ->
    frames = _repos[data.tabId]
    
    # 프레임 정보가 없다면 생성한다.
    unless frames
      frames = _repos[data.tabId] = (activated: null, list: [])
    
    # 프레임 목록에 추가한다.
    frames.list.push data.frameId
  
  # 현재 프레임을 활성화하려고 시도한다.
  # @param {Object} data 프레임 데이터
  # @param {Function} activatedCallback(frameId) 현재 프레임이 활성화된 경우 실행할 콜백
  tryToActivate = (data, activatedCallback) ->
    frames = _repos[data.tabId]
    
    # 이미 활성화했던 프레임이 존재하고 있다면, 전달한 데이터와 비교한다.
    if frames.activated
      currentSize = frames.activated.width * frames.activated.height
      newSize = data.width * data.height
      
      # 어떤 것을 활성화할 지는 프레임의 크기로 결정한다.
      # 현재 프레임이 기존 프레임보다 작다면 무시한다. 
      return if newSize <= currentSize
    
    # 현재 프레임이 활성화 프레임보다 크거나,
    # 활성화되어 있는 프레임이 없다면, 현재 것으로 설정한다.
    frames.activated = data
    activatedCallback data.frameId
  
  # 탭이 가지고 있는 프레임 목록 중에,
  # 요청한 프레임 아이디가 존재하는지 확인한다.
  isNotExist = (frameId, tabId) ->
    frames = _repos[tabId]
    return true unless frames

    frames.list.indexOf(frameId) is -1
  
  # 프레임 정보를 모두 비운다.
  # @param {String} tabId
  resetFrame = (tabId) ->
    return unless _repos[tabId]

    _repos[tabId].activated = null
    _repos[tabId].list.length = 0
    _repos[tabId].list = null
    delete _repos[tabId]
  
  return (
    # 현재 프레임이 존재하지 않으면, 프레임을 리셋한다.
    # 프레임이 존재하지 않는 경우는 아래 두 경우이다.
    # 1. 탭을 처음으로 연 경우
    # 2. 페이지를 이동한 경우
    # @param {Object} data
    # @param {String} data.frameId 프레임 아이디
    # @param {String} data.tabId 탭 아이디
    # @param {Function} resetCallback 리셋 콜백
    #   프레임이 존재하지 않을 경우,
    #   프레임 정보를 리셋하고 리셋 콜백을 호출한다.
    checkFrameExist: (data, resetCallback) ->
      frameId = data.frameId
      tabId = data.tabId
      if isNotExist(frameId, tabId)
        resetFrame tabId
        resetCallback()

    # 프레임 정보를 리파지터리에 등록하고, 활성화를 시도한다.
    # @param {Object} data 프레임 데이터
    # @param {Function} activatedCallback(frameId) 활성화 시 콜백
    registerAndActivateFrame: (data, activatedCallback) ->
      registerFrame data
      tryToActivate data, activatedCallback
  )