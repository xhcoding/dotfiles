;;; private/my-lang/autoload.el -*- lexical-binding: t; -*-

;;;###autoload
(defun cquery/base () (interactive) (lsp-ui-peek-find-custom 'base "$cquery/base"))

;;;###autoload
(defun cquery/callers () (interactive) (lsp-ui-peek-find-custom 'callers "$cquery/callers"))

;;;###autoload
(defun cquery/derived () (interactive) (lsp-ui-peek-find-custom 'derived "$cquery/derived"))

;;;###autoload
(defun cquery/vars () (interactive) (lsp-ui-peek-find-custom 'vars "$cquery/vars"))

;;;###autoload
(defun cquery/random () (interactive) (lsp-ui-peek-find-custom 'random "$cquery/random"))
