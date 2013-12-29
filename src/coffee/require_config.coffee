# RequireJS 모듈 설정
requirejs.config
  baseUrl: "vendor"
  paths:
    common: "../js/common"
    bg: "../js/bg"
    cscript: "../js/cscript"
  shim:
    underscore:
      exports: "_"
