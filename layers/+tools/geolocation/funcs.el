;;; funcs.el --- geolocation functions File for Space-macs
;;
;; Copyright (c) 2012-2020 Sylvain Benner & Contributors
;;
;; Author: Eivind Fonn <evfonn@gmail.com>
;; URL: https://github.com/syl20bnr/space-macs
;;
;; This file is not part of GNU e-macs.
;;
;;; License: GPLv3


(defun space-macs//osx-location-changed ()
  (let ((location-changed-p nil)
        (_longitude (/ (truncate (* osx-location-longitude 10)) 10.0)) ; one decimal point, no rounding
        (_latitdue (/ (truncate (* osx-location-latitude 10)) 10.0)))
    (unless (equal (bound-and-true-p calendar-longitude) _longitude)
      (setq calendar-longitude _longitude
            location-changed-p t))
    (unless (equal (bound-and-true-p  calendar-latitude) _latitdue)
      (setq calendar-latitude _latitdue
            location-changed-p t))
    (when (and (configuration-layer/layer-used-p 'geolocation) location-changed-p)
      (message "Location changed %s %s (restarting rase-timer)" calendar-latitude calendar-longitude)
      (rase-start t))))

(defun space-macs//osx-location-changed-rase ()
  (setq calendar-latitude osx-location-latitude
        calendar-longitude osx-location-longitude)
  (unless (bound-and-true-p calendar-location-name)
    (setq calendar-location-name
          (format "%s, %s"
                  osx-location-latitude
                  osx-location-longitude))))

(defun geolocation//activate-theme-changer ()
  (unless (bound-and-true-p calendar-longitude)
    (user-error "calendar-longitude is not set"))
  (unless (bound-and-true-p calendar-latitude)
    (user-error "calendar-latitude is not set"))
  (when (> (length dotspace-macs-themes) 1)
    (change-theme (nth 0 dotspace-macs-themes)
                  (nth 1 dotspace-macs-themes))))


