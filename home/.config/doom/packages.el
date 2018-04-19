;; -*- no-byte-compile: t; -*-
;;; config/private/packages.el

(package! gruvbox-theme)

(package! lsp-mode)
(package! lsp-ui)

(when (featurep! :completion company)
  (package! company-lsp))

(package! auto-save :ignore t)

(package! visual-regexp)
(package! visual-regexp-steroids)

(package! keyfreq)

(package! emms)

