;;;  -*- lexical-binding: t; -*-

;; indent buffer or region

;;;###autoload
(defun indent-buffer()
  "Indent the currently visited buffer."
  (interactive)
  (indent-region (point-min) (point-max)))

;;;###autoload
(defun indent-region-or-buffer()
  "Indent a region if selected, otherwise the whole buffer."
  (interactive)
  (save-excursion
    (if(region-active-p)
	(progn
	  (indent-region (region-beginning) (region-end))
	  (message "Indented selected region."))
      (progn
	(indent-buffer)
	(message "Indented buffer.")))))

;;;###autoload
(defun toggle-transparency ()
   (interactive)
   (let ((alpha (frame-parameter nil 'alpha)))
     (set-frame-parameter
      nil 'alpha
      (if (eql (cond ((numberp alpha) alpha)
                     ((numberp (cdr alpha)) (cdr alpha))
                     ;; Also handle undocumented (<active> <inactive>) form.
                     ((numberp (cadr alpha)) (cadr alpha)))
               100)
          '(85 . 50) '(100 . 100)))))

;;;###autoload
(defun toggle-auto-save()
  (interactive)
  (if my-auto-save-timer
      (progn
        (cancel-timer my-auto-save-timer)
        (setq my-auto-save-timer nil))
    (setq my-auto-save-timer (auto-save-enable))))


