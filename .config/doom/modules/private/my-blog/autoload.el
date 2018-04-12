;;; private/my-blog/autoload.el -*- lexical-binding: t; -*-

;;;###autoload
(defun +my/open-org-octopress()
  (interactive)
  (let ((buffer (get-buffer "Octopress")))
    (if buffer
        (switch-to-buffer buffer)
      (org-octopress))))

;;;###autoload
(defun +my-blog*export-blog-image-url(filename)
  (if (equal
       (string-match-p
        (regexp-quote (expand-file-name +my-blog-root-dir))
        (expand-file-name filename))
       0)
      (concat  +my-blog-res-url (file-name-nondirectory filename))
    nil))
