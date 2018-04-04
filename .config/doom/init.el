;;; init.el -*- lexical-binding: t; -*-



(defvar my-site-lisp-dir (expand-file-name "~/.config/doom/site-lisp"))
(defvar my-auto-save-timer nil)
(defvar my-yas-snipper-dir (expand-file-name "~/.config/doom/snippets"))


;; package archives
(setq package-archives '(("gnu"   . "http://elpa.emacs-china.org/gnu/")
                         ("melpa" . "http://elpa.emacs-china.org/melpa/")
			             ("org"   . "http://elpa.emacs-china.org/org/")))


(setq doom-line-numbers-style nil)

(setq user-full-name "xhcoding"
      user-mail-address "xhcoding@163.com")


;; disable some packages
(disable-packages! smex
                   irony
                   irony-eldoc
                   flycheck-irony
                   company-irony
                   company-irony-c-headers
                   rtags
                   ivy-rtags
                   anaconda-mode
                   company-anaconda
                   )

(doom!
 :feature
 (popup            ; tame sudden yet inevitable temporary windows
  +all             ; catch all popups that start with an asterix
  +defaults)       ; default popup rules
 (evil +everywhere); come to the dark side, we have cookies
 snippets          ; my elves. They type so I don't have to
 syntax-checker    ; tasing you for every semicolon you forget
 look-up

 :completion
 company           ; the ultimate code completion backend
 ivy               ; a search engine for love and life

 :ui
 doom              ; what makes DOOM look the way it does
 doom-dashboard    ; a nifty splash screen for Emacs
 doom-modeline     ; a snazzy Atom-inspired mode-line
 doom-quit         ; DOOM quit-message prompts when you quit Emacs
 hl-todo           ; highlight TODO/FIXME/NOTE tags
 nav-flash         ; blink the current line after jumping
 evil-goggles      ; display visual hints when editing in evil
 (window-select +ace-window)  ; visually switch windows

 :tools
 dired             ; making dired pretty [functional]
 magit
 pdf               ; pdf enhancements
 term              ; terminals in Emacs

 :lang
 cc                ; C/C++/Obj-C madness
 python            ; beautiful is better than ugly
 emacs-lisp        ; drown in parentheses
 latex             ; writing papers in Emacs has never been so fun
 (org              ; organize your plain life in plain text
  +attach          ; custom attachment system
  +babel           ; running code in org
  +capture         ; org-capture in and outside of Emacs
  +export          ; Exporting org to whatever you want
  +present         ; Emacs for presentations
  +publish)        ; Emacs+Org as a static site generator
 plantuml          ; diagrams for confusing people more

 :app
 (rss +org)        ; emacs as an RSS reader

 :config
 ;; The default module set reasonable defaults for Emacs. It also provides
 ;; a Spacemacs-inspired keybinding scheme, a custom yasnippet library,
 ;; and additional ex commands for evil-mode. Use it as a reference for
 ;; your own modules.
 (default +bindings +snippets +evil-commands)

 :private
 my-lang
 my-blog
 )


