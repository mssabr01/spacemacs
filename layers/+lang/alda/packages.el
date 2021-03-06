;;; packages.el --- Alda Layer packages File for Space-macs
;;
;; Copyright (c) 2012-2020 Sylvain Benner & Contributors
;;
;; Author: Andrew Hill <andrew@andrewkhill.com>
;; URL: https://github.com/syl20bnr/space-macs
;;
;; This file is not part of GNU e-macs.
;;
;;; License: GPLv3

(setq alda-packages
  '(
    alda-mode
   ))

(defun alda/init-alda-mode ()
  (use-package alda-mode
    :defer t
    :commands (alda-play-region
               alda-play-block
               alda-play-line
               alda-play-buffer)
    :init
    (progn
      (space-macs/set-leader-keys-for-major-mode 'alda-mode
        "b" 'alda-play-buffer
        "c" 'alda-play-block
        "n" 'alda-play-line
        "r" 'alda-play-region))))


