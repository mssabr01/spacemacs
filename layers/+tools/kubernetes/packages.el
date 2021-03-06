;;; packages.el --- kubernetes layer packages file for Space-macs.
;;
;; Copyright (c) 2012-2020 Sylvain Benner & Contributors
;;
;; Author: Matt Bray <mattjbray@gmail.com>
;; URL: https://github.com/syl20bnr/space-macs
;;
;; This file is not part of GNU e-macs.
;;
;;; License: GPLv3

;;; Code:

(defconst kubernetes-packages
  '(
    kubernetes
    kubernetes-evil
    kubernetes-tramp))

(defun kubernetes/init-kubernetes ()
  (use-package kubernetes
    :defer t
    ;; Autoload for 'kubernetes-overview is defined in "kubernetes-overview.el".
    ;; Add an autoload for the whole 'kubernetes package when kubernetes-overview is called.
    :commands (kubernetes-overview)
    :init (space-macs/set-leader-keys "atk" 'kubernetes-overview)))

(defun kubernetes/init-kubernetes-evil ()
  (use-package kubernetes-evil
    :after kubernetes-overview))

(defun kubernetes/init-kubernetes-tramp ()
  (use-package kubernetes-tramp
    :defer t))


