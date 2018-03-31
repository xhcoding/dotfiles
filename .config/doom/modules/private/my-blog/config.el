;;; private/my-blog/config.el -*- lexical-binding: t; -*-

(defvar my-blog-root-dir
  "~/Blog/"
  "Blog root directory.")

(def-package! org-octopress
  :config
  (setq
   org-octopress-directory-top (expand-file-name "source" my-blog-root-dir)
   org-octopress-directory-posts (expand-file-name "source/_posts" my-blog-root-dir)
   org-octopress-directory-org-top my-blog-root-dir
   org-octopress-directory-org-posts (expand-file-name "blog" my-blog-root-dir)
   org-octopress-setup-file (expand-file-name "setupfile.org" my-blog-root-dir)
   )
  (map!
   (:leader
     (:desc "open" :prefix "o"
       :desc "Open blog" :n "B" #'org-octopress
       )
     )))

