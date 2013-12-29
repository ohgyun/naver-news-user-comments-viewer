네이버 영어사전 크롬 익스텐션
=============================

크롬 브라우저에서 영어 단어의 뜻과 예문을 쉽게 찾을 수 있도록 도와주는  
네이버 영어사전 크롬 익스텐션(Naver English Dictionary Chrome Extension)입니다.

## 소개
- [익스텐션 설치](http://chrome.google.com/webstore/detail/jfibpeiddefellcfgnijpcpddoimbdij)
- [익스텐션 소개](https://github.com/ohgyun/nendic-ext/wiki/%EB%84%A4%EC%9D%B4%EB%B2%84-%EC%98%81%EC%96%B4%EC%82%AC%EC%A0%84-%ED%81%AC%EB%A1%AC-%EC%9D%B5%EC%8A%A4%ED%85%90%EC%85%98)
- [버전 히스토리](https://github.com/ohgyun/nendic-ext/wiki/%EB%B2%84%EC%A0%84-%ED%9E%88%EC%8A%A4%ED%86%A0%EB%A6%AC)


## 로컬에서 개발
리파지터리를 클론하고,  
````
$ git clone git@github.com:ohgyun/nendic-ext.git
````

`npm`으로 의존 모듈을 설치합니다.  
````
$ cd nendic-ext
$ npm install
````
  
크롬 브라우저의 `Tools > Extensions > Load unpacked extension...` 메뉴에서,  
`nendic-ext/src` 디렉토리를 추가합니다.


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
준비한 코드는 `Load unpaced extension` 메뉴에서 `nendic-ext/build` 디렉토리를 추가해 확인할 수 있습니다.


### grunt release
`$ grunt release`  


`build` 디렉토리를 기준으로 웹스토어에 배포하기 위한 압축 파일(`zip`)을 생성합니다.


## 기부하기
영어사전 익스텐션 잘 사용하고 계신가요?  
앞으로도 잘 유지해나갈 수 있게 응원해주세요.

- 페이팔로 커피 한 잔($5) 사주기  
[![페이팔로 기부하기](https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=BKCKZJK5YBC24&lc=KR&item_name=Naver%20English%20Dictionary%20Chrome%20Extension&item_number=nendic%2dext&amount=5%2e00&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donate_LG%2egif%3aNonHosted)


