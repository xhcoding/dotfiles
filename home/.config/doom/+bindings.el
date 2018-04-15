;;; config/private/+bindings.el -*- lexical-binding: t; -*-
(map! [remap indent-region] #'+my/indent-region-or-buffer


      ;; global keybinds
      :gnvime "<f7>"      #'compile
      :n      "RET"       #'next-buffer
      :n      "M-RET"     #'previous-buffer
      :i      "M-/"       #'+company/complete
      :i      "M-f"       #'forward-char
      :i      "M-b"       #'backward-char
      :i      "M-n"       #'next-line
      :i      "M-p"       #'previous-line

      (:leader
        (:desc "toggle" :prefix "t"
          :desc "Transparency"     :n  "t"    #'+my/toggle-transparency
          :desc "Auto save"        :n  "a"    #'+my/toggle-auto-save
          :desc "Comment "         :n  "c"    #'comment-line
          )
        (:desc "search" :prefix "s"
          :desc "replace"          :n  "r"    #'vr/replace)
        )
      )
