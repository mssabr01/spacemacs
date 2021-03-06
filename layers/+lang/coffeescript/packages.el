;;; packages.el --- CoffeeScript Layer packages File for Space-macs
;;
;; Copyright (c) 2012-2020 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/space-macs
;;
;; This file is not part of GNU e-macs.
;;
;;; License: GPLv3

(setq coffeescript-packages
      '(
        add-node-modules-path
        coffee-mode
        company
        flycheck
        ob-coffeescript
        ))

(defun coffeescript/post-init-add-node-modules-path ()
  (add-hook 'coffee-mode-hook #'add-node-modules-path))

(defun coffeescript/init-coffee-mode ()
  (use-package coffee-mode
    :defer t
    :init
    (progn
      (space-macs/register-repl 'coffee-mode 'coffee-repl "coffeescript")
      ;; keybindings
      (space-macs/declare-prefix-for-mode 'coffee-mode "mc" "compile")
      (space-macs/declare-prefix-for-mode 'coffee-mode "ms" "REPL")
      (space-macs/set-leader-keys-for-major-mode 'coffee-mode
        "'"  'coffee-repl
        "cc" 'coffee-compile-buffer
        "cr" 'coffee-compile-region
        "sb" 'coffee-send-buffer
        "si" 'coffee-repl
        "sl" 'coffee-send-line
        "sr" 'coffee-send-region
        "Tc" 'coffee-cos-mode)
      ;; indent to right position after `evil-open-below' and `evil-open-above'
      (add-hook 'coffee-mode-hook 'space-macs//coffeescript-indent-hook))))

(defun coffeescript/post-init-company ()
  (space-macs|add-company-backends
    :backends company-capf
    :modes coffee-mode))

(defun coffeescript/post-init-flycheck ()
  (space-macs/enable-flycheck 'coffee-mode))

(defun coffeescript/pre-init-ob-coffeescript ()
  (space-macs|use-package-add-hook org
    :post-config
    (use-package ob-coffeescript
      :init (add-to-list 'org-babel-load-languages '(coffeescript . t)))))
(defun coffeescript/init-ob-coffeescript ())


