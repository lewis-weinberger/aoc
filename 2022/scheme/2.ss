;;; read a list of lines of puzzle input
(define (read-lines lst)
  (let ((line (get-line (current-input-port))))
    (if (eof-object? line)
        (reverse lst)
        (let* ((split (filter char-alphabetic? (string->list line)))
               (num (cons (- (char->integer (car split)) (char->integer #\@))
                          (- (char->integer (cadr split)) (char->integer #\W)))))
          (read-lines (cons num lst))))))

(define (shape npc pc)
  (+ 1 (modulo (+ npc pc) 3)))

(define (score npc pc)
  (* 3 (modulo (+ 1 (modulo (- pc npc) 3)) 3)))

(define (part-1 acc elt)
  (let ((npc (car elt))
        (pc (cdr elt)))
    (+ acc pc (score npc pc))))

(define (part-2 acc elt)
  (let ((npc (car elt))
        (pc (cdr elt)))
    (+ acc (shape npc pc) (* 3 (- pc 1)))))

(let ((input (read-lines '())))
  ;; part 1
  (display (fold-left part-1 0 input))
  (newline)
  ;; part 2
  (display (fold-left part-2 0 input))
  (newline))
