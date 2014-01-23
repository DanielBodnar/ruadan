javascript:(function () {
  var ga = document.createElement('script');
  ga.type = 'text/javascript';
  ga.async = true;
  ga.setAttribute('data-main', 'http://127.0.0.1:3000/build/bootstrap_recorder.js');
  ga.src = ('http://127.0.0.1:3000/requirejs/require.js');
  document.getElementsByTagName("head")[0].appendChild(ga);
})()
