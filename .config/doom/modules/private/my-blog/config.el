;;; private/my-blog/config.el -*- lexical-binding: t; -*-

(defvar my-blog-root-dir
  "~/Documents/Blog/"
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

(org-link-set-parameters
 "img-hexo"
 :follow #'+my-blog*org-custom-img-link-follow ;; click link
 :export #'+my-blog*org-custom-img-link-export ;; export html
 :help-echo "Click me to display image")

;; test
(setq org-publish-project-alist
      '(("test-publish"
	 :base-directory "~/Documents/Blog/blog"
	 :publishing-directory "~/Documents/Blog/source/_posts"
	 :base-extension "org"
	 :recursive t
	 :htmlized-source t
	 :publishing-function org-html-publish-to-html
	 :with-toc nil
     :body-only t
	 )))

