;;; config.el --- Latex Layer Configuration File for Space-macs
;;
;; Copyright (c) 2012-2020 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/space-macs
;;
;; This file is not part of GNU e-macs.
;;
;;; License: GPLv3

;; variables

;; Even though AUCTeX uses TeX-latex-mode rather than latex-mode, major-mode
;; will still be bound to 'latex-mode (since AUCTeX uses an advice to override
;; latex-mode with TeX-latex-mode), so the keymap's name should use the
;; lowercase form, since bind-map uses the value of major-mode...
(space-macs|define-jump-handlers latex-mode dumb-jump-go)
;; ...but AUCTeX runs LaTeX-mode-hook rather than latex-mode-hook, so:
(add-hook 'LaTeX-mode-hook #'space-macs//init-jump-handlers-latex-mode)

(defvar latex-build-command (if (executable-find "latexmk") "LatexMk" "LaTeX")
  "The default command to use with `SPC m b'")

(defvar latex-enable-auto-fill t
  "Whether to use auto-fill-mode or not in tex files.")

(defvar latex-enable-folding nil
  "Whether to use `TeX-fold-mode' or not in tex/latex buffers.")

(defvar latex-enable-magic nil
  "Whether to enable \"magic\" symbols in the buffer.")

(defvar latex-nofill-env '("equation"
                           "equation*"
                           "align"
                           "align*"
                           "tabular"
                           "tabular*"
                           "tabu"
                           "tabu*"
                           "tikzpicture")
  "List of environment names in which `auto-fill-mode' will be inhibited.")

(defvar latex-backend nil
  "The backend to use for IDE features.
Possible values are `lsp' and `company-auctex'.
If `nil' then 'company-auctex` is the default backend unless `lsp' layer is used")


