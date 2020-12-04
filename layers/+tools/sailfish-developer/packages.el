;;; packages.el --- sailfish-developer layer packages file for Space-macs.
;;
;; Copyright (c) 2020 Sylvain Benner & Contributors
;;
;; Author: Victor Polevoy <fx@thefx.co>
;; URL: https://github.com/syl20bnr/space-macs
;;
;; This file is not part of GNU e-macs.
;;
;;; License: GPLv3

(defconst sailfish-developer-packages
  '(sailfish-scratchbox))

(defun sailfish-developer/init-sailfish-scratchbox ()
  (use-package sailfish-scratchbox
    :defer t
    :init
    (progn
      (space-macs/declare-prefix "cs" "sailfish os developer menu")
      (space-macs/set-leader-keys
        "csb" 'sailfish-scratchbox-mb2-build
        "csd" 'sailfish-scratchbox-deploy-rpms
        "csi" 'sailfish-scratchbox-install-rpms))))


