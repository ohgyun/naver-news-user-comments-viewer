네이버 뉴스 사용자 댓글 보기
=====================

네이버 뉴스에서 댓글 작성자의 다른 댓글 목록을 쉽게 볼 수 있는 크롬 익스텐션입니다.


## 로컬에서 개발
리파지터리를 클론하고,  
````
$ git clone git@github.com:ohgyun/naver-news-user-comments-viewer.git
````

`npm`으로 의존 모듈을 설치합니다.  
````
$ cd nendic-ext
$ npm install
````
  
크롬 브라우저의 `Tools > Extensions > Load unpacked extension...` 메뉴에서,  
`src` 디렉토리를 추가합니다.


## 빌드
네이버 영어사전 익스텐션은 그런트로 빌드합니다.  

그런트가 설치되어 있지 않다면, 아래 명령으로 설치할 수 있습니다.  
````
$ npm install grunt-cli -g
````

자세한 사항은 http://gruntjs.com/ 를 참고하세요.


### grunt build
`$ grunt build`  

스크립트를 압축하고 `build` 디렉토리에 배포용 코드를 생성합니다.  
준비한 코드는 `Load unpaced extension` 메뉴에서 `build` 디렉토리를 추가해 확인할 수 있습니다.


### grunt release
`$ grunt release`  


`build` 디렉토리를 기준으로 웹스토어에 배포하기 위한 압축 파일(`zip`)을 생성합니다.