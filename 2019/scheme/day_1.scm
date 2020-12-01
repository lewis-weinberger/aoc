;;;
;;; --- Day 1: The Tyranny of the Rocket Equation ---
;;;
;;; Part 1) What is the sum of the fuel requirements for all of the
;;; modules on your spacecraft?
;;;
;;; Part 2) What is the sum of the fuel requirements for all of the
;;; modules on your spacecraft when also taking into account the mass
;;; of the added fuel?
;;; 
;;; -------------------------------------------------
;;;

(use-modules (ice-9 rdelim))

;; Fuel for a given mass
(define (fuel mass)
  (- (floor (/ mass 3)) 2))

;; Include fuel contribution from fuel itself
(define (fuel-iter total remaining)
  (let ((new-remaining (fuel remaining)))
    (cond ((<= new-remaining 0) total)
	  (else (fuel-iter (+ total new-remaining)
			   new-remaining)))))

;; Iterate over input from stdin
(define (total n m)
  (let ((line (read-line)))
    (if (eof-object? line)
	  (values n m)
	  (let ((current (fuel (string->number line))))
	    (total (+ n current) (+ m (fuel-iter current current)))))))

;; Print total required fuel
(define (main args)
  (call-with-values (lambda () (total 0 0))
    (lambda (a b)
      (format #t "Part 1) Total required fuel = ~a\nPart 2) Total required fuel = ~a\n" a b))))
