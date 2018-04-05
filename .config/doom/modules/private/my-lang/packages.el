;; -*- no-byte-compile: t; -*-
;;; private/my-lang/packages.el


(package! cquery)

(package! clang-format)

(package! lsp-python :recipe (:fetcher github :repo "emacs-lsp/lsp-python"))

(package! lsp-java :recipe (:fetcher github :repo "emacs-lsp/lsp-java"))

(package! lsp-javascript :recipe (:fetcher github :repo "emacs-lsp/lsp-javascript") :ignore t)

