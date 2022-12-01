;;; read a list of lines of puzzle input
(define (read-lines lst)
  (let ((line (get-line (current-input-port))))
    (if (eof-object? line)
        (reverse lst)
        (read-lines (cons line lst)))))

;;; insert into sorted list
(define (insert-sorted elt lst)
  (cond
    ((null? lst) (list elt))
    ((>= elt (car lst)) (cons elt lst))
    (else (cons (car lst) (insert-sorted elt (cdr lst))))))

;;; count Calories for each elf into sorted list
(define (count-calories acc elt)
  (let ((n (string->number elt))
        (max (car acc))
        (sum (cdr acc)))
    (if n
        (cons max (+ sum n))
        (cons (insert-sorted sum max) 0))))

(let ((input (read-lines '())))
  (let ((counts (car (fold-left count-calories (cons '() 0) input))))
    ;; part 1
    (display (car counts))
    (newline)
    ;; part 2
    (display (+ (car counts) (cadr counts) (caddr counts)))
    (newline)))
