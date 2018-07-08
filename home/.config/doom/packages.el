;; -*- no-byte-compile: t; -*-
;;; config/private/packages.el


;; disable some packages
(disable-packages! smex
                   irony
                   irony-eldoc
                   flycheck-irony
                   company-irony
                   company-irony-c-headers
                   rtags
                   ivy-rtags
                   anaconda-mode
                   company-anaconda
                   doom-theme
                   )



(package! gruvbox-theme)

(package! lsp-mode)
(package! lsp-ui)

(when (featurep! :completion company)
  (package! company-lsp))


(package! auto-save :ignore t)

(package! visual-regexp)
(package! visual-regexp-steroids)

(package! company-english-helper :ignore t)
