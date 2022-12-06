;;; are all element of this list unique
(define (unique? lst)
  (cond
    ((null? lst) #t)
     ((not (member (car lst) (cdr lst))) (unique? (cdr lst)))
     (else #f)))

;;; find the position of a marker with k unique characters
(define (marker k lst sub n)
  (cond
    ((< (length sub) k) (marker k (cdr lst) (cons (car lst) sub) (+ 1 n)))
    ((unique? sub) n)
    (else
     (marker k (cdr lst) (cons (car lst) (list-head sub (- k 1))) (+ 1 n)))))

(let* ((input (string->list (get-line (current-input-port)))))
  ;; part 1
  (display (marker 4 input '() 0))
  (newline)
  ;; part 2
  (display (marker 14 input '() 0))
  (newline))
