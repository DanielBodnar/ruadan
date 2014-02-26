javascript:(function () {
  "use strict";
  var ga = document.createElement('script');
  ga.type = 'text/javascript';
  ga.async = false;
  ga.src = ('http://127.0.0.1:3000/build/recorder.js');
  document.getElementsByTagName("head")[0].appendChild(ga);
})();