;; -*- no-byte-compile: t; -*-
;;; private/my-lang/packages.el



(package! ccls :recipe (:fetcher github :repo "MaskRay/emacs-ccls"))

(package! lsp-python :recipe (:fetcher github :repo "emacs-lsp/lsp-python"))

(package! lsp-java :recipe (:fetcher github :repo "emacs-lsp/lsp-java"))

(package! lsp-javascript :recipe (:fetcher github :repo "emacs-lsp/lsp-javascript") :ignore t)

