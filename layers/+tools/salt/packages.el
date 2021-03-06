;;; packages.el --- Salt Layer packages File for Space-macs
;;
;; Copyright (c) 2012-2020 Sylvain Benner & Contributors
;;
;; Author: Ben Hayden <hayden767@gmail.com>
;; URL: https://github.com/syl20bnr/space-macs
;; Salt mode URL: https://github.com/beardedprojamz/salt-mode
;;
;; This file is not part of GNU e-macs.
;;
;;; License: GPLv3
(setq salt-packages '(salt-mode
                      smartparens))

(defun salt/init-salt-mode ()
  (use-package salt-mode
    :defer t
    :config (space-macs/set-leader-keys-for-major-mode 'salt-mode "pb" 'mmm-parse-buffer)))

(defun salt/pre-init-smartparens ()
  (add-hook 'salt-mode-hook 'smartparens-mode)
  (space-macs|use-package-add-hook smartparens
    :post-config
    (progn
      (sp-local-pair 'salt-mode "{{" " }}")
      (sp-local-pair 'salt-mode "{%" " %}")
      (sp-local-pair 'salt-mode "{#" " #}"))))


