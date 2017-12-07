(define banks '(0 2 7 0))

(define (clear-bank banks max-bank)
  (let ((iter (lambda (head rest acc fn)
                      (if (= head max-bank)
                          (reverse (append (reverse rest) (cons 0 acc)))
                          (fn (car rest)
                              (cdr rest)
                              (cons head acc)
                              fn)))))

    (iter (car banks) (cdr banks) '() iter)))

(define (redistribute-test banks)
  (let ((max-bank (car (sort banks >))))
    (let ((cleared-bank (clear-bank banks max-bank)))
      (redistribute-memory banks memory)

    (print)))
(display (redistribute-test '(1 2 3 6 2 1 6 6 1)))
;(define (redistribute-iter banks seen counter)
;        (if (any? (lambda (item) (equal? banks seen)) seen)
;            counter
;            (let ((max-bank (car (sort banks max))))
;              (let ((cleared-bank (clear-bank banks max-bank)))
;                (let ((new-banks (redistribute-bank amount banks)))
;                     (redistribute-iter new-banks
;                                        (cons banks seen)
;                                        (+ 1 counter)))))))

