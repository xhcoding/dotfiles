;;; config/private/+bindings.el -*- lexical-binding: t; -*-
(map! [remap indent-region] #'indent-region-or-buffer


      ;; global keybinds
      :gnvime "<f7>"      #'compile
      :n      "RET"       #'next-buffer
      :n      "M-RET"     #'previous-buffer
      :i      "M-/"       #'+company/complete
      )
