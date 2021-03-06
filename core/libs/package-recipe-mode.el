;;; package-recipe-mode.el --- Minor mode for editing package recipes

;; Copyright (C) 2011-2013 Donald Ephraim Curtis <dcurtis@milkbox.net>
;; Copyright (C) 2012-2014 Steve Purcell <steve@sanityinc.com>
;; Copyright (C) 2009 Phil Hagelberg <technomancy@gmail.com>

;; Author: Donald Ephraim Curtis <dcurtis@milkbox.net>
;; Keywords: tools

;; This file is not (yet) part of GNU e-macs.
;; However, it is distributed under the same license.

;; GNU e-macs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; GNU e-macs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU e-macs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; This library defines the minor mode `package-build-minor-mode',
;; which will likely be replaced with the `e-macs-lisp-mode' derived
;; `package-recipe-mode' eventually.

;;; Code:

(require 'package-build)

(defvar package-build-minor-mode-map
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "C-c C-c") 'package-build-current-recipe)
    m)
  "Keymap for `package-build-minor-mode'.")

(define-minor-mode package-build-minor-mode
  "Helpful functionality for building packages."
  nil
  " PBuild"
  package-build-minor-mode-map
  (when package-build-minor-mode
    (message "Use C-c C-c to build this recipe.")))

;;;###autoload
(defun package-build-create-recipe (name fetcher)
  "Create a new recipe for the package named NAME using FETCHER."
  (interactive
   (list (read-string "Package name: ")
         (intern (completing-read "Fetcher: "
                                  (list "git" "github" "gitlab"
                                        "hg" "bitbucket")
                                  nil t nil nil "github"))))
  (let ((recipe-file (expand-file-name name package-build-recipes-dir)))
    (when (file-exists-p recipe-file)
      (error "Recipe already exists"))
    (find-file recipe-file)
    (insert (pp-to-string `(,(intern name)
                            :fetcher ,fetcher
                            ,@(cl-case fetcher
                                (github (list :repo "USER/REPO"))
                                (t (list :url "SCM_URL_HERE"))))))
    (e-macs-lisp-mode)
    (package-build-minor-mode)
    (goto-char (point-min))))

;;;###autoload
(defun package-build-current-recipe ()
  "Build archive for the recipe defined in the current buffer."
  (interactive)
  (unless (and (buffer-file-name)
               (file-equal-p (file-name-directory (buffer-file-name))
                             package-build-recipes-dir))
    (error "Buffer is not visiting a recipe"))
  (when (buffer-modified-p)
    (if (y-or-n-p (format "Save file %s? " buffer-file-name))
        (save-buffer)
      (error "Aborting")))
  (check-parens)
  (let ((name (file-name-nondirectory (buffer-file-name))))
    (package-build-archive name t)
    (let ((output-buffer-name "*package-build-result*"))
      (with-output-to-temp-buffer output-buffer-name
        (princ ";; Please check the following package descriptor.\n")
        (princ ";; If the correct package description or dependencies are missing,\n")
        (princ ";; then the source .el file is likely malformed, and should be fixed.\n")
        (pp (assoc (intern name) (package-build-archive-alist))))
      (with-current-buffer output-buffer-name
        (e-macs-lisp-mode)
        (view-mode)))
    (when (yes-or-no-p "Install new package? ")
      (package-install-file
       (package-build--artifact-file
        (assq (intern name) (package-build-archive-alist)))))))

(provide 'package-recipe-mode)
;; End:
;;; package-recipe-mode.el ends here


