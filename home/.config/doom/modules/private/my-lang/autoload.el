;;; private/my-lang/autoload.el -*- lexical-binding: t; -*-

;;;###autoload
(defun +my-lang-ccls-enable ()
  (condition-case nil
      (lsp-ccls-enable)
    (user-error nil)))


;;;###autoload
(defun ccls/base () (interactive) (lsp-ui-peek-find-custom 'base "$ccls/base"))

;;;###autoload
(defun ccls/callers () (interactive) (lsp-ui-peek-find-custom 'callers "$ccls/callers"))

;;;###autoload
(defun ccls/derived () (interactive) (lsp-ui-peek-find-custom 'derived "$ccls/derived"))

;;;###autoload
(defun ccls/vars () (interactive) (lsp-ui-peek-find-custom 'vars "$ccls/vars"))

;;;###autoload
(defun ccls/random () (interactive) (lsp-ui-peek-find-custom 'random "$ccls/random"))

;;;###autoload
(defun +my-lang-lsp-java-enable ()
  (ignore-errors (lsp-java-enable))
  )

