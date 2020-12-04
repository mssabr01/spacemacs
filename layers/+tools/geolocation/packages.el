;;; packages.el --- geolocation configuration File for Space-macs
;;
;; Copyright (c) 2012-2020 Sylvain Benner & Contributors
;;
;; Author: Uri Sharf <uri.sharf@me.com>
;; URL: https://github.com/usharf/space-macs
;;
;; This file is not part of GNU e-macs.
;;
;;; License: GPLv3

(setq geolocation-packages
      '(
        (osx-location :toggle (and geolocation-enable-location-service
                                   (space-macs/system-is-mac)))
        popwin
        (rase :toggle (and geolocation-enable-location-service
                           (space-macs/system-is-mac)))
        (sunshine :toggle geolocation-enable-weather-forecast)
        (theme-changer :toggle geolocation-enable-automatic-theme-changer)
        ))

(defun geolocation/init-osx-location ()
  "Initialize osx-location"
  (use-package osx-location
    :defer t
    :init
    (progn
      (add-hook 'osx-location-changed-hook 'space-macs//osx-location-changed)
      (osx-location-watch))))

(defun geolocation/init-rase ()
  (use-package rase
    :defer t
    :init
    (progn
      (add-hook 'osx-location-changed-hook 'space-macs//osx-location-changed-rase)
      (osx-location-watch)
      (defadvice rase-start (around test-calendar activate)
        "Don't call `raise-start' if `calendar-latitude' or
`calendar-longitude' are not bound yet, or still nil.

This is setup this way because `rase.el' does not test these
values, and will fail under such conditions, when calling
`solar.el' functions.

Also, it allows users who enabled service such as `osx-location'
to not have to set these variables manually when enabling this layer."
        (if (and (bound-and-true-p calendar-longitude)
                 (bound-and-true-p calendar-latitude))
            ad-do-it))
      (rase-start t))))

(defun geolocation/init-sunshine ()
  "Initialize sunshine"
  (use-package sunshine
    :commands (sunshine-forecast sunshine-quick-forecast)
    :init
    (progn
      (space-macs/declare-prefix "atg" "geolocation")
      (space-macs/set-leader-keys
        "atgw" 'sunshine-forecast
        "atgW" 'sunshine-quick-forecast))
    :config
    (progn
      (evilified-state-evilify-map sunshine-mode-map
        :mode sunshine-mode
        :bindings
        (kbd "q") 'quit-window
        (kbd "i") 'sunshine-toggle-icons)

      ;; just in case location was not set by user, or on macOS,
      ;; if wasn't set up automatically, will not work with e-macs'
      ;; default for `calendar-location-name'
      (unless (boundp 'sunshine-location)
        (setq sunshine-location (format "%s, %s"
                                        calendar-latitude
                                        calendar-longitude))))))

(defun geolocation/init-theme-changer ()
  "Initialize theme-changer"
  (use-package theme-changer
    :init
    (progn
      (space-macs/defer-until-after-user-config #'geolocation//activate-theme-changer))))

(defun geolocation/pre-init-popwin ()
  "Pin the weather forecast to the bottom window"
  (space-macs|use-package-add-hook popwin
    :post-config
    (push '("*Sunshine*" :dedicated t :position bottom)
          popwin:special-display-config)))


