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
	     (srfi srfi-1)) ;; first, last, drop


;;; Coordinate setup -----------------------------------------------------------


;; Coordinate pair
(define (coord x y)
  (cons x y))

;; Return x-coordinate
(define (coord-x coordinate)
  (car coordinate))

;; Return y-coordinate
(define (coord-y coordinate)
  (cdr coordinate))

;; Difference between two coordinates along x
(define (coord-dx a b)
  (- (coord-x a) (coord-x b)))

;; Difference between two coordinates along y
(define (coord-dy a b)
  (- (coord-y a) (coord-y b)))

;; Append coordinate to list
(define (append-coord lst coordinate)
  (append lst `(,coordinate)))

;; Check if coordinates are equal
(define (eq-coord? a b)
  (and (eqv? (coord-x a) (coord-x b))
       (eqv? (coord-y a) (coord-y b))))

;; New node at a distance (DX, DY) from previous node
(define (new-node previous dx dy)
    (let ((x (+ (coord-x previous) dx))
	(y (+ (coord-y previous) dy)))
    (coord x y)))

;; Convert puzzle input command into node (dx, dy)
(define (input->nodes nodes input)
  (if (null? input)
      nodes
      (let ((dist (string->number (substring (first input) 1))))
	(case (string-ref (first input) 0)
	  ((#\U) (input->nodes (append-coord nodes (new-node (last nodes) 0 dist))
			       (drop input 1)))
	  ((#\D) (input->nodes (append-coord nodes (new-node (last nodes) 0 (- dist)))
			       (drop input 1)))
	  ((#\L) (input->nodes (append-coord nodes (new-node (last nodes) (- dist) 0))
			       (drop input 1)))
	  ((#\R) (input->nodes (append-coord nodes (new-node (last nodes) dist 0))
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
			(intersections (append-coord crossings
						     ;; Coordinate of intersection
						     (coord (- (coord-x p1) (number->integer (* t dx12)))
							    (- (coord-y p1) (number->integer (* t dy12)))))
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
(define (list-min lst min)
  (if (null? lst)
      min
      (let ((current (first lst)))
	(list-min (drop lst 1)
		  (if (< current min)
		      current
		      min)))))

;; Manhattan distance from (0,0) to point A
(define (manhattan a)
  (+ (abs (coord-x a)) (abs (coord-y a))))

;; Part 1
(define (part-one crossings)
  (if (null? crossings)
      "?"
      (list-min (map manhattan crossings)
		(manhattan (first crossings)))))


;;; Part 2 ---------------------------------------------------------------------


;; Sign
(define (sign num)
  (if (= num 0)
      0
      (/ num (abs num))))

;; Check if list contains coordinate value
(define (contains? lst val)
  (if (null? (filter (lambda (x) (eq-coord? x val)) lst))
      #f
      #t))

;; Count steps along path to crossing
(define (count-steps steps nsteps current remaining crossings)
  (if (null? remaining)
      steps
      (let* ((next-node (first remaining))
	     (dx (coord-dx next-node current))
	     (dy (coord-dy next-node current))
	     (new-steps (if (contains? crossings current)
			    (append steps `(,nsteps))
			    steps))
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
  (let ((steps-p (count-steps '() 0 (first p) p crossings))
	(steps-q (count-steps '() 0 (first q) q crossings)))
    ;; Add together steps along each wire
    (map + steps-p steps-q)))

;; Part 2
(define (part-two crossings p q)
  (if (null? crossings)
      "?"
      (let ((steps (crossings->steps crossings p q)))
	(list-min steps (first steps)))))


;;; Main -----------------------------------------------------------------------


;; Print results
(define (main args)
  (let* ((p (read-nodes))
	 (q (read-nodes)))
    (let ((crossings (intersections '() p q 1 1)))
      (format #t "Part 1) The closest intersection is ~a away from the central port\n" (part-one crossings))
      (format #t "Part 2) ~a combined steps to reach nearest intersection\n" (part-two crossings p q)))))
