;;;  -*- lexical-binding: t; -*-

;;;###autoload
(defun +my/better-font()
  "Changing font to better."
  (interactive)
  ;; english font
  (set-face-attribute 'default nil :font (format   "%s:pixelsize=%d" "Source Code Pro" 17)) ;; 11 13 17 19 23
  ;; chinese font
  (dolist (charset '(kana han symbol cjk-misc bopomofo))
    (set-fontset-font (frame-parameter nil 'font)
		              charset
		              (font-spec :family "WenQuanYi Micro Hei Mono" :size 20)))) ;; 14 16 20 22 28

;;;###autoload
(defun +my/indent-buffer()
  "Indent the currently visited buffer."
  (interactive)
  (indent-region (point-min) (point-max)))

;;;###autoload
(defun +my/indent-region-or-buffer()
  "Indent a region if selected, otherwise the whole buffer."
  (interactive)
  (save-excursion
    (if(region-active-p)
	    (progn
	      (indent-region (region-beginning) (region-end))
	      (message "Indented selected region."))
      (progn
	    (+my/indent-buffer)
	    (message "Indented buffer.")))))

;;;###autoload
(defun +my/toggle-transparency ()
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
(defun +my/toggle-auto-save()
  (interactive)
  (if +my-auto-save-timer
      (progn
        (cancel-timer +my-auto-save-timer)
        (setq +my-auto-save-timer nil))
    (setq +my-auto-save-timer (auto-save-enable))))

;; rename this buffer and name
(defun +my/rename-this-file-and-buffer (new-name)
  "Rename both current buffer and file it's visiting to NEW_NAME"
  (interactive "sNew name: ")
  (let ((name (buffer-name))
	(filename (buffer-file-name)))
    (unless filename
      (error "Buffer '%s' is not visiting a file" name))
    (progn
      (when (file-exists-p filename)
	(rename-file filename new-name 1))
      (set-visited-file-name new-name)
      (rename-buffer new-name))))
