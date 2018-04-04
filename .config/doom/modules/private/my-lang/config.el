;;; private/my-lang/config.el -*- lexical-binding: t; -*-

(def-package! cquery
  :config
  (add-hook 'c-mode-hook #'lsp-cquery-enable)
  (add-hook 'c++-mode-hook #'lsp-cquery-enable)
  (setq cquery-executable "/usr/bin/cquery")
  (setq cquery-extra-init-params
        '(:cacheFormat "msgpack" :completion (:detailedLabel t) :xref (:container t)
                       :diagnostics (:frequencyMs 5000)))
  (add-to-list 'projectile-globally-ignored-directories ".cquery_cached_index")
  (add-to-list 'projectile-globally-ignored-directories "build")
  (require 'company-lsp)
  (set! :company-backend 'c-mode '(company-lsp))
  (set! :company-backend 'c++-mode '(company-lsp))
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
