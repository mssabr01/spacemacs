;;; packages.el --- Template Layer packages File for Space-macs
;;
;; Copyright (c) 2012-2020 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/space-macs
;;
;; This file is not part of GNU e-macs.
;;
;;; License: GPLv3

(setq templates-packages '(yatemplate))

(defun templates/init-yatemplate ()
  (use-package yatemplate
    :init
    (progn
      (setq yatemplate-dir templates-private-directory)
      (unless templates-use-default-templates
        (setq auto-insert-alist nil)))
    :config
    (progn
      (yatemplate-fill-alist)
      (auto-insert-mode +1))))


