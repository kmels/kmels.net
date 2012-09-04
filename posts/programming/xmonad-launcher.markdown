---
title: A Prompt with multiple functionalities in XMonad (XMonad.Actions.Launcher)
author: Carlos López
date: June 23th, 2011
lang: es
---
The sections on this post are independent, you don't need to read one to understand another one but you can read them as they appear.

What is this? 
----- 
I wanted to learn Haskell but I wasn't 100% satisfied with the code I was writing with it so I thought it was better to read other peoples code and learn from the experienced. It helped. 

I worked on [xmonad's](http://xmonad.org) XPrompt. XPrompt lets you build prompts that are triggered with a combination of keys and look like this:

<div class="inline-image thumbnail">![XMonad.Prompt.Shell](/images/2012/XMonad.Prompt.Shell.png)</div>

There are [several prompts](http://hackage.haskell.org/packages/archive/xmonad-contrib/0.10/doc/html/XMonad-Prompt.html#t:XPrompt), each with different functionality. I wanted to write one to search for files (like Spotlight on Mac). At the end I wrote a module that lets you navigate between other prompts, with a key. For example you could change from mode "locate" (where you search files) to the mode "calculator", where you do calculations.

Usage of XMonad.Actions.Launcher
----
The function `launcherPrompt` in XMonad.Actions.Launcher creates (opens) a prompt given a list of modes and a prompt configuration **[0]**. The function `defaultLauncherModes` has a list of default modes which you can use together with `launcherPrompt`. If you want to add a new mode (i.e. made by you/not in the default list), see the last section (Implementation notes).

**[0]** In a [prompt config](http://hackage.haskell.org/packages/archive/xmonad-contrib/latest/doc/html/XMonad-Prompt.html#t:XPConfig) you can customize the look of your prompt,  e.g. font size, height of window, highlighting behaviour, etc.

To use the default modes, rewrite your xmonad.hs:

~~~~~{.haskell}
...
import XMonad.Prompt(defaultXPConfig)
import XMonad.Actions.Launcher
...

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $ [
 ... 
 -- Open a launcher prompt when the keys `Ctrl + Mod + L` are pressed
 , ((modm .|. controlMask, xK_l), launcherPrompt  (defaultLauncherModes launcherConfig) )
 ...
]

launcherConfig = LauncherConfig {
    pathToHoogle = "/home/$YOU/.cabal/bin/hoogle" --path to hoogle's binary (hoogle mode)
    , actionsByExtension  = M.fromList [(".el", \p -> spawn $ "emacsclient " ++ p) --matches emacs lisp files
                                        , (".hs", \p -> spawn $ "emacsclient " ++ p) --matches haskell files
                                        , (".pdf", \p -> spawn $ "acroread " ++ p)
                                        , (".*", \p -> spawn $ "emacsclient " ++ p) --matches any extension
                                        , ("/", \p -> spawn $ "nautilus " ++ p)] --matches directories
   
}
~~~~~

Notes: 
`emacsclient` doesn't spawn another instance (window) of emacs, it opens it in the emacs window where you ran `M-x start-server`.

* The `launcherConfig` uses the default modes. 

* The locate and locate-regex modes are slow but good enough for me now.

Default modes
====

 * hoogle
 * locate
 * locate-regex
 * calc

TODO:
====
 * Add a regex to each mode so that one prompt can identify which autocomplete function must be run.
 * Add scrolling support 
 * Add support for modes to display the stdoutput of some program
 * Add 'common-tasks' mode that looks in your e.g. ~/.bash_history and autocompletes. Example of common task: `cabal install`. In order to make this good, autocompleting needs the buffer to have the cursor at the completion site. 

Implementation notes
----

This are more like notes on XPrompt. I recently read literal haskell and I feel like explaining code, it would have helped me when I started to read the code.

-- This is not finished!