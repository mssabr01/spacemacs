;;; layers.el --- Javascript Layer layers File for Space-macs
;;
;; Copyright (c) 2012-2020 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/space-macs
;;
;; This file is not part of GNU e-macs.
;;
;;; License: GPLv3

(configuration-layer/declare-layer-dependencies '(json node prettier web-beautify))

(when (boundp 'javascript-backend)
  (pcase javascript-backend
    ('lsp (configuration-layer/declare-layer-dependencies '(lsp)))
    ('tide (configuration-layer/declare-layer-dependencies '(tide)))
    ('tern (configuration-layer/declare-layer-dependencies '(tern)))))


