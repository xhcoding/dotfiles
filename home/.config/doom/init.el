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



(setq user-full-name "xhcoding"
      user-mail-address "xhcoding@163.com")

;; if lsp-mode enabled failed ,using irony instead
(def-package-hook! irony
  :pre-init
  nil)
(def-package-hook! flycheck-irony
  :pre-init
  nil
  :pre-config
  nil)

(doom!
 :feature
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
 (window-select    ; visually switch windows
  +ace-window)
 (popup            ; tame sudden yet inevitable temporary windows
  +all             ; catch all popups that start with an asterix
  +defaults)       ; default popup rules

 :editor
 format            ; automated prettiness
 multiple-cursors  ; editing in many places at once

 :emacs
 dired             ; making dired pretty [functional]
 ediff             ; comparing files in Emacs
 eshell            ; a consistent, cross-platform shell (WIP)
 hideshow          ; basic code-folding support
 imenu             ; an imenu sidebar and searchable code index
 vc                ; version-control and Emacs, sitting in a tree

 :tools
 magit

 :lang
 (cc               ; C/C++/Obj-C madness
  +irony)
 data              ; config/data formats
 emacs-lisp        ; drown in parentheses
 java              ; the poster child for carpal tunnel syndrome
 (latex            ; writing papers in Emacs has never been so fun
  +okular
  )
 (org              ; organize your plain life in plain text
  +attach          ; custom attachment system
  +babel           ; running code in org
  +capture         ; org-capture in and outside of Emacs
  +export          ; Exporting org to whatever you want
  +present         ; Emacs for presentations
  )
 plantuml          ; diagrams for confusing people more
 python            ; beautiful is better than ugly

 :app

 :collab

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


