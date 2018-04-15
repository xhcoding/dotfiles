;;; private/my-blog/autoload.el -*- lexical-binding: t; -*-

;;;###autoload
(defun +my-blog/open-org-octopress()
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


;; sync images
(defun sync-blog-img-to-qiniu()
  (interactive)
  (call-process-shell-command
   "/home/xhcoding/Tools/qshell-lastest/qshell qupload /home/xhcoding/Tools/qshell-lastest/upload_config.json"))



;;;###autoload
(defun +my-blog-insert-org-org-md-img-link(prefix imagename)
  (if (string-equal (file-name-extension (buffer-file-name))
                    "org")
      (insert (format "[[file:%s%s]] " prefix imagename))
    (insert (format "![%s](%s%s) " imagename prefix imagename))))


;;;###autoload
(defun +my-blog/capture-screenshot-and-insert-link(basename)
  (interactive "sScreenshot name: ")
  (if (string-equal basename "")
      (setq basename (concat
                      (file-name-base buffer-file-name)
                      (format-time-string "_%H%M%S"))))
  (sleep-for 3)
  (call-process-shell-command
   (concat
    "deepin-screenshot -s " (concat (expand-file-name +my-blog-img-dir) basename)))
  (+my-blog-insert-org-org-md-img-link
   +my-blog-img-dir (concat basename ".png")))
