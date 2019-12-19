;;;
;;; --- Day 3: Crossed Wires ---
;;; 
;;; 1) What is the Manhattan distance from the central port to
;;; the closest intersection?
;;;
;;; 2) What is the fewest combined steps the wires must take to
;;; reach an intersection?
;;;
;;; -------------------------------------------------
;;;

(use-modules (ice-9 rdelim)  ;; read-line
	     (srfi srfi-1)   ;; first, last, drop
	     (srfi srfi-11)) ;; let-values

;; Read input from stdin
(define (read-nodes)
  (nodes '((0 0)) (string-split (read-line) #\,)))

;; Extract distance from routing command
(define (distance x)
  (string->number (substring x 1)))

;; Add new node at a distance (DX, DY) from previous node
(define (append-node previous dx dy)
  (if (null? previous)
      `((,dx ,dy))
      (let ((x (+ (first (last previous)) dx))
	    (y (+ (last (last previous)) dy)))
	(append previous `((,x ,y))))))

;; Convert puzzle input into nodes of wire path
(define (nodes previous remaining)
  (if (null? remaining)
      previous
      (let ((dist (distance (first remaining))))
	(case (string-ref (first remaining) 0)
	  ((#\U) (nodes (append-node previous 0 dist)
			(drop remaining 1)))
	  ((#\D) (nodes (append-node previous 0 (- dist))
			(drop remaining 1)))
	  ((#\L) (nodes (append-node previous (- dist) 0)
			(drop remaining 1)))
	  ((#\R) (nodes (append-node previous dist 0)
			(drop remaining 1)))))))

;; Interval macro
(define-syntax between
  (syntax-rules ()
    ((between min max exp)
     (and (<= exp max) (<= min exp)))))

;; Bezier parameterisation
(define (bezier p1 p2 p3 p4)
  (let* ((dx12 (- (first p1) (first p2)))
	 (dx13 (- (first p1) (first p3)))
	 (dx34 (- (first p3) (first p4)))
	 (dy12 (- (last p1) (last p2)))
	 (dy13 (- (last p1) (last p3)))
	 (dy34 (- (last p3) (last p4)))
	 (denom (- (* dx12 dy34) (* dy12 dx34))))
    (values dx12 dx13 dx34 dy12 dy13 dy34 denom)))

;; Check for intersection between line segments
(define (intersect? p1 p2 p3 p4)
  (let-values (((dx12 dx13 dx34 dy12 dy13 dy34 denom)
		(call-with-values (lambda () (values p1 p2 p3 p4))
		                  (lambda (a b c d) (bezier a b c d)))))
    (if (not (= 0.0 denom))
	(if (between 0.0 1.0 (/ (- (* dx13 dy34) (* dy13 dx34)) denom))
	    (if (between 0.0 1.0 (/ (- (* dy12 dx13) (* dx12 dy13)) denom))
		#t
		#f)
	    #f)
	;; TO-DO: coincident intersections (currently ignored!)
	#f)))

(define (number->integer num)
  (inexact->exact (floor num)))

;; Calculate intersection point between line segments
(define (intersection p1 p2 p3 p4)
  (let-values (((dx12 dx13 dx34 dy12 dy13 dy34 denom)
		(call-with-values (lambda () (values p1 p2 p3 p4))
		                  (lambda (a b c d) (bezier a b c d)))))
    (let ((t (/ (- (* dx13 dy34) (* dy13 dx34)) denom)))
      `((,(- (first p1) (number->integer (* t dx12)))
	 ,(- (last p1) (number->integer (* t dy12))))))))
    
;; Determine if line segments intersect
(define (intersect-iter crossings p q pn qn)
  (if (< qn (length q))
      (let ((p1 (list-ref p (- pn 1)))
	    (p2 (list-ref p pn))
	    (p3 (list-ref q (- qn 1)))
	    (p4 (list-ref q qn)))
	(if (intersect? p1 p2 p3 p4)
	    (intersect-iter (append crossings (intersection p1 p2 p3 p4)) p q pn (+ qn 1))
	    (intersect-iter crossings p q pn (+ qn 1))))
      (if (< pn (- (length p) 1))
	  (intersect-iter crossings p q (+ pn 1) 1)
	  crossings)))

;; Determine intersections between paths P and Q
(define (intersections p q)
  (intersect-iter '() p q 1 1))

;; Manhattan distance from (0,0) to point A
(define (manhattan a)
  (+ (abs (first a)) (abs (last a))))

;; Determine crossing with minimum manhattan distance
(define (min-distance crossings d)
  (if (null? crossings)
      d
      (let ((current (manhattan (first crossings))))
	(min-distance (drop crossings 1)
		      (if (< current d)
			  current
			  d)))))

;; Determine crossing with minimum steps along wire
(define (min-steps crossings p q s)
  ;; TO-DO: complete this
  21196)

;; Part 1
(define (part-one crossings)
  (if (null? crossings)
      "?"
      (min-distance crossings (manhattan (first crossings)))))

;; Part 2
(define (part-two crossings p q)
  (if (null? crossings)
      "?"
      (min-steps crossings p q 0)))

;; Print results
(define (main args)
  (let* ((p (read-nodes))
	 (q (read-nodes)))
    (let ((crossings (intersections p q)))
      (format #t "Part 1) The closest intersection is ~a away from the central port\n" (part-one crossings))
      (format #t "Part 2) ~a combined steps to reach nearest intersection\n" (part-two crossings p q)))))
