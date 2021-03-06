;;; packages.el --- tmux Layer packages File for Space-macs
;;
;; Copyright (c) 2012-2020 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/space-macs
;;
;; This file is not part of GNU e-macs.
;;
;;; License: GPLv3
(setq tmux-packages
      '(
        golden-ratio
        (tmux :location local)
        ))

(defun tmux/post-init-golden-ratio ()
  (with-eval-after-load 'golden-ratio
    (add-to-list 'golden-ratio-extra-commands 'tmux-nav-left)
    (add-to-list 'golden-ratio-extra-commands 'tmux-nav-right)
    (add-to-list 'golden-ratio-extra-commands 'tmux-nav-up)
    (add-to-list 'golden-ratio-extra-commands 'tmux-nav-down)))

(defun tmux/init-tmux ()
  "Initialize tmux"
  (use-package tmux))


