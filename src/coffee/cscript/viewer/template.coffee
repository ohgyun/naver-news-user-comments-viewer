###
사전 뷰어의 템플릿 모듈
템플릿 함수와 템플릿을 사전 템플릿을 가지고 있다.
###
define ->

  # Simple JavaScript Templating
  # John Resig - http://ejohn.org/ - MIT Licensed
  # @param {String} str
  # @param {Object} data
  # @return {String}
  tmpl = (->
    cache = {}
    tmpl = (str, data) ->
      
      # Figure out if we're getting a template, or if we need to
      # load the template - and be sure to cache the result.
      # Generate a reusable function that will serve as a template
      fn = (if not /\W/.test(str) then cache[str] = cache[str] or tmpl(str) else new Function("obj", "var p=[],print=function(){p.push.apply(p,arguments);};" + "with(obj){p.push('" + str.replace(/[\r\t\n]/g, " ").split("<%").join("\t").replace(/((^|%>)[^\t]*)'/g, "$1\r").replace(/\t=(.*?)%>/g, "',$1,'").split("\t").join("');").split("%>").join("p.push('").split("\r").join("\\'") + "');}return p.join('');"))
      (if data then fn(data) else fn)
    tmpl
  )()
  
  # markup template
  # TODO: handlebars 로 변경한다.
  _markup = """
    <!-- header -->
    <div class="header">
      <button class="searchbar-opener" data-cmd="openSearchBar"></button>

      <div class="link">
        <a href="http://endic.naver.com" target="_blank">네이버 영어사전</a>
      </div>

      <!-- search bar -->
      <div class="search">
        <div class="wrap">
          <input type="text" id="endic_ext_search_query" placeholder="단어를 입력하세요">
          <button data-cmd="searchWord">검색</button>
        </div>
      </div>
      <!-- end search bar -->
  
    </div>
    <!-- end header -->

    <!-- body -->
    <div class="body">
      <!-- toggle ee dic button -->
      <% if (result.length > 0) { %>
        <div class="toggle-btn">
          <button data-cmd="toggleDicType">한영/영영 전환</button>
        </div>
      <% } %>
      <!-- end toggle ee dic button -->

      <!-- body wrapper -->
      <div class="wrap">
  
      <!-- words -->
      <% for (var i = 0; i < result.length; i++) { %>
        <% var word = result[i]; %>

        <!-- word title -->
        <h3>
          <strong><a href="<%= word.url %>" class="title" target="_blank"><%= word.title %></a></strong>
          <sup class="number"><%= word.number %></sup>
          <span class="phonetic-symbol"><%= word["phonetic_symbol"] %></span>
    
          <!-- audio button -->
          <% if (word.pronunciation) { %>
            <button class="audio-btn audio-idx-<%= i %>" data-cmd="playAudio" data-cmdval="<%= i %>" data-audio-src="<%= word.pronunciation %>"></button>
          <% } %>
          <!-- end audio button -->
        
        </h3>
        <!-- end word title -->

        <!-- word meanings -->
        <% for (var j = 0; j < word.meanings.length; j++) { %>
          <% var meaning = word.meanings[j]; %>

          <!-- meaning -->
          <div class="meaning">
            <h4 class="type"><%= meaning.type %></h4>

            <!-- meaning definitions -->
            <% for (var k = 0; k < meaning.definitions.length; k++) { %>
              <% var definition = meaning.definitions[k]; %>

              <!-- definition -->
              <div class="defs">
                <div><%= definition.def %></div>
                <div class="ex-en"><%= definition["ex_en"] %></div>
                <div class="ex-kr"><%= definition["ex_kr"] %></div>
              </div>
              <!-- end definition -->

            <% } %>
            <!-- end meaning definitions -->

            <!-- more definition -->
            <% if (meaning.moreDefinition.count > 0) { %>
              <div class="more-def">
                <a href="<%= meaning.moreDefinition.url %>" target="_blank"><%= meaning.moreDefinition.count %>개 뜻 더보기</a>
              </div>
            <% } %>
            <!-- end more definition -->

          </div>
          <!-- end meaning -->

        <% } %>
        <!-- end word meanings -->
    
      <% } %>
      <!-- end words -->

      <!-- if no result -->
      <% if (result.length === 0) { %>
        <div class="endic_ext_noresult"><span class="query">\'<%= query %>\'</span>에 대한 검색 결과가 없습니다.</div>
      <% } %>
      <!-- end if no result -->

      </div>
      <!-- end body wrapper -->
  
    </div>
    <!-- end body -->

    <!-- footer -->
    <div class="footer">
  
      <!-- guide area -->
      <div class="guide">
        <button data-cmd="toggleShortcutGuide">단축키 도움말</button>
      </div>
      <!-- end guide area -->
  
      <!-- shortcut guide -->
      <div class="shortcut">
        <ul>
          <li><strong>ESC</strong> : 닫기</li>
          <li><strong>F</strong> : 검색창 열기(<strong>F</strong>ind word</strong>)</li>
          <li><strong>S</strong> : 한영/영영 전환(<strong>S</strong>witch dictionary)</li>
          <li><strong>A</strong> : 발음듣기(Play <strong>A</strong>udio)</li>
          <li><strong>G</strong> : 영어사전 페이지로 이동(<strong>G</strong>o to original page)</li>
          <li><strong>H</strong> : 단축키 도움말(Shortcut <strong>H</strong>elp)</li>
        </ul>
      </div>
      <!-- end shortcut guide -->
  
    </div
    <!-- end footer -->
  """

  return (
    # 사전 데이터로 사전 HTML을 가져온다.
    # @param {Object} dicData 사전 데이터
    getHtml: (dicData) ->
      tmpl(_markup, dicData)
  )