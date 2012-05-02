---
title: Call org-mobile-push automatically after saving an org-file
author: Carlos López
date: May 01, 2012
lang: en
tags: emacs,org-mode,elisp
---
If you use org-mobile from org-mode to synchronize your notes with your phone, you might find this useful.

This function calls `org-mobile-push` whenever you save a file whose name matches some filename in `org-directory`.

You can add it to your `.emacs`, and do `M-x eval-buffer` in order to take it into effect.

~~~~~{.CommonLisp}
;; automatically org-mobile-push on save of a file
(add-hook 
 'after-save-hook 
 (lambda ()
   (let (
         (org-filenames (mapcar 'file-name-nondirectory (directory-files org-directory))) ; list of org file names (not paths)
         (filename (file-name-nondirectory buffer-file-name)) ; list of the buffers filename (not path)
         )
     (if (find filename org-filenames :test #'string=)
         (org-mobile-push)        
       )
     )
   )
)
~~~~~


*NOTE:* if you want to use your `org-agenda-files` instead (the exact list of files being pushed), we'd need to change the line

~~~~~{.CommonLisp}
(org-filenames (mapcar 'file-name-nondirectory (directory-files org-directory)))
~~~~~

to

~~~~~{.CommonLisp}
(org-filenames (mapcar 'file-name-nondirectory org-agenda-files))
~~~~~

That's it. Be sure to add it after you defined the variable `'org-agenda-files`.
