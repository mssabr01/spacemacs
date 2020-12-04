;;; packages.el --- mercury layer packages file for Space-macs.
;;
;; Copyright (c) 2012-2020 Sylvain Benner & Contributors
;;
;; Author: Ludvig BÃ¶klin <ludvig.boklin@protonmail.com>
;; URL: https://github.com/syl20bnr/space-macs
;;
;; This file is not part of GNU e-macs.
;;
;;; License: GPLv3

(defconst mercury-packages
  '((metal-mercury-mode :location (recipe
                                   :fetcher github
                                   :repo "ahungry/metal-mercury-mode"
                                   :commit "99e2d8fb7177cae3bfa2dec2910fc28216d5f5a8"))
    flycheck
    (flycheck-mercury :requires flycheck)
    smartparens))

(defun mercury/post-init-flycheck ()
  (add-hook 'metal-mercury-mode-hook 'flycheck-mode))

(defun mercury/init-flycheck-mercury ()
  "Initialize flycheck-mercury"
  (use-package flycheck-mercury))

(defun mercury/init-metal-mercury-mode ()
  "Initialize metal-mercury-mode"
  (use-package metal-mercury-mode
    :defer t
    :init
    :mode ("\\.m\\'" . metal-mercury-mode)
    :config
    (progn
      (dolist (x '(
                   ;; ("m=" . "format")
                   ("mc" . "mercury/compile")
                   ;; ("mh" . "help")
                   ))
        (space-macs/declare-prefix-for-mode 'metal-mercury-mode (car x) (cdr x)))

      (space-macs/set-leader-keys-for-major-mode 'metal-mercury-mode
        ;; make
        "cb" 'metal-mercury-mode-compile
        "cr" 'metal-mercury-mode-runner))))

(defun mercury/post-init-smartparens ()
  (if dotspace-macs-smartparens-strict-mode
      (add-hook 'metal-mercury-mode-hook #'smartparens-strict-mode)
    (add-hook 'metal-mercury-mode-hook #'smartparens-mode)))


