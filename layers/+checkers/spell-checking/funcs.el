;;; funcs.el --- Spell Checking Layer functions File for Space-macs
;;
;; Copyright (c) 2012-2020 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/space-macs
;;
;; This file is not part of GNU e-macs.
;;
;;; License: GPLv3

(defun spell-checking/add-flyspell-hook (hook)
  "Add `flyspell-mode' to the given HOOK, if
`spell-checking-enable-by-default' is true."
  (when spell-checking-enable-by-default
    (add-hook hook 'flyspell-mode)))

(defun spell-checking/change-dictionary ()
  "Change the dictionary. Use the ispell version if
auto-dictionary is not used, use the adict version otherwise."
  (interactive)
  (if (fboundp 'adict-change-dictionary)
      (adict-change-dictionary)
    (call-interactively 'ispell-change-dictionary)))

(defun space-macs/add-word-to-dict-buffer ()
  "Save word at point as correct in current buffer."
  (interactive)
  (space-macs//add-word-to-dict 'buffer))

(defun space-macs/add-word-to-dict-global ()
  "Save word at point as a correct word globally."
  (interactive)
  (space-macs//add-word-to-dict 'save))

(defun space-macs/add-word-to-dict-session ()
  "Save word at point as correct in current session."
  (interactive)
  (space-macs//add-word-to-dict 'session))

(defun space-macs//add-word-to-dict (scope)
  "Save word at point as a correct word.
SCOPE can be:
`save' to save globally,
`session' to save in current session or
`buffer' for buffer local."
  (let ((current-location (point))
        (word (flyspell-get-word)))
    (when (consp word)
      (if (space-macs//word-in-dict-p (car word))
          (error "%s is already in dictionary" (car word))
        (progn
          (flyspell-do-correct scope nil (car word) current-location
                               (cadr word) (caddr word) current-location)
          (ispell-pdict-save t))))))

(defun space-macs//word-in-dict-p (word)
  "Check if WORD is defined in any of the active dictionaries."
  ;; use the correct dictionary
  (flyspell-accept-buffer-local-defs)
  (let (poss ispell-filter)
    ;; now check spelling of word.
    (ispell-send-string "%\n")	;put in verbose mode
    (ispell-send-string (concat "^" word "\n"))
    ;; wait until ispell has processed word
    (while (progn
             (accept-process-output ispell-process)
             (not (string= "" (car ispell-filter)))))
    ;; Remove leading empty element
    (setq ispell-filter (cdr ispell-filter))
    ;; ispell process should return something after word is sent.
    ;; Tag word as valid (i.e., skip) otherwise
    (or ispell-filter
        (setq ispell-filter '(*)))
    (if (consp ispell-filter)
        (setq poss (ispell-parse-output (car ispell-filter))))
    (or (eq poss t) (stringp poss))))


