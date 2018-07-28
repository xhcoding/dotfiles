;;; config/private/+ui.el -*- lexical-binding: t; -*-
(load! "+bindings")
(load! "+ui")
(load! "+org")


;; remove doom advice, I don't need deal with comments when newline
(advice-remove #'newline-and-indent #'doom*newline-and-indent)

;; Reconfigure packages
(after! evil-escape
  (setq evil-escape-key-sequence "jk"))

(after! projectile
  (setq projectile-require-project-root t))

(after! company
  (setq company-minimum-prefix-length 2
        company-tooltip-limit 10
        company-show-numbers t
        company-global-modes '(not comint-mode erc-mode message-mode help-mode gud-mode)
        )
  (map! :map company-active-map
        "M-g" #'company-abort
        "M-d" #'company-next-page
        "M-u" #'company-previous-page))


(def-package! lsp-mode
  :config
  (setq lsp-project-blacklist '("^/usr/")
        lsp-highlight-symbol-at-point nil)
  (add-hook 'lsp-after-open-hook 'lsp-enable-imenu))

(def-package! company-lsp
  :after company
  :init
  (setq company-lsp-cache-candidates nil))

(def-package! lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-sideline-enable nil
        lsp-ui-sideline-show-symbol nil
        lsp-ui-sideline-show-symbol nil
        lsp-ui-sideline-ignore-duplicate t
        lsp-ui-doc-max-width 50
        )
  (map!
   :map lsp-ui-peek-mode-map
   "h" #'lsp-ui-peek--select-prev-file
   "j" #'lsp-ui-peek--select-next
   "k" #'lsp-ui-peek--select-prev
   "l" #'lsp-ui-peek--select-next-file
   ))


(def-package! auto-save
  :load-path +my-site-lisp-dir
  :config
  (setq auto-save-slient t))

(def-package! visual-regexp
  :config
  (require 'visual-regexp))

(after! emacs-snippets
  (add-to-list 'yas-snippet-dirs +my-yas-snipper-dir))


(after! smartparens
  (define-advice show-paren-function (:around (fn) fix-show-paren-function)
    "Highlight enclosing parens"
    (cond ((looking-at-p "\\s(") (funcall fn))
	      (t (save-excursion
		       (ignore-errors (backward-up-list))
		       (funcall fn)))))
  (sp-local-pair 'cc-mode "(" nil :actions nil)
  (sp-local-pair 'cc-mode "[" nil :actions nil)
  )


(def-package! company-english-helper
  :load-path +my-site-lisp-dir
  :config
  (map!
   (:leader
     (:prefix "t"
       :n     "e"     #'toggle-company-english-helper))))

(def-package! company-posframe
  :after company
  :hook (company-mode . company-posframe-mode))


(defun +advice/xref-set-jump (&rest args)
  (lsp-ui-peek--with-evil-jumps (evil-set-jump)))
(advice-add '+lookup/definition :before #'+advice/xref-set-jump)
(advice-add '+lookup/references :before #'+advice/xref-set-jump)


(defvar +my/xref-blacklist nil
  "List of paths that should not enable xref-find-* or dumb-jump-go")

(after! xref
  (setq xref-prompt-for-identifier '(not xref-find-definitions
                                         xref-find-definitions-other-window
                                         xref-find-definitions-other-frame
                                         xref-find-references))

  (defun xref--show-xrefs (xrefs display-action &optional always-show-list)
    (lsp-ui-peek--with-evil-jumps (evil-set-jump))

    (if (not (cdr xrefs))
        (xref--pop-to-location (car xrefs) display-action)
      (funcall xref-show-xrefs-function xrefs
               `((window . ,(selected-window))))
      ))
  )

(after! ivy-xref
  (push '(ivy-xref-show-xrefs . nil) ivy-sort-functions-alist)
  )


(def-package! eaf
  :load-path (lambda()(concat +my-site-lisp-dir "/emacs-application-framework")))

(def-package! scroll-other-window
  :load-path +my-site-lisp-dir
  :config
  (sow-mode 1)
  (map!
   :gnvime "<M-up>"    #'sow-scroll-other-window-down
   :gnvime "<M-down>"  #'sow-scroll-other-window))


(def-package! openwith
  :load-path +my-site-lisp-dir
  :config
  (setq openwith-associations
        '(
          ("\\.pdf\\'" "okular" (file))
          ("\\.docx?\\'" "wps" (file))
          ("\\.pptx?\\'" "wpp" (file))
          ("\\.xlsx?\\'" "et" (file))))
  (add-hook! :append 'emacs-startup-hook #'openwith-mode)
  )

(def-package! org-edit-latex)

(set-popup-rules!
  '(("^\\*helpful" :size 0.6)
    ("^\\*info\\*$" :size 0.6)
    ("^\\*.*Octave\\*$" :size 0.5 :side right)
    ("^\\*doom \\(?:term\\|eshell\\)" :size 0.4)))

(set-lookup-handlers! 'emacs-lisp-mode :documentation #'helpful-at-point)
