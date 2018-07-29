;;; config/private/+bindings.el -*- lexical-binding: t; -*-
(map! [remap indent-region] #'+my/indent-region-or-buffer


      ;; global keybinds
      :gnvime "<f7>"      #'projectile-compile-project
      :gnvime "M-g s"     #'sp-up-sexp
      :gnvime "M-g S"     #'sp-backward-sexp
      :gnvime "M-g k"     #'+my/kill-in-pair
      :gnvime "C-k"       #'kill-line
      :gnvime "M-g b"     #'+my/toggle-chrome-play-video
      :n      "RET"       #'next-buffer
      :n      "M-RET"     #'previous-buffer
      :i      "M-/"       #'+company/complete
      :i      "M-f"       #'forward-char
      :i      "M-b"       #'backward-char
      :i      "M-n"       #'next-line
      :i      "M-p"       #'previous-line
      :i      "C-s"       #'counsel-grep-or-swiper
      :i      "C-v"       #'yank
      :m      "gb"        #'evil-jump-backward
      :m      "gB"        #'evil-jump-forward
      :ov     "s"         #'isolate-quick-add
      :ov     "S"         #'isolate-long-add

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
        )
      )
