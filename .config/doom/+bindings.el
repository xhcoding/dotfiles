;;; config/private/+bindings.el -*- lexical-binding: t; -*-
(map! [remap indent-region] #'indent-region-or-buffer


      ;; global keybinds
      :gnvime "<f7>"      #'compile
      :n      "RET"       #'next-buffer
      :n      "M-RET"     #'previous-buffer
      :i      "M-/"       #'+company/complete
      :i      "C-f"       #'forward-char
      :i      "C-b"       #'backward-char
      :i      "C-n"       #'next-line
      :i      "C-p"       #'previous-line

      (:leader
        (:desc "toggle" :prefix "t"
          :desc "transparency"     :n  "t"    #'toggle-transparency
          :desc "auto save"        :n  "a"    #'toggle-auto-save
          )
        (:desc "search" :prefix "s"
          :desc "replace"          :n  "r"    #'vr/replace)
        ))
