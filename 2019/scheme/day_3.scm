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

(use-modules (ice-9 rdelim) ;; read-line
	     (srfi srfi-1)) ;; first, last, drop, fold


;;; Coordinate setup -----------------------------------------------------------


;; Coordinate object
(define (coord x y)
  (define (dispatch m)
    (cond ((eq? m 'coord-x) x)
	  ((eq? m 'coord-y) y)
	  ((eq? m 'pair) (cons x y))
	  (else (error "Unknown request" m))))
  dispatch)

;; Difference between two coordinates along x
(define (coord-dx a b)
  (- (a 'coord-x) (b 'coord-x)))

;; Difference between two coordinates along y
(define (coord-dy a b)
  (- (a 'coord-y) (b 'coord-y)))

;; Check if coordinates are equal
(define (eq-coord? a b)
  (and (eqv? (a 'coord-x) (b 'coord-x))
       (eqv? (a 'coord-y) (b 'coord-y))))

;; New node at a distance (DX, DY) from previous node
(define (new-node previous dx dy)
    (let ((x (+ (previous 'coord-x) dx))
	(y (+ (previous 'coord-y) dy)))
    (coord x y)))

;; Convert puzzle input command into node (dx, dy)
(define (input->nodes nodes input)
  (if (null? input)
      nodes
      (let ((dist (string->number (substring (first input) 1))))
	(case (string-ref (first input) 0)
	  ((#\U) (input->nodes (append nodes `(,(new-node (last nodes) 0 dist)))
			       (drop input 1)))
	  ((#\D) (input->nodes (append nodes `(,(new-node (last nodes) 0 (- dist))))
			       (drop input 1)))
	  ((#\L) (input->nodes (append nodes `(,(new-node (last nodes) (- dist) 0)))
			       (drop input 1)))
	  ((#\R) (input->nodes (append nodes `(,(new-node (last nodes) dist 0)))
			       (drop input 1)))))))

;; Read input from stdin
(define (read-nodes)
  (input->nodes `(,(coord 0 0)) (string-split (read-line) #\,)))


;;; Intersections --------------------------------------------------------------


;; Interval macro
(define-syntax between
  (syntax-rules ()
    ((between min max exp)
     (and (<= exp max) (<= min exp)))))

;; Truncate number
(define (number->integer num)
  (inexact->exact (floor num)))
    
;; Iterate over line segments to determine intersections between P and Q
(define (intersections crossings p q pn qn)
  (if (< qn (length q))
      ;; Points defining current line segments
      (let* ((p1 (list-ref p (- pn 1)))
	     (p2 (list-ref p pn))
	     (p3 (list-ref q (- qn 1)))
	     (p4 (list-ref q qn))
	     ;; Bezier parametrization
	     (dx12 (coord-dx p1 p2))
	     (dx13 (coord-dx p1 p3))
	     (dx34 (coord-dx p3 p4))
	     (dy12 (coord-dy p1 p2))
	     (dy13 (coord-dy p1 p3))
	     (dy34 (coord-dy p3 p4))
	     (denom (- (* dx12 dy34) (* dy12 dx34))))
	(if (not (= 0.0 denom))
	    ;; Perpendicular intersections
	    (let ((t (/ (- (* dx13 dy34) (* dy13 dx34)) denom)))
	      (if (between 0.0 1.0 t)
		  (let ((u (/ (- (* dy12 dx13) (* dx12 dy13)) denom)))
		    (if (between 0.0 1.0 u)
			(intersections (append crossings
					       ;; Coordinate of intersection
					       `(,(coord (- (p1 'coord-x) (number->integer (* t dx12)))
							 (- (p1 'coord-y) (number->integer (* t dy12))))))
				       p q pn (+ qn 1))
			(intersections crossings p q pn (+ qn 1))))
		  (intersections crossings p q pn (+ qn 1))))
	    ;; Parallel intersections (currently ignored!)
	    (intersections crossings p q pn (+ qn 1))))
      (if (< pn (- (length p) 1))
	  (intersections crossings p q (+ pn 1) 1)
	  crossings)))


;;; Part 1 ---------------------------------------------------------------------


;; Find minimum value in list
(define (list-min lst)
  (fold (lambda (val prev)
	  (if (< val prev)
	      val
	      prev))
	(first lst)
	lst))

;; Manhattan distance from (0,0) to point A
(define (manhattan a)
  (+ (abs (a 'coord-x)) (abs (a 'coord-y))))

;; Part 1
(define (part-one crossings)
  (if (null? crossings)
      "?"
      (list-min (map manhattan crossings))))


;;; Part 2 ---------------------------------------------------------------------


;; Add val to Kth entry in LST
(define (add-val lst k val)
  (if (< k (length lst))
      (cond ((null? lst) '())
	    ((= k 0) (cons (+ val (car lst)) (cdr lst)))
	    (else (cons (car lst) (add-val (cdr lst) (- k 1) val))))
      '()))

;; Sign of NUM
(define (sign num)
  (if (= num 0)
      0
      (/ num (abs num))))

;; Count steps along path to crossing
(define (count-steps steps nsteps current remaining crossings)
  (if (null? remaining)
      steps
      (let* ((next-node (first remaining))
	     (dx (coord-dx next-node current))
	     (dy (coord-dy next-node current))
	     (contains (filter (lambda (x) (eq-coord? x current)) crossings))
	     (index (if (null? contains)
			'()
			(list-index (lambda (x) (eq-coord? x (first contains)))
				    crossings)))
	     (new-steps (if (null? contains)
			    steps
			    (add-val steps index nsteps)))
	     (new-nsteps (if (or (not (= dx 0)) (not (= dy 0)))
			     (+ nsteps 1)
			     nsteps))
	     (next-point (new-node current (sign dx) (sign dy)))
	     (still-remaining (if (or (not (= dx 0)) (not (= dy 0)))
				  remaining
				  (drop remaining 1))))
	(count-steps new-steps
		     new-nsteps
		     next-point
		     still-remaining
		     crossings))))

;; Determine number of steps to each crossing
(define (crossings->steps crossings p q)
  ;; Determine steps to each crossing
  (let* ((steps (make-list (length crossings) 0))
	 (steps-p (count-steps steps 0 (first p) p crossings))
	 (steps-q (count-steps steps 0 (first q) q crossings)))
    ;; Add together steps along each wire
    (map + steps-p steps-q)))

;; Part 2
(define (part-two crossings p q)
  (if (null? crossings)
      "?"
      (let ((steps (crossings->steps crossings p q)))
	(list-min steps))))


;;; Main -----------------------------------------------------------------------


;; Print results
(define (main args)
  (let* ((p (read-nodes))
	 (q (read-nodes)))
    (let ((crossings (intersections '() p q 1 1)))
      (format #t "Part 1) The closest intersection is ~a away from the central port\n" (part-one crossings))
      (format #t "Part 2) ~a combined steps to reach nearest intersection\n" (part-two crossings p q)))))
