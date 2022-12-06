;;; read puzzle input from STDIN
(define (read-lines lst)
  (let ((line (get-line (current-input-port))))
    (if (eof-object? line)
        (reverse lst)
        (read-lines (cons line lst)))))

;;; separate input into starting stack and movements
(define (split lst rem)
  (if (= (string-length (car lst)) 0)
      (cons (reverse (cdr rem)) (cdr lst))
      (split (cdr lst) (cons (car lst) rem))))

;;; parse a line of crates
(define (parse-stack str vec n)
  (if (< n (string-length str))
      (begin
        (if (not (eqv? (string-ref str n) #\space))
            (let* ((index (floor (/ n 4)))
                  (rem (vector-ref vec index)))
              (vector-set! vec index (cons (string-ref str n) rem))))
        (parse-stack str vec (+ n 4)))))

;;; populate vector of stacks
(define (make-stacks start)
  (let* ((num (/ (+ (string-length (car start)) 1) 4))
         (stacks (make-vector num '())))
    (let loop ((lst (reverse start)))
      (if (null? lst)
          stacks
          (begin
            (parse-stack (car lst) stacks 1)
            (loop (cdr lst)))))))

;;; parse movement procedures
(define (parse-moves input)
  (let loop ((rem input) (sub '()) (lst '()))
    (cond
      ((null? rem)
       (reverse (cons (string->number (list->string (reverse sub))) lst)))
      ((char=? #\space (car rem))
       (if (> (length sub) 0)
           (loop (cdr rem)
                 '()
                 (cons (string->number (list->string (reverse sub))) lst))
           (loop (cdr rem) '() lst)))
      (else (loop (cdr rem) (cons (car rem) sub) lst)))))

;;; apply movement procedure to stacks
(define (crate-mover-9000 stacks move)
  (let ((i (car move)) (j (- (cadr move) 1)) (k (- (caddr move) 1)))
    (let loop ((n i) (from (vector-ref stacks j)) (to (vector-ref stacks k)))
      (if (= n 0)
          stacks
          (begin
            (vector-set! stacks j (cdr from))
            (vector-set! stacks k (cons (car from) to))
            (loop (- n 1) (cdr from) (cons (car from) to)))))))

;;; apply movement procedure to stacks
(define (crate-mover-9001 stacks move)
  (let* ((i (car move)) (j (- (cadr move) 1)) (k (- (caddr move) 1))
         (from (vector-ref stacks j)) (to (vector-ref stacks k)))
    (vector-set! stacks j (list-tail from i))
    (vector-set! stacks k (append (list-head from i) to)))
  stacks)

(define (not-alphabetic? c)
  (not (char-alphabetic? c)))

(define (strip str)
  (filter not-alphabetic? (string->list str)))

(define (part-1 stacks moves)
  (list->string
    (vector->list
      (vector-map car (fold-left crate-mover-9000 stacks moves)))))

(define (part-2 stacks moves)
  (list->string
    (vector->list
      (vector-map car (fold-left crate-mover-9001 stacks moves)))))

(let* ((input (split (read-lines '()) '()))
       (stacks (make-stacks (car input)))
       (moves (map parse-moves (map strip (cdr input)))))
  ;; part 1
  (display (part-1 (vector-copy stacks) moves))
  (newline)
  ;; part 2
  (display (part-2 stacks moves))
  (newline))
