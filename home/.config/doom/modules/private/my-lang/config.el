;;; private/my-lang/config.el -*- lexical-binding: t; -*-

(def-package! google-c-style
  :config
  (add-hook! (c-mode c++-mode) #'google-set-c-style))

(after! cc-mode
  (add-hook! 'c-mode-common-hook #'flycheck-mode))

(def-package! ccls
  :init
  (add-hook! (c-mode c++-mode) #'+my-lang-ccls-enable)
  :config
  ;; overlay is slow
  ;; Use https://github.com/emacs-mirror/emacs/commits/feature/noverlay
  ;; (setq ccls-sem-highlight-method 'font-lock)
  ;; (ccls-use-default-rainbow-sem-highlight)
  (setq ccls-executable "/usr/bin/ccls")
  (setq ccls-extra-args '("--log-file=/tmp/cq.log"))
  (setq ccls-extra-init-params
        '(:completion (:detailedLabel t) :xref (:container t)
                      :diagnostics (:frequencyMs 5000)))
  (add-to-list 'projectile-globally-ignored-directories ".ccls-cache")
  (set! :company-backend '(c-mode c++-mode) '(company-lsp))
  )

(after! projectile
  (setq projectile-project-root-files-top-down-recurring
        (append '("compile_commands.json"
                  ".ccls_root")
                projectile-project-root-files-top-down-recurring)))


(def-package! lsp-python
  :after python
  :init
  (add-hook! 'python-mode-hook #'lsp-python-enable)
  :config
  (set! :company-backend 'python-mode '(company-lsp))
  )

(def-package! lsp-java
  :init
  (add-hook! java-mode #'+my-lang-lsp-java-enable)
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
            (lambda!()
                (add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex --synctex=1 %(mode)%' %t" TeX-run-TeX nil t))
                (setq TeX-command-default "XeLaTeX"))))

(after! lsp-ui
  (set! :lookup '(c-mode c++-mode java-mode python-mode)
    :definition #'lsp-ui-peek-find-definitions
    :references #'lsp-ui-peek-find-references))
