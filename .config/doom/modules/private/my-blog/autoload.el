;;; private/my-blog/autoload.el -*- lexical-binding: t; -*-

;;;###autoload
(defun +my-blog*org-custom-img-link-follow (path)
  (org-open-file-with-emacs path))

;;;###autoload
(defun +my-blog*org-custom-img-link-export (path desc backend)
  (cond
   ((eq 'html backend)
    (setq image-name (file-name-nondirectory path))
    (format "<img src=\"http://ivme.xhcoding.cn/%s\" alt=\"%s\" />" image-name desc)
    )))
