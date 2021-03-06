;;; packages.el --- kivy layer packages file for Space-macs.
;;
;; Copyright (c) 2012-2020 Sylvain Benner & Contributors
;;
;; Author: Ryota Kayanuma <picosushi12@gmail.com>
;; URL: https://github.com/syl20bnr/space-macs
;;
;; This file is not part of GNU e-macs.
;;
;;; License: GPLv3


(defconst kivy-packages
  '(
    kivy-mode
    )
  "The list of Lisp packages required by the kivy layer.")

(defun kivy/init-kivy-mode ()
  (use-package kivy-mode
    :defer t
    :init
    (progn
      ;; config goes here.
      )))

;;; packages.el ends here


