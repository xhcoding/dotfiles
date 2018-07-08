;;; config/private/+ui.el -*- lexical-binding: t; -*-
(load! "+bindings")
(load! "+ui")

;; remove doom advice, I don't need deal with comments when newline
(advice-remove #'newline-and-indent #'doom*newline-and-indent)

;; Reconfigure packages
(after! evil-escape
  (setq evil-escape-key-sequence "jk"))

(after! projectile
  (setq projectile-require-project-root t))


(after! org
  (setq org-ellipsis " ▼ "
        org-ditaa-jar-path doom-etc-dir)
  (setcar (nthcdr 0 org-emphasis-regexp-components) " \t('\"{[:nonascii:]")
  (setcar (nthcdr 1 org-emphasis-regexp-components) "- \t.,:!?;'\")}\\[[:nonascii:]")
  (org-set-emph-re 'org-emphasis-regexp-components org-emphasis-regexp-components)
  (org-element-update-syntax))

(after! company
  (setq company-minimum-prefix-length 2
        company-tooltip-limit 10
        company-show-numbers t
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


(set-popup-rules!
  '(("^\\*helpful" :size 0.4)
    ("^\\*info\\*$" :size 0.4)
    ("^\\*doom \\(?:term\\|eshell\\)" :size 0.4)))

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
