;;; packages.el --- prolog layer packages file for Space-macs.
;;
;; Copyright (c) 2012-2020 Sylvain Benner & Contributors
;;
;; Author: Newres Al Haider <newrescode@gmail.com>
;; URL: https://github.com/syl20bnr/space-macs
;;
;; This file is not part of GNU e-macs.
;;
;;; License: GPLv3

(defconst prolog-packages
  '(
    (prolog :location built-in)
    (ediprolog)
    ))


(defun prolog/init-prolog ()
  (use-package prolog
    :defer t
    :init
    (progn
      (autoload 'run-prolog "prolog" "Start a Prolog sub-process." t)
      (autoload 'prolog-mode "prolog" "Major mode for editing Prolog programs." t)
      (setq auto-mode-alist (append '(("\\.pl$" . prolog-mode))
                                    auto-mode-alist))        )
    :config
    (progn
      (space-macs/set-leader-keys-for-major-mode 'prolog-mode
        ;;Key Mappings
        ;;Consulting
        "sb" 'prolog-consult-buffer
        "sf" 'prolog-consult-file
        "sp" 'prolog-consult-predicate
        "sr" 'prolog-consult-region
        ;;Compiling
        "cb" 'prolog-compile-buffer
        "cc" 'prolog-compile-file
        "cp" 'prolog-compile-predicate
        "cr" 'prolog-compile-region
        ;;Formatting
        "=" 'prolog-indent-buffer
        ;;Insert
        "im" 'prolog-insert-module-modeline
        "in" 'prolog-insert-next-clause
        "ip" 'prolog-insert-predicate-template
        "is" 'prolog-insert-predspec
        ;;Help
        "ha" 'prolog-help-apropos
        "hp" 'prolog-help-on-predicate
        )

      (dolist (prefix '(("ms" . "consulting")
                        ("mc" . "compiling")
                        ("mh" . "help")
                        ("mi" . "inserting")
                        ))
        (space-macs/declare-prefix-for-mode 'prolog-mode (car prefix) (cdr prefix))))
    ))

(defun prolog/init-ediprolog ()
  (use-package ediprolog
    :config
    (progn
      (space-macs/set-leader-keys-for-major-mode 'prolog-mode
        ;;Key Mappings
        "ee" 'ediprolog-dwim)
      (space-macs/declare-prefix-for-mode 'prolog-mode "me" "evaluating" ))))

;;; packages.el ends here


