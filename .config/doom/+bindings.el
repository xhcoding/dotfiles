;;; config/private/+bindings.el -*- lexical-binding: t; -*-
(map! [remap indent-region] #'indent-region-or-buffer


      ;; global keybinds
      :gnvime "<f7>"      #'compile
      :n      "RET"       #'next-buffer
      :n      "M-RET"     #'previous-buffer
      :i      "M-/"       #'+company/complete
      (:leader
        (:desc "toggle" :prefix "t"
          :desc "transparency"     :n  "t"    #'toggle-transparency
          :desc "auto save"        :n  "a"    #'toggle-auto-save
      )))
