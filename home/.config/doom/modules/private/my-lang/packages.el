;; -*- no-byte-compile: t; -*-
;;; private/my-lang/packages.el


(package! ccls :recipe (:fetcher github :repo "MaskRay/emacs-ccls"))

(package! clang-format)

(package! cmake-project :ignore t)

(package! srefactor)

(package! lsp-python)

(package! lsp-java )

(package! matlab-mode)
