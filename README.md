# Ruadan
## Analytics like a boss

# What/Why

Provide a website owner a new, easy, way to really track what a user has been doing on their website by providing a movie of the user interaction on the page.

Lets say you have a user browsing your website:
![](../master/record.gif)

You can later on see exactly what he was doing on your website(this is done with 0 integration or code change):
![](../master/replay.gif)

# How

By recording various user interactions, like:

* scrolling
* screen size
* mouse movement
* selection
* DOM mutations

and a few more

We can serialize and see what exactly a user been doing on your website, to later on replay that.

# Using

## Redis
Ruadan uses [Redis](http://redis.io/) as a backend storage, so make sure you install it first.
On Mac OS, `brew install redis` ought to do it. See more info [here](http://redis.io/download).

To run the server, run `redis-server`

Currently, only the redis running on the local machine is supported.

## Running

Clone the project and initialize the server by simply running

```
> gulp
```

goto the index page at `http://rlocal/index` and create a bookmarklet for each link


Go to some site, preferably a single page application site.

to record a page do:
- "load"
- "record"

to continue an existing recording(if you got a redirect) call:
- "load"
- "continue"

to stop recording:
- "stop"


After you're done recording, goto: ``` http://rlocal/replay ```

# Limitations

* Ruadan does not serialize images/assets/fonts, so it'll get them again from your server
* Iframes are not serialized or tracked
* Flash is not supported, nor will it be



# TODO
- Many more tests
- Add performance tests
- Finalize the movie creation branch
- Add a storage layer to decouple the recording from transmission to the server


