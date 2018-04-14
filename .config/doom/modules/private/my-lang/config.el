;;; private/my-lang/config.el -*- lexical-binding: t; -*-


(after! cc-mode
  ;; https://github.com/radare/radare2
  (c-add-style
   "radare2"
   '((c-basic-offset . 2)
     (indent-tabs-mode . t)
     (c-auto-align-backslashes . nil)
     (c-offsets-alist
      (arglist-intro . ++)
      (arglist-cont . ++)
      (arglist-cont-nonempty . ++)
      (statement-cont . ++)
      )))
  (c-add-style
   "my-cc" '("user"
             (c-basic-offset . 4)
             (c-offsets-alist
              . ((innamespace . 0)
                 (access-label . -)
                 (case-label . 0)
                 (member-init-intro . +)
                 (topmost-intro . 0)
                 (arglist-cont-nonempty . +)))))
  (setq c-default-style "my-cc"
        c-tab-always-indent t)
  (add-hook 'c-mode-common-hook (lambda ()
                                  (c-set-style "my-cc")
                                  (flycheck-mode t)))
  (add-hook 'c-mode-common-hook #'+my/toggle-auto-save))


(def-package! clang-format
  :commands (clang-format-region)
  )


(def-package! ccls
  :init
  (add-hook 'c-mode-hook #'ccls//enable)
  (add-hook 'c++-mode-hook #'ccls//enable)
  :config
  ;; overlay is slow
  ;; Use https://github.com/emacs-mirror/emacs/commits/feature/noverlay
  (setq ccls-sem-highlight-method 'font-lock)
  (ccls-use-default-rainbow-sem-highlight)
  (setq ccls-executable "/usr/bin/ccls")
  (setq ccls-extra-args '("--record=/tmp/ccls"))
  (setq ccls-extra-init-params
        '(:completion (:detailedLabel t) :xref (:container t)
                      :diagnostics (:frequencyMs 5000)))
  (add-to-list 'projectile-globally-ignored-directories ".ccls_cache")
  (add-to-list 'projectile-globally-ignored-directories "build")
  (set! :company-backend '(c-mode c++-mode) '(company-lsp))
  )



(def-package! lsp-python
  :after python
  :init
  (add-hook! 'python-mode-hook #'lsp-python-enable)
  :config
  (set! :company-backend 'python-mode '(company-lsp))
  )

(def-package! lsp-java
  :init
  (add-hook 'java-mode-hook #'lsp-java-enable)
  :config
  (setq lsp-java-server-install-dir
        (expand-file-name (concat doom-etc-dir "eclipse.jdt.ls/server/")))
  (setq lsp-java-workspace-dir
        (expand-file-name (concat doom-etc-dir "workspace/")))
  )

(def-package! lsp-javascript-typescript
  :disabled t
  :config
  (add-hook 'js-mode-hook #'lsp-javascript-typescript-enable)
  (add-hook 'typescript-mode-hook #'lsp-javascript-typescript-enable) ;; for typescript support
  (add-hook 'js3-mode-hook #'lsp-javascript-typescript-enable) ;; for js3-mode support
  (add-hook 'rjsx-mode #'lsp-javascript-typescript-enable) ;; for rjsx-mode support
  )

(after! latex
  (add-hook 'LaTeX-mode-hook
            (lambda()
              (add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex --synctex=1 %(mode)%' %t" TeX-run-TeX nil t))
              (setq TeX-command-default "XeLaTeX"))))
