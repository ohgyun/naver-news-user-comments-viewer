module.exports = (grunt) ->

  grunt.initConfig

    # 익스텐션의 매니페스트 파일
    # `package.json`은 빌드에서 사용하지 않는다.
    manifest: grunt.file.readJSON "src/manifest.json"

    clean:
      build: ["build", "src/js", "src/css", "src/tmpl", "release"]

    # 커피스크립트를 `src/js`로 컴파일한다.
    coffee:
      build:
        files: [
            expand: true
            cwd: "src/coffee"
            src: ["**/*.coffee"]
            dest: "src/js"
            ext: ".js"
        ]

    handlebars:
      develop:
        options:
          amd: true
          namespace: "tmpl"
          processName: (filepath) ->
            rName = /\/(\w+).hbs/
            RegExp.$1 if rName.test(filepath)
        files: [
          "src/js/tmpl/tmpl.js": ["src/hbs/*"]
        ]

    less:
      develop:
        files: [
            expand: true
            cwd: "src/less"
            src: ["*.less"]
            dest: "src/css"
            ext: ".css"
        ]

    copy:
      # 이미지와 CSS 파일을 빌드 디렉토리로 복사한다.
      build:
        files: [
            expand: true
            cwd: "src/img"
            src: ["*.jpg", "*.png", "*.gif"]
            dest: "build/img"
          ,
            expand: true
            cwd: "src/css"
            src: ["*.css"]
            dest: "build/css"
          ,
            expand: true
            cwd: "src/font"
            src: ["*.woff"]
            dest: "build/font"
        ]

    # requirejs의 상세한 옵션은 아래 링크를 참고한다.
    # https://github.com/jrburke/r.js/blob/master/build/example.build.js
    requirejs:
      options:
        baseUrl: "src/vendor"
        paths:
          # `require` 라이브러리도 압축 코드에 포함한다.
          requireLib: "require"
        mainConfigFile: "src/js/require_config.js"

      cscript:
        options:
          # 컨텐트 스크립트의 뷰어는 비동기로 로드되기 때문에 의존 목록에 포함되지 않는다.
          # 명시적으로 include에 추가한다.
          include: ["requireLib", "cscript/viewer/viewer"]
          name: "cscript/cscript_main"
          out: "build/js/cscript.min.js"

      bg:
        options:
          include: "requireLib"
          name: "bg/bg_main"
          out: "build/js/bg.min.js"

    "string-replace":
      # 매니페스트 파일의 스크립트 목록 부분을 압축한 스크립트로 대체한다.
      # 컨텐트 스크립트는 "js"로 목록이 구성되어 있고,
      # 백그라운드 스크립트는 "scripts"로 구성되어 있다.
      build:
        options:
          replacements: [
              # cscript
              pattern: /"js"[^\]]+]/
              replacement: "\"js\": [\"js/cscript.min.js\"]"
            ,
              # bg
              pattern: /"scripts"[^\]]+]/
              replacement: "\"scripts\": [\"js/bg.min.js\"]"
          ]

        files:
          "build/manifest.json": "src/manifest.json"

    compress:
      # 빌드 디렉토리를 압축한 후 현재 버전을 붙여 `zip` 파일을 생성한다.
      # 웹 스토어에는 압축한 파일로 등록한다.
      release:
        options:
          archive: "release/naver-news-user-comments-viewer-<%= manifest.version %>.zip"

        files: [
          expand: true
          cwd: "build"
          src: ["**"]
          dest: "./"
        ]


  # NPM 태스크 로드
  grunt.loadNpmTasks task for task in [
    "grunt-contrib-clean"
    "grunt-contrib-copy"
    "grunt-contrib-requirejs"
    "grunt-string-replace"
    "grunt-contrib-less"
    "grunt-contrib-compress"
    "grunt-contrib-coffee"
    "grunt-contrib-handlebars"
  ]


  # 태스크 등록
  grunt.registerTask "default", [
    "coffee"
    "handlebars"
    "less"
  ]
  
  # 빌드 디렉토리로 스크립트를 압축한다.
  grunt.registerTask "build", [
    "clean"
    "default"
    "copy"
    "requirejs"
    "string-replace"
  ]
  
  # 빌드 후 서비스 배포를 위한 `zip` 파일을 생성한다.
  grunt.registerTask "release", [
    "build"
    "compress"
  ]