---
title: XMonad on Ubuntu 12.04
author: Carlos López Camey
date: May 27, 2012
lang: en
tags: xmonad,ubuntu
---

I upgraded to Ubuntu 12.04; configuring xmonad took longer than expected. How it worked for me:

 0. If you are planning to use multiple monitors/xmonad-contrib, I had to:

        sudo apt-get install libxinerama-dev libxft-dev zlib1g-dev libxft-dev libxrandr-dev

 1. Install `xmonad` and xmonad-contrib`, either with <a href="#ref0">cabal <sup id="sup0">[0]</sup></a> or `apt-get`. I prefer cabal:

        cabal install xmonad
    	cabal install xmonad-contrib

 2. Write a file to `/usr/share/xsessions/gnome-xmonad.desktop` containing:
        
        [Desktop Entry]
        Name=XMonad
        Icon=
        Comment=Tiling wm
        TryExec=/usr/bin/gnome-session
        Exec=gnome-session --session=xmonad
        Type=XSession

 3. Write a file to `/usr/share/gnome-session/sessions/xmonad.session` containing:'

        [GNOME Session]
        Name=Xmonad/GNOME
        RequiredComponents=gnome-settings-daemon;unity-2d-panel;
        RequiredProviders=windowmanager;
        DefaultProvider-windowmanager=xmonad

 4. Write a file to `/usr/share/applications/xmonad.desktop`, 

        [Desktop Entry]
        Name=xmonad
        Exec=/home/you/.xmonad/xmonad.start  #path to your init script
        Icon=
        Terminal=false
        Type=Application
        StartupNotify=false
        Categories=
        NoDisplay=true

    Note: Instead of a path to your init script (be sure it has +x flags), you might write only `Exec=xmonad` or `Exec=/home/you/.cabal/bin/xmonad`. Whatever works for you, I had to play with this bit in my laptop (see *Notes*).

 5. Tell xmonad to ignore the unity panel, in your .xmonad.hs, add:

        myManageHook = composeAll [
           manageHook gnomeConfig
         , className =? "Unity-2d-panel" --> doIgnore
        ]

        main = xmonad gnomeConfig { manageHook = myManageHook }

 6. Test it: Logout and login with the xmonad session.
    
     *Notes*
 
     * Troubleshooting: If xmonad doesn't start, add your `xmonad.start` script to Startup Applications (on the Unity panel), this was needed in my laptop but not in my desktop, I didn't debug further really.

     * You could also install `gnome-panel` and use it instead of `Unity-2d-panel`. For me, it didn't work well with xinerama. You would have to replace the appropiate lines in `xmonad.session` and `xmonad.hs`. 

     * You could try to have "Unity-2d-shell" as well (the dock and launcher popup from Unity), but it didn't work at its best, see [Avgoustinos Kadis's comment](http://markhansen.co.nz/xmonad-ubuntu-oneiric/#comment-529395079) for help.

<span id="ref0"[0]</span> <a href="#sup0">↑</a> `sudo apt-get install cabal-install` or via the [Haskell Platform](http://hackage.haskell.org/platform/)
