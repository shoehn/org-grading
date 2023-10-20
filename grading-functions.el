;;; grading-functions.el --- Utility functions for grading sheets -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2023 Sebastian Hoehn
;;
;; Author: Sebastian Hoehn <sebastian.hoehn@gmail.com>
;; Maintainer: Sebastian Hoehn <sebastian.hoehn@gmail.com>
;; Created: October 20, 2023
;; Modified: October 20, 2023
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex tools unix vc wp
;; Homepage: https://github.com/shoehn/grading-functions
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

;; Section: Summary table generation
(defun sh-generate-summary-table ()
  (message "Generating summary table...")
  (let* (
        (sh-table (list 'hline '("Criteria" "Obtained Points" "Maximum Points")))
        (total-obtained 0)
        (total-points 0))
    (message "Initial table: %S" sh-table)  ; Print initial table
    (save-excursion
      (goto-char (point-min))
      ;; Search for criteria sections
      (while (re-search-forward "^\\*\\* \\(.*\\)" nil t)
        (let ((criteria (match-string 1))
              (points (string-to-number (or (org-entry-get (point) "points") "0")))
              (total (string-to-number (or (org-entry-get (point) "total") "0"))))
          (when (and criteria points total)
            (setq total-obtained (+ total-obtained points))
            (setq total-points (+ total-points total))
            (push (list criteria (number-to-string points) (number-to-string total)) sh-table)))))
    ;; Add summary line
    (push 'hline sh-table)
    (push (list "Total Points" (number-to-string total-obtained) (number-to-string total-points)) sh-table)
    (push 'hline sh-table)
    (let ((grade (+ (* (/ (float total-obtained) (float total-points)) 5) 1)))
      (push (list "**Grading**" (number-to-string grade) (/ (round (* grade 2)) 2) ) sh-table))

    ;; Return the table in reverse order to maintain the original order of criteria sections
    (nreverse sh-table)))

;;; grading-functions.el ends here
