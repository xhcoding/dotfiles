;;; init.el -*- lexical-binding: t; -*-

;; 一些目录
(defvar +my-site-lisp-dir (expand-file-name "~/.config/doom/site-lisp"))
(defvar +my-yas-snipper-dir (expand-file-name "~/.config/doom/snippets"))
(defvar +my-org-dir (expand-file-name "~/Documents/Org/"))

(defvar +my-auto-save-timer nil)


;; package archives
(setq package-archives '(("gnu"   . "http://elpa.emacs-china.org/gnu/")
                         ("melpa" . "http://elpa.emacs-china.org/melpa/")
			             ("org"   . "http://elpa.emacs-china.org/org/")))


(setq doom-line-numbers-style nil)

(setq user-full-name "xhcoding"
      user-mail-address "xhcoding@163.com")


(doom!
 :feature
 debugger
 eval              ; run code, run (also, repls)
 (evil +everywhere); come to the dark side, we have cookies
 snippets          ; my elves. They type so I don't have to
 lookup
 (syntax-checker   ; tasing you for every semicolon you forget
  +childframe)     ; use childframes for (error "" &optional ARGS) popups (Emacs 26+ only)

 :completion
 (company           ; the ultimate code completion backend
  +auto
  )
 (ivy               ; a search engine for love and life
  +fuzzy
  +childframe)

 :ui
 doom              ; what makes DOOM look the way it does
 doom-dashboard    ; a nifty splash screen for Emacs
 doom-modeline     ; a snazzy Atom-inspired mode-line
 doom-quit         ; DOOM quit-message prompts when you quit Emacs
 hl-todo           ; highlight TODO/FIXME/NOTE tags
 nav-flash         ; blink the current line after jumping
 evil-goggles      ; display visual hints when editing in evil
 (window-select +ace-window)  ; visually switch windows
 (popup            ; tame sudden yet inevitable temporary windows
  +all             ; catch all popups that start with an asterix
  +defaults)       ; default popup rules

 :emacs
 dired             ; making dired pretty [functional]
 ;term              ; terminals in Emacs
 eshell


 :tools
 magit
 ;;pdf               ; pdf enhancements

 :lang
 cc                ; C/C++/Obj-C madness
 python            ; beautiful is better than ugly
 emacs-lisp        ; drown in parentheses
 (latex            ; writing papers in Emacs has never been so fun
  +okular
  )
 (org              ; organize your plain life in plain text
  +attach          ; custom attachment system
  +babel           ; running code in org
  +capture         ; org-capture in and outside of Emacs
  +export          ; Exporting org to whatever you want
  +present         ; Emacs for presentations
  +publish)        ; Emacs+Org as a static site generator
 plantuml          ; diagrams for confusing people more
 web

 :app
 rss               ; emacs as an RSS reader

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


