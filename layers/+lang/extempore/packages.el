;;; packages.el --- Extempore Layer packages File for Space-macs
;;
;; Copyright (c) 2020 Sylvain Benner & Contributors
;;
;; Author: Ben Swift <ben@benswift.me>
;; URL: https://github.com/syl20bnr/space-macs
;;
;; This file is not part of GNU e-macs.
;;
;;; License: GPLv3

(defconst extempore-packages
  '(extempore-mode))

(defun extempore/init-extempore-mode ()
  "Initialize extempore mode"
  (use-package extempore-mode
    :defer t
    :mode
    (("\\.xtm$" . extempore-mode))
    :init
    (space-macs/register-repl 'extempore-mode 'extempore-repl "extempore")
    :config
    (progn
      (space-macs/declare-prefix-for-mode 'extempore-mode "mc" "process")
      (space-macs/declare-prefix-for-mode 'extempore-mode "me" "eval")

      (space-macs/set-leader-keys-for-major-mode 'extempore-mode
        "'"  'extempore-repl
        ","  'lisp-state-toggle-lisp-state

        "cc" 'switch-to-extempore
        "cj" 'extempore-connect

        "ee" 'extempore-send-last-sexp
        "ef" 'extempore-send-definition
        "er" 'extempore-send-region
        "eb" 'extempore-send-buffer-or-region
        (setq extempore-tab-completion nil)

        (set-face-attribute 'extempore-blink-face nil :foreground "#272822" :background "#FD971F")
        (set-face-attribute 'extempore-sb-blink-face nil :foreground "#272822" :background "#39FF14")

        ;; stop the ' (quote) character being paired by smartparens
        (with-eval-after-load 'smartparens
          (sp-local-pair 'extempore-mode "'" nil :actions nil)
          (sp-local-pair 'extempore-mode "`" nil :actions nil))))))

(defun extempore/post-init-eldoc ()
  (add-hook 'extempore-mode-hook #'space-macs//extempore-setup-eldoc))


