###
댓글 뷰어 모듈
###
define [
  "jquery"
], ($) ->
  
  LOADING_HTML = "<li>작성자의 다른 댓글 목록을 불러오는 중입니다.</li>"

  _$overlay = $('<div id="__list-viewer-overlay">')
  _$modal = $('<div id="__list-viewer-modal"><ul></ul></div>')

  _currentModalTop = 0;

  _$modal.appendTo document.body
  _$overlay.appendTo document.body

  _$overlay.click (e) ->
    _$overlay.hide()
    _$modal.find("> ul").empty()
    _$modal.hide()
    e.preventDefault()


  modal: _$modal

  # 로딩 문구를 표시하는 뷰어를 top 위치에 표시한다.
  loading: (top) ->
    _$overlay.show()
    @print(LOADING_HTML)

    _$modal.show()
    _$modal.offset top: top
    _currentModalTop = top # 현재 위치를 캐시해둔다.

  # 실제 댓글 내용을 출력한다.
  # 댓글 내용이 길어질 경우가 있으므로, 위치를 조정한다.
  print: (html) ->
    _$modal.find("> ul").html(html)

    hDoc = $(document).height()
    hModal = _$modal.height()

    if _currentModalTop + hModal > hDoc
      _$modal.offset top: _currentModalTop - hModal

  # 더보기 버튼에 덧붙인다.
  update: (html) ->
    _$modal.find(".more").replaceWith(html)

