###
검색 결과의 '타입별 의미' 부분을 파싱하는 모듈
###
define [
  "jquery"
  "common/util"
], ($, util) ->
  
  _$wrapper = null

  # 기준 래퍼를 할당한다.
  setWrapper = (elWrapper) ->
    _$wrapper = $(elWrapper)

  # HTML을 파싱한다.
  parseHtmlToData = ->
    datas = []
    $current = _$wrapper
    getCurrentDataAndTryNext datas, $current
    datas
  
  # 단어의 타입별 의미는 'box_a' 클래스를 가진 DOM에 존재한다.
  # 만약, 타입이 추가 정의되어 있는 경우,
  # .box_a와 같은 레벨로 .box_b, .box_c 가 존재한다. (sibiling)
  #
  # 먼저 .box_a 엘리먼트 기준으로 데이터를 검색하고,
  # 형제 엘리먼트를 확인하면서 재귀 호출한다.
  #
  # @param {Array} datas 결과 데이터를 담을 배열
  # @param {jQuery} $current 현재 엘리먼트
  getCurrentDataAndTryNext = (datas, $current) ->
    if $current.hasClass("box_a") or
        $current.hasClass("box_b") or
        $current.hasClass("box_c")
      datas.push getData($current)
      getCurrentDataAndTryNext datas, $current.next()
  
  # 한 단어는 여러 타입을 가질 수 있다.
  #   예) 동사, 명사, ...
  # @param {jQuery} 현재 엘리먼트
  getData = ($current) ->
    # 품사의 종류
    type: util.find($current, "h4 .fnt_k28", "text")
    
    # 의미
    definitions: getDefinitions($current)
    
    # 더보기 정보
    moreDefinition: getMoreDefinition()
  
  # 각 타입에는 여러 의미가 있을 수 있다.
  # 각 의미의 마크업 구조
  #   dt : 의미
  #   dd : 샘플 문장
  #   dd : 샘플 해석
  # @param {jQuery} 현재 엘리먼트
  getDefinitions = ($current) ->
    datas = []
    $defs = $current.find(".list_ex1 dt") # 의미
    $defs.each ->
      $el = $(this)

      # '뜻 더보기'이면 중단한다.
      return if $el.hasClass("last")
      
      def = util.find($el, "", "text")
      ex_en = (util.find($el.next(), "", "text") if $el.next().is("dd")) or ""
      ex_kr = (util.find($el.next().next(), "", "text") if $el.next().next().is("dd")) or ""

      datas.push
        # 의미
        def: def
        # 영어 예문
        ex_en: ex_en
        # 국어 예문
        ex_kr: ex_kr

    datas
  
  # 여러 뜻이 있을 경우, 더보기를 가져온다.
  getMoreDefinition = ->
    $more = _$wrapper.find("dt.last")
    
    # 더보기 개수
    count: util.find($more, ".fnt_k14", "text")
    # 더보기 URL
    url: util.find($more, ".fnt_k22 a", "href")
  
  # DOM을 초기화하고 메모리 해제한다.
  reset = ->
    _$wrapper.remove()
    _$wrapper = null
  
  return (
    # 기준 래퍼를 할당한다.
    setWrapper: (elWrapper) ->
      setWrapper elWrapper

    # HTML을 파싱한다.
    parse: ->
      parsed = parseHtmlToData()
      reset()
      parsed
  )