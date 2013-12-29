###
백그라운드 작업의 메인 모듈
###
require [
  "common/pubsub"
], (pubsub) ->

  console.log "bg start"
  # 메시지 규칙
  # 1. 완료형으로만 보낸다.
  # 2. 소문자와 대시(-)를 사용한다.
  # 3. 컨텐트 스크립트에서 보낸 경우, 앞에 @- 를 붙인다.
  # 4. 백그라운드에서 보낸 경우, 앞에 *- 를 붙인다.
  pubsub.sub "@-user-selected", (commentNo) ->
    console.log "hoho"
    console.log "xxx ", commentNo

  pubsub.pub "*-hoho"