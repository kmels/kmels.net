---
title: Updating mercurial repository after pushing changesets (Debian Lenny)
author: Carlos López Camey
date: April 01, 2011
lang: en
---
Suppose the remote repository (the repository you want to update) is in ''/home/you/hg'' and the user "you" owns the file /home/you/hg/.hg/hgrc

1. Edit /etc/mercurial/hgrc and write:

> [trusted]

> users = you

See [Trusting users](http://mercurial.selenic.com/wiki/Trust") for more info.

2. Then in /home/you/hg/.hg/hgrc write:

> [hooks]

> changegroup = hg update &gt;&amp;2</pre>

as stated [in the mercurial FAQ](http://mercurial.selenic.com/wiki/FAQ#FAQ.2BAC8-CommonProblems.Any_way_to_.27hg_push.27_and_have_an_automatic_.27hg_update.27_on_the_remote_server.3F)

Doing step 2 alone didn't work for me, the hook wasn't being triggered. You can also write

> [ui]

> verbose = true

> debug = true

to "debug" what's happening. By the way, I'm using hgwebdir to serve the repository.

I wrote this a little quick so if you can't get it working, [just ask](/contact.html)! I like helping strangers :)
