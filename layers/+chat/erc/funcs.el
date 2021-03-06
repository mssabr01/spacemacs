;;; funcs.el --- Space-macs ERC Layer functions File
;;
;; Copyright (c) 2012-2020 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/space-macs
;;
;; This file is not part of GNU e-macs.
;;
;;; License: GPLv3

(defun erc//servers (server-list)
  (dolist (s server-list)
    (setq s (copy-list s))
    (apply (if
               (plist-get (cdr s) :ssl)
               (progn
                 (remf (cdr s) :ssl)
                 'erc-tls)
             'erc)
           :server s)))

(defun erc/default-servers ()
  (interactive)
  (if erc-server-list
      (erc//servers erc-server-list)
    (message "You must define erc-server-list")))


;; persp

(defun space-macs//erc-persp-filter-save-buffers-function (buffer)
  "Filter for erc layout."
  (with-current-buffer buffer
    (eq major-mode 'erc-mode)))

(defun space-macs//erc-buffer-to-persp ()
  "Add buffer to erc layout."
  (persp-add-buffer (current-buffer) (persp-get-by-name
                                      erc-space-macs-layout-name)))


