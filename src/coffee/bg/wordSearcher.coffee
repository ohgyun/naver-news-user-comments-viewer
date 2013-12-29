###
API에 단어를 요청해 검색하는 모듈
###
define [
  "jquery", "bg/parser/resultHtmlParser"
], ($, resultHtmlParser) ->
  
  # API URL
  # 네이버 영어사전 서비스의 검색 결과에서
  # 본문의 단어를 클릭했을 때 동적으로 뜨는 보조사전 API를 이용한다.
  API_URL = "http://endic.naver.com/searchAssistDict.nhn?query="
  
  # 최근 검색한 단어
  # 재검색하거나 한/영 단어 전환 시 사용한다.
  _recentQuery = ""

  # 단어를 검색한다.
  # @param {String} query
  searchWord = (query, callback) ->
    cacheRecentQuery query
    requestQuery query, callback
  
  # 최근 검색어를 캐시해둔다.
  # @param {String} query
  cacheRecentQuery = (query) ->
    _recentQuery = query
  
  # 단어를 ajax로 요청해 가져온다.
  # @param {String} query
  # @param {Function} callback(parsedData) 응답 콜백
  requestQuery = (query, callback) ->
    url = API_URL + query

    $.ajax
      url: url
      # 도메인은 다르지만 익스텐션에서 프록시 역할을 하므로
      # 비동기 요청을 보내도 문제 없다.
      crossDomain: false
      dataType: "html" # 서버에서 html 형태로 내려준다.
      success: (data) ->
        response data, query, callback

  # 결과에 대한 응답을 보낸다.
  # @param {Object} data
  # @param {String} query
  # @param {Function} callback(parsedData) 응답 콜백
  response = (data, query, callback) ->
    parsedData = resultHtmlParser.parse(data)
    
    # 데이터에 쿼리를 포함해 응답한다.
    parsedData.query = query
    callback parsedData
  
  return (
    # 단어를 검색한다.
    # @param {string} query
    # @param {Function} callback(parsedData)
    searchWord: (query, callback) ->
      searchWord query, callback
    
    # 최근 검색했던 단어로 검색한다.
    # @param {Function} callback(parsedData)
    searchWordWithRecentQuery: (callback) ->
      searchWord _recentQuery, callback
  )