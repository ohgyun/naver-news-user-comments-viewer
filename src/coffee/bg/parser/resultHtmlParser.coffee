###
단어 검색 결과를 파싱하는 모듈

보조사전의 API 검색 결과는 HTML 형태로 떨어진다.
요청 예) http://endic.naver.com/searchAssistDict.nhn?query=dictionary

이 모듈에서는 검색 결과를 파싱해 JSON 형태로 반환한다.
임의의 DOM을 생성해 HTML을 넣은 후,
jquery 셀렉터로 값을 가져오는 방식으로 파싱한다.
###
define [
  "jquery"
  "bg/parser/wordParser"
  "bg/parser/meaningParser"
], ($, wordParser, meaningParser) ->
  
  # 결과를 담을 래퍼 엘리먼트
  _$wrapper = null
  
  # 단어 부분 래퍼
  _$word = null
  
  # 의미 부분 래퍼
  _$meaning = null
  
  # 파싱하기 위한 HTML을 넣을 임의의 래퍼 DOM을 생성한다.
  init = ->
    _$wrapper = $("<div>")
  
  # HTML을 파싱하기 위해 DOM을 생성하고 할당한다.
  # @param {String} html
  readyParsing = (html) ->
    _$wrapper.html html
    
    # 단어 제목(h3)과 타입별 의미(.box_a)가 쌍으로 존재한다.
    _$word = _$wrapper.find("h3")
    _$meaning = _$wrapper.find(".box_a")
  
  # HTML을 파싱한다.
  # wordParser와 meaningParser로 파싱하고, 각각의 결과를 데이터로 담아 리턴한다.
  parseHtmlToData = ->
    result = []
    
    for i in [0..._$word.length]
      wordParser.setWrapper _$word.get(i)
      meaningParser.setWrapper _$meaning.get(i)
      
      wordData = wordParser.parse()
      wordData.meanings = meaningParser.parse()
      
      result.push wordData

    result: result

  # DOM을 초기화하고 메모리 해제한다.
  reset = ->
    _$wrapper.remove()
    _$word = null
    _$meaning = null
  
  # 모듈이 로드되면 초기화한다.
  init()
  
  return (
    # 사전 검색 결과 html을 json을 파싱한다.
    # @param {String} html
    # @return {Object} 파싱한 결과
    parse: (html) ->
      readyParsing html
      parsed = parseHtmlToData()
      reset()
      parsed
  )