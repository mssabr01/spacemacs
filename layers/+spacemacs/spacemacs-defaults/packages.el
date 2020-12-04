;;; packages.el --- Space-macs Defaults Layer packages File
;;
;; Copyright (c) 2012-2020 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/space-macs
;;
;; This file is not part of GNU e-macs.
;;
;;; License: GPLv3

(setq space-macs-defaults-packages
      '(
        (abbrev :location built-in)
        (archive-mode :location built-in)
        (bookmark :location built-in)
        (conf-mode :location built-in)
        (cus-edit :location built-in
                  :toggle (or (eq 'vim dotspace-macs-editing-style)
                              (eq 'hybrid dotspace-macs-editing-style)))
        (dired :location built-in)
        (dired-x :location built-in)
        (display-line-numbers :location built-in
                              :toggle (version<= "26" e-macs-version))
        (electric-indent-mode :location built-in)
        (ediff :location built-in)
        (eldoc :location built-in)
        (help-fns+ :location local)
        (hi-lock :location built-in)
        (image-mode :location built-in)
        (imenu :location built-in)
        (linum :location built-in :toggle (version< e-macs-version "26"))
        (occur-mode :location built-in)
        (package-menu :location built-in)
        ;; page-break-lines is shipped with space-macs core
        (page-break-lines :location built-in)
        (process-menu :location built-in)
        (recentf :location built-in)
        (savehist :location built-in)
        (saveplace :location built-in)
        (subword :location built-in)
        (tar-mode :location built-in)
        (uniquify :location built-in)
        (url :location built-in)
        (visual-line-mode :location built-in)
        (whitespace :location built-in)
        (winner :location built-in)
        (zone :location built-in)
        ))

;; Initialization of packages

(defun space-macs-defaults/init-abbrev ()
  (space-macs|hide-lighter abbrev-mode))

(defun space-macs-defaults/init-archive-mode ()
  (evilified-state-evilify-map archive-mode-map
    :mode archive-mode
    :eval-after-load archive-mode))

(defun space-macs-defaults/init-bookmark ()
  (use-package bookmark
    :defer t
    :init
    (progn
      (setq bookmark-default-file (concat space-macs-cache-directory "bookmarks")
            ;; autosave each change
            bookmark-save-flag 1)
      (space-macs/set-leader-keys "fb" 'bookmark-jump))))

(defun space-macs-defaults/init-conf-mode ()
  :init
  ;; explicitly derive conf-mode from text-mode major-mode
  (add-hook 'conf-mode-hook 'space-macs/run-text-mode-hooks))

(defun space-macs-defaults/init-cus-edit ()
  ;; Arguably a Vim user's first expectation for such a buffer would be a kind
  ;; of normal mode; besides, `evilified' conflicts with text insertion for
  ;; search.
  (evil-set-initial-state 'Custom-mode 'normal)
  ;; Notes on how this effects the default `custom-mode-map':
  ;; - `TAB' works as `widget-forward' without modification
  ;; - `<S-TAB>' works as `widget-backward' without modification
  ;; - `n' as `widget-forward' is redundant with `TAB' and collides with the
  ;; - `evil-ex-search-next' mapping which is useful here. Omitting
  ;;   intensionally.
  ;; - `p' doesn't make any sense without `n' and is redundant with `<S-TAB>'.
  ;;   Omitting intensionally.
  ;; - `q' as `Custom-buffer-done' conflicts with the Evil record macro
  ;;   binding, which is, however, of questionable value in a Custom buffer;
  ;;   and there is precedent in many other Space-macs contexts to bind it to
  ;;   quit actions rather than default evil one; choosing to restore.
  ;; - `SPC' as `scroll-up-command' conflicts with the all-important Space-macs
  ;;   menu. Omitting intensionally. Evil `C-u' works instead.
  ;; - `S-SPC' as `scroll-down-command' makes no sense without `SPC' as
  ;;   `scroll-up-command'. Evil `C-d' works instead.
  ;; - `C-x' as a prefix command still works.
  ;; - `C-c' as a prefix command still works.
  ;; - `u' as `Custom-goto-parent' conflicts with Evil undo. However it is
  ;;   questionable whether this will work properly in a Custom buffer;
  ;;   choosing to restore this binding.
  (evil-define-key 'normal custom-mode-map (kbd "q") 'Custom-buffer-done)
  (evil-define-key 'normal custom-mode-map (kbd "u") 'Custom-goto-parent)
  ;; `RET' does not work well in the search field. Fix:
  (evil-define-key '(insert normal) custom-mode-map (kbd "RET") 'space-macs/custom-newline)
  ;; There is a separate map for links, oddly enough. Separate it from the
  ;; `custom-mode-map' bindings, which is its parent by default.
  (set-keymap-parent custom-mode-link-map nil)
  ;; Evil doesn't seem to be properly in control of what is going on in these
  ;; widget-induced keymaps, so just use base bindings to sort this out
  (define-key custom-mode-link-map (kbd "q") 'Custom-buffer-done)
  (define-key custom-mode-link-map (kbd "u") 'Custom-goto-parent))

(defun space-macs-defaults/init-dired ()
  (space-macs/set-leader-keys
    "ad" 'space-macs/dired
    "fj" 'dired-jump
    "jd" 'dired-jump
    "jD" 'dired-jump-other-window)
  ;; The search next/previous commands are different
  ;; because of the `evil-search-module' values:
  ;; vim = evil-search, hybrid = isearch
  (when (eq 'vim dotspace-macs-editing-style)
    (evil-define-key 'normal dired-mode-map (kbd "n") 'evil-ex-search-next)
    (evil-define-key 'normal dired-mode-map (kbd "N") 'evil-ex-search-previous))
  (when (eq 'hybrid dotspace-macs-editing-style)
    (evil-define-key 'normal dired-mode-map (kbd "n") 'evil-search-next)
    (evil-define-key 'normal dired-mode-map (kbd "N") 'evil-search-previous)))

(defun space-macs-defaults/init-dired-x ()
  (use-package dired-x
    :commands (dired-jump
               dired-jump-other-window
               dired-omit-mode)))

(defun space-macs-defaults/init-electric-indent-mode ()
  (electric-indent-mode))

(defun space-macs-defaults/init-visual-line-mode ()
  (space-macs|diminish visual-line-mode " â“" " L"))

;; notes from mijoharas
;; We currently just set a few variables to make it look nicer.
;; Here is my first attempt at evilifying the buffer, does not work correctly, help is very much welcome.

;; ```
;; (defun ediff/setup-ediff-keymaps ()
;;   "setup the evil ediff keymap"
;;     (progn
;;      (add-to-list 'evil-e-macs-state-modes 'Ediff)
;;      (evilified-state-evilify ediff-mode-map)
;;      (space-macs/activate-evil-leader-for-map 'ediff-mode-map)
;;       )
;;   )

;; ;; inside the use-package function
;; (add-hook 'ediff-keymap-setup-hook 'ediff/setup-ediff-keymaps)
;; ```
(defun space-macs-defaults/init-ediff ()
  (use-package ediff
    :defer t
    :init
    (progn
      ;; first we set some sane defaults
      (setq-default
       ediff-window-setup-function 'ediff-setup-windows-plain
       ;; e-macs is evil and decrees that vertical shall henceforth be horizontal
       ediff-split-window-function 'split-window-horizontally
       ediff-merge-split-window-function 'split-window-horizontally)
      ;; show org ediffs unfolded
      (require 'outline)
      (add-hook 'ediff-prepare-buffer-hook #'show-all)
      ;; restore window layout when done
      (add-hook 'ediff-quit-hook #'winner-undo))))

(defun space-macs-defaults/init-eldoc ()
  (use-package eldoc
    :defer (space-macs/defer)
    :init (space-macs|require-when-dumping 'eldoc)
    :config
    (progn
      ;; enable eldoc in `eval-expression'
      (add-hook 'eval-expression-minibuffer-setup-hook #'eldoc-mode)
      ;; enable eldoc in IELM
      (add-hook 'ielm-mode-hook #'eldoc-mode)
      ;; don't display eldoc on modeline
      (space-macs|hide-lighter eldoc-mode)

      ;; eldoc-message-commands
      (eldoc-add-command #'evil-insert)
      (eldoc-add-command #'evil-insert-line)
      (eldoc-add-command #'evil-append)
      (eldoc-add-command #'evil-append-line)
      (eldoc-add-command #'evil-force-normal-state))))

(defun space-macs-defaults/init-help-fns+ ()
  (use-package help-fns+
    :commands (describe-keymap)
    :init (space-macs/set-leader-keys "hdK" 'describe-keymap)))

(defun space-macs-defaults/init-hi-lock ()
  (with-eval-after-load 'hi-lock
    (space-macs|hide-lighter hi-lock-mode)))

(defun space-macs-defaults/init-image-mode ()
  (use-package image-mode
    :defer t
    :init
    (progn
      (setq image-animate-loop t)
      (space-macs/declare-prefix-for-mode 'image-mode "ma" "animate")
      (space-macs/declare-prefix-for-mode 'image-mode "mg" "goto file")
      (space-macs/declare-prefix-for-mode 'image-mode "mt" "transform/resize")
      (space-macs/set-leader-keys-for-major-mode 'image-mode
        "aa" 'image-toggle-animation
        "a+" 'image-increase-speed
        "a-" 'image-decrease-speed
        "ar" 'image-reset-speed
        "gn" 'image-next-file
        "gN" 'image-previous-file
        "t+" 'image-increase-size
        "t-" 'image-decrease-size
        "tf" 'image-mode-fit-frame
        "tr" 'image-transform-reset
        "th" 'image-transform-fit-to-height
        "tw" 'image-transform-fit-to-width
        "ts" 'image-transform-set-scale
        "tr" 'image-transform-rotation))
    :config (evilified-state-evilify-map image-mode-map
              :mode image-mode
              :bindings
              "h" 'image-backward-hscroll
              "j" 'image-next-line
              "k" 'image-previous-line
              "l" 'image-forward-hscroll)))

(defun space-macs-defaults/init-imenu ()
  (use-package imenu
    :defer t
    :init (space-macs/set-leader-keys "ji" 'imenu)))

(defun space-macs-defaults/init-display-line-numbers ()
  (use-package display-line-numbers
    :defer t
    :init
    (progn
      (cond ((space-macs/visual-line-numbers-p)
             (setq display-line-numbers-type 'visual))
            ((space-macs/relative-line-numbers-p)
             (setq display-line-numbers-type 'relative))
            (t
             (setq display-line-numbers-type t)))

      (space-macs/declare-prefix "tn" "line-numbers")

      ;; backwards compatibility of symbols:
      ;; keep the space-macs/toggle-line-numbers & friends around
      (space-macs|add-toggle line-numbers
        :status (and (featurep 'display-line-numbers)
                     display-line-numbers-mode
                     (eq display-line-numbers t))
        :on (prog1 (display-line-numbers-mode)
              (setq display-line-numbers t))
        :off (display-line-numbers-mode -1)
        :on-message "Absolute line numbers enabled."
        :off-message "Line numbers disabled."
        :documentation "Show the line numbers.")
      (space-macs|add-toggle absolute-line-numbers
        :status (and (featurep 'display-line-numbers)
                     display-line-numbers-mode
                     (eq display-line-numbers t))
        :on (prog1 (display-line-numbers-mode)
              (setq display-line-numbers t))
        :off (display-line-numbers-mode -1)
        :on-message "Absolute line numbers enabled."
        :off-message "Line numbers disabled."
        :documentation "Show the line numbers."
        :evil-leader "tna")
      (space-macs|add-toggle relative-line-numbers
        :status (and (featurep 'display-line-numbers)
                     display-line-numbers-mode
                     (eq display-line-numbers 'relative))
        :on (prog1 (display-line-numbers-mode)
              (setq display-line-numbers 'relative))
        :off (display-line-numbers-mode -1)
        :documentation "Show relative line numbers."
        :on-message "Relative line numbers enabled."
        :off-message "Line numbers disabled."
        :evil-leader "tnr")

      (space-macs|add-toggle visual-line-numbers
        :status (and (featurep 'display-line-numbers)
                     display-line-numbers-mode
                     (eq display-line-numbers 'visual))
        :on (prog1 (display-line-numbers-mode)
              (setq display-line-numbers 'visual))
        :off (display-line-numbers-mode -1)
        :documentation "Show relative visual line numbers."
        :on-message "Visual line numbers enabled."
        :off-message "Line numbers disabled."
        :evil-leader "tnv")

      (when (space-macs//linum-backward-compabitility)
        (add-hook 'prog-mode-hook 'display-line-numbers-mode)
        (add-hook 'text-mode-hook 'display-line-numbers-mode))

      ;; it's ok to add an advice before the function is defined, and we must
      ;; add this advice before calling `global-display-line-numbers-mode'
      (advice-add #'display-line-numbers--turn-on :around #'space-macs//linum-on)
      (when dotspace-macs-line-numbers
        ;; delay the initialization of number lines when opening Space-macs
        ;; normally. If opened via the command line with a file to visit then
        ;; load it immediately
        (add-hook 'e-macs-startup-hook
                  (lambda ()
                    (if (string-equal "*scratch*" (buffer-name))
                        (space-macs|add-transient-hook window-configuration-change-hook
                          (lambda ()
                            (global-display-line-numbers-mode))
                          lazy-loading-line-numbers)
                      (global-display-line-numbers-mode))))))))

(defun space-macs-defaults/init-linum ()
  (use-package linum
    :init
    (progn
      (setq linum-format "%4d")
      (space-macs|add-toggle line-numbers
        :mode linum-mode
        :documentation "Show the line numbers."
        :evil-leader "tn")
      (advice-add #'linum-update-window
                  :after #'space-macs//linum-update-window-scale-fix)
      (advice-add #'linum-on
                  :around #'space-macs//linum-on))
    :config
    (progn
      (when (space-macs//linum-backward-compabitility)
        (add-hook 'prog-mode-hook 'linum-mode)
        (add-hook 'text-mode-hook 'linum-mode))
      (when dotspace-macs-line-numbers
        (global-linum-mode)))))

(defun space-macs-defaults/init-occur-mode ()
  (evilified-state-evilify-map occur-mode-map
    :mode occur-mode))

(defun space-macs-defaults/init-package-menu ()
  (evilified-state-evilify-map package-menu-mode-map
    :mode package-menu-mode))

(defun space-macs-defaults/init-page-break-lines ()
  (require 'page-break-lines)
  (global-page-break-lines-mode t)
  (space-macs|hide-lighter page-break-lines-mode))

(defun space-macs-defaults/init-process-menu ()
  (evilified-state-evilify process-menu-mode process-menu-mode-map))

(defun space-macs-defaults/init-recentf ()
  (use-package recentf
    :defer (space-macs/defer)
    :commands (recentf-save-list)
    :init
    (progn
      (space-macs|require-when-dumping 'recentf)
      (when (space-macs/defer)
        (add-hook 'find-file-hook (lambda () (unless recentf-mode
                                               (recentf-mode)
                                               (recentf-track-opened-file)))))
      (setq recentf-save-file (concat space-macs-cache-directory "recentf")
            recentf-max-saved-items 1000
            recentf-auto-cleanup 'never
            recentf-auto-save-timer (run-with-idle-timer 600 t
                                                         'recentf-save-list)))
    :config
    (progn
      (add-to-list 'recentf-exclude
                   (recentf-expand-file-name space-macs-cache-directory))
      (add-to-list 'recentf-exclude (recentf-expand-file-name package-user-dir))
      (add-to-list 'recentf-exclude "COMMIT_EDITMSG\\'"))))

(defun space-macs-defaults/init-savehist ()
  (use-package savehist
    :init
    (progn
      ;; Minibuffer history
      (setq savehist-file (concat space-macs-cache-directory "savehist")
            enable-recursive-minibuffers t ; Allow commands in minibuffers
            history-length 1000
            savehist-additional-variables '(mark-ring
                                            global-mark-ring
                                            search-ring
                                            regexp-search-ring
                                            extended-command-history)
            savehist-autosave-interval 60)
      (savehist-mode t))))

(defun space-macs-defaults/init-saveplace ()
  (use-package saveplace
    :init
    (progn
      (if (fboundp 'save-place-mode)
          ;; e-macs 25 has a proper mode for `save-place'
          (save-place-mode)
        (setq save-place t))
      ;; Save point position between sessions
      (setq save-place-file (concat space-macs-cache-directory "places")))))

(defun space-macs-defaults/init-subword ()
  (use-package subword
    :defer t
    :init
    (progn
      (unless (category-docstring ?U)
        (define-category ?U "Uppercase")
        (define-category ?u "Lowercase"))
      (modify-category-entry (cons ?A ?Z) ?U)
      (modify-category-entry (cons ?a ?z) ?u)
      (make-variable-buffer-local 'evil-cjk-word-separating-categories)
      (defun space-macs//subword-enable-camel-case ()
        "Add support for camel case to subword."
        (if subword-mode
            (push '(?u . ?U) evil-cjk-word-separating-categories)
          (setq evil-cjk-word-separating-categories
                (default-value 'evil-cjk-word-separating-categories))))
      (add-hook 'subword-mode-hook 'space-macs//subword-enable-camel-case)
      (space-macs|add-toggle camel-case-motion
        :mode subword-mode
        :documentation "Toggle CamelCase motions."
        :evil-leader "tc")
      (space-macs|add-toggle camel-case-motion-globally
        :mode global-subword-mode
        :documentation "Globally toggle CamelCase motions."
        :evil-leader "t C-c"))
    :config
    (space-macs|diminish subword-mode " â“’" " c")))

(defun space-macs-defaults/init-tar-mode ()
  (evilified-state-evilify-map tar-mode-map
    :mode tar-mode
    :eval-after-load tar-mode))

(defun space-macs-defaults/init-uniquify ()
  (require 'uniquify)
  ;; When having windows with repeated filenames, uniquify them
  ;; by the folder they are in rather those annoying <2>,<3>,.. etc
  (setq uniquify-buffer-name-style 'post-forward-angle-brackets
        ;; don't screw special buffers
        uniquify-ignore-buffers-re "^\\*"))

(defun space-macs-defaults/init-url ()
  ;; gravatars from magit use this to store their cache
  (setq url-configuration-directory (concat space-macs-cache-directory "url/")))

(defun space-macs-defaults/init-whitespace ()
  (use-package whitespace
    :defer t
    :init
    (progn
      (setq space-macs-show-trailing-whitespace t)
      (defun space-macs//show-trailing-whitespace ()
        (when space-macs-show-trailing-whitespace
          (set-face-attribute 'trailing-whitespace nil
                              :background
                              (face-attribute 'font-lock-comment-face
                                              :foreground))
          (setq show-trailing-whitespace 1)))
      (add-hook 'prog-mode-hook 'space-macs//show-trailing-whitespace)

      (space-macs|add-toggle whitespace
        :mode whitespace-mode
        :documentation "Display whitespace."
        :evil-leader "tw")
      (space-macs|add-toggle whitespace-globally
        :mode global-whitespace-mode
        :documentation "Display whitespace globally."
        :evil-leader "t C-w")

      (defun space-macs//set-whitespace-style-for-diff ()
        "Whitespace configuration for `diff-mode'"
        (setq-local whitespace-style '(face
                                       tabs
                                       tab-mark
                                       spaces
                                       space-mark
                                       trailing
                                       indentation::space
                                       indentation::tab
                                       newline
                                       newline-mark)))
      (add-hook 'diff-mode-hook 'whitespace-mode)
      (add-hook 'diff-mode-hook 'space-macs//set-whitespace-style-for-diff))
    :config
    (progn
      (set-face-attribute 'whitespace-space nil
                          :background nil
                          :foreground (face-attribute 'font-lock-warning-face
                                                      :foreground))
      (set-face-attribute 'whitespace-tab nil
                          :background nil)
      (set-face-attribute 'whitespace-indentation nil
                          :background nil)
      (space-macs|diminish whitespace-mode " â“¦" " w")
      (space-macs|diminish global-whitespace-mode " â“¦" " w"))))

(defun space-macs-defaults/init-winner ()
  (use-package winner
    :commands (winner-undo winner-redo)
    :init
    (with-eval-after-load 'winner
      (setq space-macs/winner-boring-buffers '("*Completions*"
                                              "*Compile-Log*"
                                              "*inferior-lisp*"
                                              "*Fuzzy Completions*"
                                              "*Apropos*"
                                              "*Help*"
                                              "*cvs*"
                                              "*Buffer List*"
                                              "*Ibuffer*"
                                              "*esh command on file*"
                                              ))
      (setq winner-boring-buffers
            (append winner-boring-buffers space-macs/winner-boring-buffers)))))

(defun space-macs-defaults/init-zone ()
  (use-package zone
    :commands (zone zone-when-idle)
    :init
    (progn
      (when (and dotspace-macs-zone-out-when-idle
                 (numberp dotspace-macs-zone-out-when-idle))
        (zone-when-idle dotspace-macs-zone-out-when-idle))
      ;; remove not interesting programs
      (setq zone-programs [
                           ;; zone-pgm-jitter
                           zone-pgm-putz-with-case
                           zone-pgm-dissolve
                           ;; zone-pgm-explode
                           zone-pgm-whack-chars
                           zone-pgm-rotate
                           zone-pgm-rotate-LR-lockstep
                           zone-pgm-rotate-RL-lockstep
                           zone-pgm-rotate-LR-variable
                           zone-pgm-rotate-RL-variable
                           zone-pgm-drip
                           ;; zone-pgm-drip-fretfully
                           ;; zone-pgm-five-oclock-swan-dive
                           ;; zone-pgm-martini-swan-dive
                           zone-pgm-rat-race
                           zone-pgm-paragraph-spaz
                           ;; zone-pgm-stress
                           ;; zone-pgm-stress-destress
                           ;; zone-pgm-random-life
                           ])
      (space-macs/set-leader-keys "TZ" 'zone))
    :config
    ;; be sure to disable running zone if the user does not want it
    (unless dotspace-macs-zone-out-when-idle
      (zone-leave-me-alone))))


