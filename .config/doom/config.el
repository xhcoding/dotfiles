
(load! +bindings)


(add-hook! 'doom-post-init-hook 'doom|disable-line-numbers)

;; font
(defun my-default-font()
  (interactive)

  ;; english font
  (set-face-attribute 'default nil :font (format   "%s:pixelsize=%d" "Source Code Pro" 17))
  ;; chinese font
  (dolist (charset '(kana han symbol cjk-misc bopomofo))
    (set-fontset-font (frame-parameter nil 'font)
		              charset
		              (font-spec :family "WenQuanYi Micro Hei Mono" :size 20))))

(add-to-list 'after-make-frame-functions
	         (lambda (new-frame)
	           (select-frame new-frame)
	           (if window-system
		           (my-default-font)
		         )))

(if window-system
    (my-default-font))

;; Reconfigure packages
(after! evil-escape
  (setq evil-escape-key-sequence "fd"))

(require 'company)
(after! company
  (setq company-idle-delay 0.2
        company-minimum-prefix-length 2
        company-show-numbers t
        company-backends '(( company-files company-capf company-dabbrev))))

(def-package! lsp-mode
  :config
  (setq lsp-project-blacklist '("^/usr/")
        lsp-highlight-symbol-at-point nil))

(def-package! lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-sideline-enable nil
        lsp-ui-sideline-show-symbol nil
        lsp-ui-sideline-show-symbol nil
        lsp-ui-sideline-ignore-duplicate t
        lsp-ui-doc-max-width 50
        )

  (map! :map lsp-ui-mode-map
        [remap xref-find-definitions] #'lsp-ui-peek-find-definitions
        [remap xref-find-references] #'lsp-ui-peek-find-references
        :after lsp-ui-peek
        :map lsp-ui-peek-mode-map
        "h" #'lsp-ui-peek--select-prev-file
        "j" #'lsp-ui-peek--select-next
        "k" #'lsp-ui-peek--select-prev
        "l" #'lsp-ui-peek--select-next-file
        ))


(set! :popup "^\\*helpful" '((size . 0.4)))
(set! :popup "^\\*info\\*$" '((size . 0.4)))


