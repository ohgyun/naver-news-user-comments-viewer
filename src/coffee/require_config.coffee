# RequireJS 모듈 설정
requirejs.config
  baseUrl: "vendor"
  paths:
    common: "../js/common"
    bg: "../js/bg"
    cscript: "../js/cscript"
    tmpl: "../js/tmpl"
  shim:
    underscore:
      exports: "_"
    handlebars:
      exports: "Handlebars"