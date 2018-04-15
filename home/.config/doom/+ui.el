;;; config/private/+ui.el -*- lexical-binding: t; -*-

;; font


(defun +my|init-font(frame)
    (with-selected-frame frame
      (+my/better-font)))

(if (and (fboundp 'daemonp) (daemonp))
    (add-hook 'after-make-frame-functions #'+my|init-font)
  (+my/better-font))

