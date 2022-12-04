(define (delimiter? c)
  (if (or (eqv? c #\-) (eqv? c #\,)) #t #f))

;;; parse assignment pairs
(define (parse str lst n)
  (let ((len (string-length str)))
    (cond
      ((= len n) (reverse (cons (string->number str) lst)))
      ((delimiter? (string-ref str n))
       (parse
         (substring str (+ 1 n) len)
         (cons (string->number (substring str 0 n)) lst)
         0))
      (else (parse str lst (+ 1 n))))))

;;; read puzzle input from STDIN
(define (read-lines lst)
  (let ((line (get-line (current-input-port))))
    (if (eof-object? line)
        (reverse lst)
        (read-lines (cons (parse line '() 0) lst)))))

(define (full-overlap lst)
  (let ((lo1 (car lst))
        (hi1 (cadr lst))
        (lo2 (caddr lst))
        (hi2 (cadddr lst)))
    (if (or (and (>= lo2 lo1) (<= hi2 hi1))
            (and (>= lo1 lo2) (<= hi1 hi2)))
        1
        0)))

(define (partial-overlap lst)
  (let ((lo1 (car lst))
        (hi1 (cadr lst))
        (lo2 (caddr lst))
        (hi2 (cadddr lst)))
    (if (or (and (>= lo2 lo1) (>= hi1 lo2))
            (and (>= lo1 lo2) (>= hi2 lo1)))
        1
        0)))

(define (part-1 acc elt)
  (+ acc (full-overlap elt)))

(define (part-2 acc elt)
  (+ acc (partial-overlap elt)))

(let ((input (read-lines '())))
  ;; part 1
  (display (fold-left part-1 0 input))
  (newline)
  ;; part 2
  (display (fold-left part-2 0 input))
  (newline))

