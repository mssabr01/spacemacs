;;; space-macs-whitespace-cleanup.el --- Cleanup whitspace automatically.

;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; Keywords: editing, whitespace, space-macs
;; Version: 0.1

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU e-macs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:
;; This package adds a minor mode to automatically cleanup whitespace.
;; It requires Space-macs and depends on the value of the variable
;; `dotspace-macs-whitespace-cleanup' (see documentation in dotfile).

;;; Code:

(defvar space-macs-whitespace-cleanup-globally nil
  "If non nil then `space-macs-whitespace-cleanup-mode' is applied globally.")

;;;###autoload
(define-minor-mode space-macs-whitespace-cleanup-mode
  "Minor mode to clean whitespace.

The minor mode is based on the value of the dotfile variable
 `dotspace-macs-whitespace-cleanup' to determine the behavior
of the cleanup."
  :lighter " CleanW"
  :group 'space-macs
  (if space-macs-whitespace-cleanup-mode
      (space-macs-whitespace-cleanup//turn-on
       space-macs-whitespace-cleanup-globally)
    (space-macs-whitespace-cleanup//turn-off
     space-macs-whitespace-cleanup-globally)))

(define-global-minor-mode global-space-macs-whitespace-cleanup-mode
  space-macs-whitespace-cleanup-mode
  (lambda ()
    (let ((space-macs-whitespace-cleanup-globally t))
      (space-macs-whitespace-cleanup-mode)))
  :group 'space-macs
  :require 'space-macs-whitespace-cleanup-mode)

(defun space-macs-whitespace-cleanup/on-message (&optional global)
  "Return a string to display when the mode is activated."
  (pcase dotspace-macs-whitespace-cleanup
    (`all
     (format "whitespace-cleanup enabled%s (all whitespace)"
             (if global " globally" "")))
    (`trailing
     (format "whitespace-cleanup enabled%s (trailing whitespace)"
             (if global " globally" "")))
    (`changed
     (format "whitespace-cleanup enabled%s (changed lines)"
             (if global " globally" "")))))

(defun space-macs-whitespace-cleanup//turn-on (&optional global)
  "Turn on `space-macs-whitespace-cleanup-mode'."
  (pcase dotspace-macs-whitespace-cleanup
    (`all
     (add-hook 'before-save-hook 'whitespace-cleanup nil (not global)))
    (`trailing
     (add-hook 'before-save-hook 'delete-trailing-whitespace nil (not global)))
    (`changed
     (when (fboundp 'ws-butler-mode)
       (if global (ws-butler-global-mode) (ws-butler-mode))))))

(defun space-macs-whitespace-cleanup//turn-off (&optional global)
  "Turn off `space-macs-whitespace-cleanup-mode'."
  (pcase dotspace-macs-whitespace-cleanup
    (`all
     (remove-hook 'before-save-hook 'whitespace-cleanup (not global)))
    (`trailing
     (remove-hook 'before-save-hook 'delete-trailing-whitespace (not global)))
    (`changed
     (when (fboundp 'ws-butler-mode)
       (if global (ws-butler-global-mode -1) (ws-butler-mode -1))))))

(provide 'space-macs-whitespace-cleanup)
;;; space-macs-whitespace-cleanup.el ends here.


