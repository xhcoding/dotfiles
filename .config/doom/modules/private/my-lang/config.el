
(after! cc-mode)

(def-package! cquery
  :init
  (add-hook! 'c-mode-common-hook #'lsp-cquery-enable)
  :config
  (require 'cquery)
  (setq cquery-executable
	  "/usr/bin/cquery")
  (setq cquery-sem-highlight-method 'font-lock)
  (cquery-use-default-rainbow-sem-highlight)
  (setq cquery-extra-init-params
        '(:cacheFormat "msgpack" :completion (:detailedLabel t) :xref (:container t)
                       :diagnostics (:frequencyMs 5000)))
  (require 'projectile)
  (add-to-list 'projectile-globally-ignored-directories ".cquery_cached_index")
  (add-to-list 'projectile-globally-ignored-directories "build")
  (set! :company-backend 'c-mode '(company-lsp))
  (set! :company-backend 'c++-mode '(company-lsp))
  )

(def-package! cpputils-cmake
  :config
  (progn
    (add-hook 'c-mode-common-hook
	      (lambda ()
		(if (derived-mode-p 'c-mode 'c++-mode)
		    (cppcm-reload-all)
		  )))))

(def-package! lsp-python
  :after python
  :config
  (add-hook! 'python-mode-hook #'lsp-python-enable)
  (set! :company-backend 'python-mode '(company-lsp))
  )
