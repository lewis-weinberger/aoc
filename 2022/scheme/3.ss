(define a-val (char->integer #\a))
(define A-val (char->integer #\A))

;;; convert letters to priority value
(define (priority c)
  (let ((val (char->integer c)))
    (if (>= val a-val)
        (+ 1 (- val a-val))
        (+ 27 (- val A-val)))))

;;; split list halfway into pair
;;; tortoise and hare (https://stackoverflow.com/a/26478795)
(define (split lst)
  (let loop ((tortoise lst) (hare lst) (acc '()))
    (if (or (null? hare) (null? (cdr hare)))
        (cons (reverse acc) tortoise)
        (loop (cdr tortoise)
              (cddr hare)
              (cons (car tortoise) acc)))))

;;; read puzzle input from stdin
(define (read-lines lst)
  (let ((line (get-line (current-input-port))))
    (if (eof-object? line)
        (reverse lst)
        (let ((p (map priority (string->list line))))
          (read-lines (cons p lst))))))

;;; find duplicate element between src and dst
(define (find-dupe src dst rem)
  (cond
    ((null? dst) #f)
    ((null? rem) (find-dupe (cdr src) dst dst))
    ((member (car src) rem) (car src))
    (else (find-dupe src dst (cdr rem)))))

;;; find duplicate elements between src and dst
(define (find-dupes src dst rem lst)
  (cond
    ((null? dst) #f)
    ((null? src) lst)
    ((null? rem) (find-dupes (cdr src) dst dst lst))
    ((member (car src) rem) (find-dupes (cdr src) dst dst (cons (car src) lst)))
    (else (find-dupes src dst (cdr rem) lst))))

(define (part-1 acc elt)
  (let* ((lst (split elt))
         (src (car lst))
         (dst (cdr lst)))
    (+ acc (find-dupe src dst dst))))

(define (part-2 acc elt)
  (let ((num (car acc))
        (grp (cdr acc)))
    (if (< (length grp) 2)
        (cons num (cons elt grp))
        (let* ((a (car grp))
               (b (cadr grp))
               (dupes (find-dupes a b b '())))
          (cons (+ num (find-dupe dupes elt elt)) '())))))

(let ((input (read-lines '())))
  ;; part 1
  (display (fold-left part-1 0 input))
  (newline)
  ;; part 2
  (display (car (fold-left part-2 (cons 0 '()) input)))
  (newline))
