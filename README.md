# Ruadan
## Analytics like a boss

# What/Why

The main idea is to provide a website owner a new, easy, way to really track what a user has been doing on their website by providing a movie of the user interaction on the page.

# How

By recording various user interactions, like:

* scrolling
* screen size
* mouse movement
* selection
* DOM mutations

We can serialize and see what exactly a user been doing on your website, to later on replay that.

# Using

Create a bookmarklet that begins recording:

```
javascript:(function () {  
	var ga = document.createElement('script');  
	ga.type = 'text/javascript';  
	ga.async = true;  
	ga.setAttribute('data-main', 'http://127.0.0.1:3000/build/bootstrap_recorder.js');  
	ga.src = ('http://127.0.0.1:3000/requirejs/require.js');  
	document.getElementsByTagName("head")[0].appendChild(ga);
})()
```


Clone the project and initialize the server by simple running

```
> grunt
```

Go to some site, preferebly a single page application site, and click the record bookmarklet.
After you're done recording, goto: ``` http://127.0.0.1:3000/replay ```
You should see the replay of your interaction.

# Limitations

* Ruadan does not serialize images/assets/fonts, so it'll get them again from your server
* Iframes are not serialized, tracked
* Flash is not supported
