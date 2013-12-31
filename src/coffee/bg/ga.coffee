_gaq = _gaq or []

define ->
  _gaq.push ["_setAccount", "UA-30985671-4"]
  _gaq.push ["_trackPageview"]

  `
  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ga.src = 'https://ssl.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
  `

  push: (args...) ->
    _gaq.push args