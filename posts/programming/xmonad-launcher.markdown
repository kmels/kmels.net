---
title: A Prompt with multiple functionalities in XMonad (XMonad.Actions.Launcher)
author: Carlos López
date: June 23th, 2011
lang: es
tags: xmonad,xmonad-contrib,prompt,xprompt
---

I worked on [xmonad](http://xmonad.org)'s [XPrompt](http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Prompt.html). XPrompt lets you build prompts that are triggered with a combination of keys and might look like this:

<div class="inline-image thumbnail">![Hoogle mode](/images/2012/XMonad.Actions.Launcher-hoogle.png)</div>

You type something and then choose a result from a list of autocompletions. There are [several prompts](http://hackage.haskell.org/packages/archive/xmonad-contrib/0.10/doc/html/XMonad-Prompt.html#t:XPrompt), each with different functionality. 

I extended XPrompt with the function `mkPromptWithModes` which makes it possible to construct a prompt containing more than one mode. The created prompt operates in mode `XPMultipleModes` and allows navigation from one mode to another.

Navigation occurs the key `changeModeKey` in XPConfig [0] is pressed. You can for example switch from mode "locate" (where you search files in your computer) to the mode "calculator", where you do write arithmetic expressions and the prompt autocompletes the result.

I also created the module XMonad.Actions.Launcher to exemplify its usage. It contains two modules:

 * hoogle
 * calc

I know you like screenshots so here is one of calc mode in action:

<div class="inline-image thumbnail">![Calc mode](/images/2012/XMonad.Actions.Launcher-calc.png)</div>

Usage of XMonad.Actions.Launcher
----

In your xmonad.hs, add a key to open the Launcher prompt:

~~~~~{.haskell}
...
import XMonad.Prompt(defaultXPConfig)
import XMonad.Actions.Launcher(defaultLauncherModes,launcherPrompt)
...

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $ [
 ... 
 -- Open a launcher prompt when the keys `Ctrl + Mod + L` are pressed
 , ((modm .|. controlMask, xK_l), launcherPrompt defaultXPConfig (defaultLauncherModes launcherConfig) )
 ...
]
~~~~~

`launcherConfig` holds parameters needed by the default modes:

~~~~~{.haskell}
launcherConfig = LauncherConfig {
  pathToHoogle          = "/path/to/your/hoogle/bin"
  , browser             = "conkeror"
}
~~~~~

The function `launcherPrompt` in XMonad.Actions.Launcher creates (opens) a prompt given a list of modes and a prompt configuration [0]. The function `defaultLauncherModes` has a list of default modes which you can use together with `launcherPrompt`. 

What's next
----
 * Add a regex field to each mode. When typing in a prompt, the autocomplete of the mode that matches the given regex is run.

 * Scrolling support 

 * Add support for modes to display the stdoutput of some program. Useful if we want to run `cabal install xmonad`.

 * Add 'common-tasks' mode that looks in your e.g. ~/.bash_history and autocompletes. Example of common task: `cabal install`. In order to make this good, autocompleting needs the buffer to have the cursor at the completion site. 

[0] XPConfig is the data type for [prompt configuration](http://hackage.haskell.org/packages/archive/xmonad-contrib/latest/doc/html/XMonad-Prompt.html#t:XPConfig) which is used to customize the look of your prompt,  e.g. font size, height of window, highlighting behaviour, etc.
