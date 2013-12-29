###
뷰어의 단축키 모듈
###
define [
  "jquery"
], ($) ->
  
  ALPHABET = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
  
  SPECIAL =
    27: "esc"
    13: "enter"

  _callbackMap = {}
  
  # keydown으로 바인딩하면,
  # 한글일 때 키코드를 정확히 찾지 못하는 버그가 있다.
  # keyup으로 이벤트를 할당한다.
  findKey = (keyCode) ->
    return ALPHABET[keyCode - 65] if 65 <= keyCode <= 90
    SPECIAL[keyCode]

  $(document).on "keyup", (e) ->
    target = e.target

    # 텍스트 입력창이라면 무시한다. 단, 스페셜 키인 경우엔 허용한다.
    return if /(input|textarea)/i.test(target.tagName) and
        e.keyCode not of SPECIAL

    key = findKey(e.keyCode)
    cbs = _callbackMap[key] if key
    cb(e) for cb in cbs if cbs

  return (
    # 단축키 콜백을 할당한다.
    # @param {String} key 키명. 'a', 'b'와 같은 키 이름
    # @param {Function} callback 실행할 콜백
    # @param {Function} cond 콜백을 실행할 조건
    on: (key, callback, cond) ->
      _callbackMap[key] or= []
      _callbackMap[key].push (e) ->
        switch typeof cond
          when "undefined"
            callback(e)
          when "function"
            cond(e) and callback(e)
          else
            cond and callback(e)

      this
  )