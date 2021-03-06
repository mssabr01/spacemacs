;;; packages.el --- YANG Layer packages file for Space-macs
;;
;; Copyright (c) 2012-2020 Sylvain Benner & Contributors
;;
;; Author: Christian Hopps <chopps@gmail.com>
;; Originally started with checker definition from flycheck-yang project.
;; URL: https://github.com/syl20bnr/space-macs
;;
;; This file is not part of GNU e-macs.
;;
;;; License: GPLv3

(setq yang-packages '(company
                      flycheck
                      yang-mode))

(defun yang/post-init-company ()
  (space-macs|add-company-backends :modes yang-mode))

(defun yang/post-init-flycheck ()
  (progn
    (flycheck-define-command-checker 'yang-pyang
      "A YANG syntax checker using the pyang parser."
      :command '("pyang"
                 (eval (concat "--" yang-pyang-rules))
                 (eval (or yang-pyang-extra-args nil))
                 source)
      :error-patterns '((error line-start (file-name) ":"
                               line ": " "error: " (message) line-end)
                        (warning line-start (file-name) ":"
                                 line ": " "warning: " (message) line-end))
      :modes 'yang-mode
      :error-filter '(lambda (errors)
                       (-> errors
                           flycheck-dedent-error-messages
                           flycheck-sanitize-errors)))
    (add-to-list 'flycheck-checkers 'yang-pyang)
    (space-macs/enable-flycheck 'yang-mode)))

(defun yang/init-yang-mode ()
  "Initialize YANG mode"
  (use-package yang-mode))


