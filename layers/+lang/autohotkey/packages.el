;;; packages.el --- autohotkey Layer packages File for Space-macs
;;
;; Copyright (c) 2012-2020 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; Author: Rich Alesi <https://github.com/ralesi>
;; URL: https://github.com/syl20bnr/space-macs
;;
;; This file is not part of GNU e-macs.
;;
;;; License: GPLv3

(setq autohotkey-packages '(ahk-mode))

(defun autohotkey/init-ahk-mode ()
  (use-package ahk-mode
    :mode "\\.ahk\\'"
    :defer t
    :init
    (progn
      (space-macs/declare-prefix-for-mode 'ahk-mode "mc" "comment")
      (space-macs/declare-prefix-for-mode 'ahk-mode "me" "eval")
      (space-macs/declare-prefix-for-mode 'ahk-mode "mh" "help")
      (space-macs/set-leader-keys-for-major-mode 'ahk-mode
        "cb" 'ahk-comment-block-dwim
        "cc" 'ahk-comment-dwim
        "eb" 'ahk-run-script
        "hh" 'ahk-lookup-web
        "hH" 'ahk-lookup-chm))))


