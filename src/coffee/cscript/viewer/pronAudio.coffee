###
단어 발음 사운드 재생을 위한 모듈
###
define [
  "jquery"
], ($) ->

  play = (audioIdx) ->
    # 인덱스가 없는 경우 0으로 설정 (첫번째 엘리먼트를 찾는다) 
    audioIdx or= 0
    $button = $(".audio-idx-#{audioIdx}")
    
    # 오디오 엘리먼트가 없을 경우 재생하지 않는다.
    return unless $button.length

    audioSrc = $button.data("audio-src")
    $audio = $("<audio>").attr("src", audioSrc)
    
    # 오디오 재생에 따른 이벤트
    # 한 번만 실행하고 삭제한다.
    $audio.one
      playing: ->
        $button.addClass "on"

      ended: ->
        $button.removeClass "on"
        $audio[0].pause() # 재생이 종료되면 pause 상태로 만든다.

    $audio[0].play()

  return (
    play: play
  )
