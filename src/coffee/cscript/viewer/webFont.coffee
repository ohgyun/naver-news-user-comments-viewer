###
뷰어에서 사용할 웹폰트를 동적으로 로드한다.
###
define ->
  
  # 사전의 폰트로는 구글의 Lato 폰트를 사용하며,
  # 폰트 파일은 익스텐션과 함께 배포한다.
  # CSS에서는 익스텐션의 URL을 알 수 없기 때문에,
  # 스크립트에서 동적으로 웹폰트를 스타일로 추가한다.
  _style = document.createElement("style")
  _style.appendChild document.createTextNode("")
  document.getElementsByTagName("head")[0].appendChild _style
  
  insertRule = (def) ->
    _style.sheet.insertRule def, 0

  # Lato Normal
  insertRule """
    @font-face {
      font-family: "Lato";
      src: url(#{chrome.extension.getURL("font/lato-regular-webfont.woff")}) format("woff");
      font-weight: normal;
      font-style: normal;
    }
  """
  # Lato Bold
  insertRule """
    @font-face {
      font-family: "Lato";
      src: url(#{chrome.extension.getURL("font/lato-bold-webfont.woff")}) format("woff");
      font-weight: bold;
      font-style: normal;
    }
  """
  
  # Flat UI Icons
  insertRule """
    @font-face {
      font-family: "Flat-UI-Icons";
      src: url(#{chrome.extension.getURL("font/flat-ui-icons.woff")}) format("woff");
      font-weight: normal;
      font-style: normal;
    }
  """

  {}