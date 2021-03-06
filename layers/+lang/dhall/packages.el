;;; packages.el --- Dhall Layer packages File for Space-macs
;;
;; Copyright (c) 2012-2020 Sylvain Benner & Contributors
;;
;; Author: Colin Woodbury <colin@fosskers.ca>
;; URL: https://github.com/syl20bnr/space-macs
;;
;; This file is not part of GNU e-macs.
;;
;;; License: GPLv3

;;; Commentary:

;;; Code:

(defconst dhall-packages
  '(
    lsp-mode
    dhall-mode
    ))

(defun dhall/init-dhall-mode ()
  "Initialize dhall-mode."
  (use-package dhall-mode
    :defer t

    ))

(defun dhall/post-init-lsp-mode ()
  (add-hook 'dhall-mode-hook #'lsp))

;;; packages.el ends here


