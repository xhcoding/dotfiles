;; -*- no-byte-compile: t; -*-
;;; config/private/packages.el


;; disable some packages
(disable-packages! irony
                   irony-eldoc
                   flycheck-irony
                   company-irony
                   company-irony-c-headers
                   rtags
                   ivy-rtags
                   doom-themes
                   anaconda-mode
                   company-anaconda
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

(package! company-posframe)

(package! eaf :ignore t)

(package! scroll-other-window :ignore t)

(package! openwith :ignore t)

(package! org-edit-latex)

(package! isolate :recipe (:fetcher github :repo "casouri/isolate"))

(package! yaml-mode)
