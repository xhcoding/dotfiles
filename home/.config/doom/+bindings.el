;;; config/private/+bindings.el -*- lexical-binding: t; -*-
(map! [remap indent-region] #'+my/indent-region-or-buffer


      ;; global keybinds
      :gnvime "<f7>"      #'projectile-compile-project
      :gnvime "M-g s"     #'up-list
      :gnvime "M-g S"     #'backward-up-list
      :gnvime "C-k"       #'kill-line
      :n      "RET"       #'next-buffer
      :n      "M-RET"     #'previous-buffer
      :i      "M-/"       #'+company/complete
      :i      "M-f"       #'forward-char
      :i      "M-b"       #'backward-char
      :i      "M-n"       #'next-line
      :i      "M-p"       #'previous-line
      :i      "C-s"       #'counsel-grep-or-swiper
      :m      "gb"        #'evil-jump-backward
      :m      "gB"        #'evil-jump-forward

      (:leader
        (:prefix "o"
          :desc "agenda"           :n  "a"    #'org-agenda)
        (:desc "toggle" :prefix "t"
          :desc "Transparency"     :n  "t"    #'+my/toggle-transparency
          :desc "Auto save"        :n  "a"    #'+my/toggle-auto-save
          :desc "Comment "         :n  "c"    #'comment-line
          )
        (:desc "search" :prefix "s"
          :desc "replace"          :n  "r"    #'vr/replace
          :desc "query replace"    :n  "R"    #'vr/query-replace)
        ))
