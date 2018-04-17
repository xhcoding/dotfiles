
(package! gruvbox-theme)
(package! doom-themes :ignore t)

(package! lsp-mode)
(package! lsp-ui)

(when (featurep! :completion company)
  (package! company-lsp))

(package! auto-save :ignore t)
(package! visual-regexp)
(package! visual-regexp-steroids)

(package! keyfreq)

(package! emms)
