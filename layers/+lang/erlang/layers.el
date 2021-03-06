;;; layers.el --- Erlang Layer declarations File for Space-macs
;;
;; Copyright (c) 2012-2020 Sylvain Benner & Contributors
;;
;; Author: Carlos F. Clavijo <arkan1313@gmail.com>
;; URL: https://github.com/syl20bnr/space-macs
;;
;; This file is not part of GNU e-macs.
;;
;;; License: GPLv3

(when (and (boundp 'erlang-backend)
           (eq erlang-backend 'lsp))
  (configuration-layer/declare-layer-dependencies '(lsp)))


