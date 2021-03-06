;;; layers.el --- docker Layer declarations File for Space-macs
;;
;; Copyright (c) 2012-2020 Sylvain Benner & Contributors
;;
;; Author: Seong Yong-ju <sei40kr@gmail.com>
;; URL: https://github.com/syl20bnr/space-macs
;;
;; This file is not part of GNU e-macs.
;;
;;; License: GPLv3

(when (and (boundp 'docker-dockerfile-backend)
           (eq docker-dockerfile-backend 'lsp))
  (configuration-layer/declare-layer-dependencies '(lsp)))


