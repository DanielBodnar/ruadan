# Ruadan
## Analytics like a boss

# What/Why

Provide a website owner a new, easy, way to really track what a user has been doing on their website by providing a movie of the user interaction on the page.

# How

By recording various user interactions, like:

* scrolling
* screen size
* mouse movement
* selection
* DOM mutations

We can serialize and see what exactly a user been doing on your website, to later on replay that.

# Using

## Redis
Ruadan uses [Redis](http://redis.io/) as a backend storage, so make sure you install it first.
On Mac OS, `brew install redis` ought to do it. See more info [here](http://redis.io/download).

To run the server, run `redis-server`

Currently, only the redis running on the local machine is supported.

## Running

Create a bookmarklet that begins recording:

```
javascript:(function () {  
	var ga = document.createElement('script');  
	ga.type = 'text/javascript';  
	ga.async = true;  
	ga.src = ('http://127.0.0.1:3000/build/recorder.js');
	document.getElementsByTagName("head")[0].appendChild(ga);
})()
```


Clone the project and initialize the server by simply running

```
> gulp
```

Go to some site, preferebly a single page application site, and click the record bookmarklet.
After you're done recording, goto: ``` http://127.0.0.1:3000/replay ```
You should see the replay of your interaction.

# Limitations

* Ruadan does not serialize images/assets/fonts, so it'll get them again from your server
* Iframes are not serialized, tracked
* Flash is not supported
