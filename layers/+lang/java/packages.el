;;; packages.el --- Java Layer packages File for Space-macs
;;
;; Copyright (c) 2012-2020 Sylvain Benner & Contributors
;;
;; Author: Lukasz Klich <klich.lukasz@gmail.com>
;; URL: https://github.com/syl20bnr/space-macs
;;
;; This file is not part of GNU e-macs.
;;
;;; License: GPLv3

(defconst java-packages
  '(
    company
    dap-mode
    flycheck
    ggtags
    counsel-gtags
    helm-gtags
    (java-mode :location built-in)
    maven-test-mode
    (meghanada :toggle (not (version< e-macs-version "25.1")))
    mvn
    (lsp-java :requires lsp-mode)
    org
    smartparens))

(defun java/post-init-company ()
  (add-hook 'java-mode-local-vars-hook #'space-macs//java-setup-company))

(defun java/pre-init-dap-mode ()
  (pcase (space-macs//java-backend)
    (`lsp (add-to-list 'space-macs--dap-supported-modes 'java-mode)))
  (add-hook 'java-mode-local-vars-hook #'space-macs//java-setup-dap))

(defun java/post-init-flycheck ()
  (add-hook 'java-mode-local-vars-hook #'space-macs//java-setup-flycheck))

(defun java/post-init-ggtags ()
  (add-hook 'java-mode-local-vars-hook #'space-macs/ggtags-mode-enable))

(defun java/post-init-smartparens ()
  (with-eval-after-load 'smartparens
    (sp-local-pair 'java-mode "/** " " */" :trigger "/**")))

(defun java/post-init-counsel-gtags ()
  (space-macs/counsel-gtags-define-keys-for-mode 'java-mode))

(defun java/post-init-helm-gtags ()
  (space-macs/helm-gtags-define-keys-for-mode 'java-mode))

(defun java/pre-init-org ()
  (space-macs|use-package-add-hook org
    :post-config (add-to-list 'org-babel-load-languages '(java . t))))

(defun java/init-java-mode ()
  (use-package java-mode
    :defer t
    :init
    (progn
      (add-hook 'java-mode-local-vars-hook #'space-macs//java-setup-backend)
      (put 'java-backend 'safe-local-variable 'symbolp))))

(defun java/init-maven-test-mode ()
  (use-package maven-test-mode
    :defer t
    :init
    (when (configuration-layer/package-used-p 'java-mode)
      (add-hook 'java-mode-hook 'maven-test-mode)
      (space-macs/declare-prefix-for-mode 'java-mode "mm" "maven")
      (space-macs/declare-prefix-for-mode 'java-mode "mmg" "goto")
      (space-macs/declare-prefix-for-mode 'java-mode "mmt" "tests"))
    :config
    (progn
      (space-macs|hide-lighter maven-test-mode)
      (space-macs/set-leader-keys-for-minor-mode 'maven-test-mode
        "mga"    'maven-test-toggle-between-test-and-class
        "mgA"    'maven-test-toggle-between-test-and-class-other-window
        "mta"    'maven-test-all
        "mt C-a" 'maven-test-clean-test-all
        "mtb"    'maven-test-file
        "mti"    'maven-test-install
        "mtt"    'maven-test-method))))

(defun java/init-meghanada ()
  (use-package meghanada
    :defer t
    :if (eq java-backend 'meghanada)
    :init
    (progn
      (setq meghanada-server-install-dir (concat space-macs-cache-directory
                                                 "meghanada/")
            company-meghanada-prefix-length 1
            ;; let space-macs handle company and flycheck itself
            meghanada-use-company nil
            meghanada-use-flycheck nil))
    :config
    (progn
      ;; key bindings
      (dolist (prefix '(("mc" . "compile")
                        ("mD" . "daemon")
                        ("mg" . "goto")
                        ("mr" . "refactor")
                        ("mt" . "test")
                        ("mx" . "execute")))
        (space-macs/declare-prefix-for-mode
          'java-mode (car prefix) (cdr prefix)))
      (space-macs/set-leader-keys-for-major-mode 'java-mode
        "cb" 'meghanada-compile-file
        "cc" 'meghanada-compile-project

        "Dc" 'meghanada-client-direct-connect
        "Dd" 'meghanada-client-disconnect
        "Di" 'meghanada-install-server
        "Dk" 'meghanada-server-kill
        "Dl" 'meghanada-clear-cache
        "Dp" 'meghanada-ping
        "Dr" 'meghanada-restart
        "Ds" 'meghanada-client-connect
        "Du" 'meghanada-update-server
        "Dv" 'meghanada-version

        "gb" 'meghanada-back-jump

        "=" 'meghanada-code-beautify
        "ri" 'meghanada-optimize-import
        "rI" 'meghanada-import-all

        "ta" 'meghanada--run-junit
        "tc" 'meghanada-run-junit-class
        "tl" 'meghanada-run-junit-recent
        "tt" 'meghanada-run-junit-test-case

        ;; meghanada-switch-testcase
        ;; meghanada-local-variable

        "x:" 'meghanada-run-task))))

(defun java/init-lsp-java ()
  (use-package lsp-java
    :defer t
    :if (eq (space-macs//java-backend) 'lsp)
    :config
    (progn
      ;; key bindings
      (dolist (prefix '(("ma" . "actionable")
                        ("mc" . "compile/create")
                        ("mg" . "goto")
                        ("mr" . "refactor")
                        ("mra" . "add/assign")
                        ("mrc" . "create/convert")
                        ("mrg" . "generate")
                        ("mre" . "extract")
                        ("mp" . "project")
                        ("mq" . "lsp")
                        ("mt" . "test")
                        ("mx" . "execute")))
        (space-macs/declare-prefix-for-mode
          'java-mode (car prefix) (cdr prefix)))
      (space-macs/set-leader-keys-for-major-mode 'java-mode
        "pu"  'lsp-java-update-project-configuration

        ;; refactoring
        "ro" 'lsp-java-organize-imports
        "rcp" 'lsp-java-create-parameter
        "rcf" 'lsp-java-create-field
        "rci" 'lsp-java-conver-to-static-import
        "rec" 'lsp-java-extract-to-constant
        "rel" 'lsp-java-extract-to-local-variable
        "rem" 'lsp-java-extract-method

        ;; assign/add
        "rai" 'lsp-java-add-import
        "ram" 'lsp-java-add-unimplemented-methods
        "rat" 'lsp-java-add-throws
        "raa" 'lsp-java-assign-all
        "raf" 'lsp-java-assign-to-field

        ;; generate
        "rgt" 'lsp-java-generate-to-string
        "rge" 'lsp-java-generate-equals-and-hash-code
        "rgo" 'lsp-java-generate-overrides
        "rgg" 'lsp-java-generate-getters-and-setters

        ;; create/compile
        "cc"  'lsp-java-build-project
        "cp"  'lsp-java-spring-initializr

        "an"  'lsp-java-actionable-notifications))))

(defun java/init-mvn ()
  (use-package mvn
    :defer t
    :init
    (when (configuration-layer/package-used-p 'java-mode)
      (space-macs/declare-prefix-for-mode 'java-mode "mm" "maven")
      (space-macs/declare-prefix-for-mode 'java-mode "mmc" "compile")
      (space-macs/set-leader-keys-for-major-mode 'java-mode
        "mcc" 'mvn-compile
        "mcC" 'mvn-clean
        "mcr" 'space-macs/mvn-clean-compile))))


