###
백그라운드 작업의 메인 모듈
###
require [
  "jquery"
  "common/pubsub"
  "bg/ga"
], ($, pubsub, ga) ->

  _lastParam = null

  # 사용자 댓글을 요청한다.
  # 모바일 뉴스의 API를 사용해 요청한다.
  requestComments = (data) ->
    param = _lastParam =
      gno: data.gno
      sort: "newest"
      page: data.page or 1
      pageSize: 20
      commentNo: data.commentNo
      replyNo: ""
      serviceId: "news"

    $.ajax(
      type: "POST"
      url: "http://m.news.naver.com/api/usercontent/comment.json"
      crossDomain: true
      data: param
      timeout: 3000

      success: (res) ->
        return unless res and res.message

        message = res.message

        if message.error
          return pubsub.pub "*-comments-denied", message.error

        if data.page
          pubsub.pub "*-more-comments-searched", message.result
        else
          pubsub.pub "*-comments-searched", message.result

      error: ->
        pubsub.pub "*-comments-error"
    )

  # 마지막으로 보낸 파라미터로 다음 페이지를 요청한다.
  requestNextPageComments = (currentPage) ->
    data = _lastParam
    data.page = currentPage + 1
    
    requestComments data


  # 메시지 규칙
  # 1. 완료형으로만 보낸다.
  # 2. 소문자와 대시(-)를 사용한다.
  # 3. 컨텐트 스크립트에서 보낸 경우, 앞에 @- 를 붙인다.
  # 4. 백그라운드에서 보낸 경우, 앞에 *- 를 붙인다.

  pubsub.sub "@-user-selected", (data) ->
    ga.push "_trackEvent", "comments request", "new"
    requestComments data

  pubsub.sub "@-more-button-clicked", (data) ->
    ga.push "_trackEvent", "comments request", "more"
    requestNextPageComments data.currentPage
