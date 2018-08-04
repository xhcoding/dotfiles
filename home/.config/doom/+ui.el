;;; config/private/+ui.el -*- lexical-binding: t; -*-

;; theme
(def-package! gruvbox-theme
  :config
  (setq doom-theme 'gruvbox-dark-hard))

;; font
(defun +my|init-font(frame)
  (with-selected-frame frame
    (if (display-graphic-p)
        (+my/better-font))))

(if (and (fboundp 'daemonp) (daemonp))
    (add-hook 'after-make-frame-functions #'+my|init-font)
  (+my/better-font))
