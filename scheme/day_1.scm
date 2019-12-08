;;;
;;; --- Day 1: The Tyranny of the Rocket Equation ---
;;;
;;; What is the sum of the fuel requirements for all of the modules on your spacecraft?
;;; 
;;; -------------------------------------------------
;;;

(use-modules (ice-9 rdelim))

;; Fuel for a given mass
(define (fuel mass)
  (- (floor (/ mass 3)) 2))

;; Iterate over input from stdin
(define (total n)
  (let ((line (read-line)))
    (if (eof-object? line)
	  n
	  (total (+ n (fuel (string->number line)))))))

;; Print total required fuel
(define (main args)
 (format #t "Total required fuel = ~a\n" (total 0)))
