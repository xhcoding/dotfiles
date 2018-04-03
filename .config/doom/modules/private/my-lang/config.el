;;; private/my-lang/config.el -*- lexical-binding: t; -*-



;; (def-package! cquery
;;   :init
;;   (add-hook! 'c-mode-common-hook #'lsp-cquery-enable)
;;   :config
;;   (require 'cquery)
;;   (setq cquery-executable
;; 	  "/usr/bin/cquery")
;;   ;; (setq cquery-sem-highlight-method 'font-lock)
;;   ;; (cquery-use-default-rainbow-sem-highlight)
;;   (setq cquery-extra-init-params
;;         '(:cacheFormat "msgpack" :completion (:detailedLabel t) :xref (:container t)
;;                        :diagnostics (:frequencyMs 5000)))
;;   ;;(require 'projectile)
;;   (add-to-list 'projectile-globally-ignored-directories ".cquery_cached_index")
;;   (add-to-list 'projectile-globally-ignored-directories "build")
;;   (set! :company-backend 'c-mode '(company-lsp))
;;   (set! :company-backend 'c++-mode '(company-lsp))
;;   )

(defvar +my-lang/ccls-blacklist '("^/usr/") ".")

(def-package! ccls
  :init
  (add-hook 'c-mode-hook #'+ccls//enable)
  (add-hook 'c++-mode-hook #'+ccls//enable)
  :config
  ;; overlay is slow
  ;; Use https://github.com/emacs-mirror/emacs/commits/feature/noverlay
  (setq ccls-executable "/home/xhcoding/Code/CCPro/ccls/release/ccls")
  (setq ccls-sem-highlight-method 'font-lock)
  (ccls-use-default-rainbow-sem-highlight)
  (setq ccls-extra-init-params
        '(:cacheFormat "msgpack" :completion (:detailedLabel t) :xref (:container t)
                       :diagnostics (:frequencyMs 5000)))

  (add-to-list 'projectile-globally-ignored-directories ".ccls-cache")

  (evil-set-initial-state 'ccls-tree-mode 'emacs)
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
