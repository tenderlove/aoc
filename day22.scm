(use srfi-1)
(use srfi-13)
(use format)
(use irregex)

(define-record-type node
                    (make-node x y size used available)
                    node?
                    (x node-x)
                    (y node-y)
                    (size node-size)
                    (used node-used)
                    (available node-available))

(define-record-printer (node x out)
                       ;(fprintf out "[~S,~S ~S/~S]"
                       (fprintf out "~A/~A"
                       ;(fprintf out "x:~S y:~S"
                                ;(node-x x) (node-y x) (node-used x) (node-size x)))
                                (format "~3D" (node-used x)) (format "~3D" (node-size x))))

; (/dev/grid/node-x27-y1 86T 65T 21T 75%)

(define (line->node line)
  (let ((split-line (string-tokenize line))
        (strip-char (lambda (str) (string->number (irregex-replace "[^0-9]" str)))))

    (let ((split-address (irregex-split (irregex "\\-") (car split-line)))
          (size      (strip-char (cadr split-line)))
          (used      (strip-char (caddr split-line)))
          (available (strip-char (cadddr split-line))))

      (let ((x (strip-char (cadr split-address)))
            (y (strip-char (caddr split-address))))

        (make-node x y size used available)))))

(define (group-by! mproc alist acc)
  (if (null? alist)
      (reverse (map reverse acc))
      (let ((list-head (car alist))
            (prev-list (car acc)))
        (if (or (null? prev-list) (eq? (mproc list-head) (mproc (car prev-list))))
          ; Append
            (group-by! mproc (cdr alist)
                       (cons (cons list-head prev-list)
                             (cdr acc)))
          ; Start new list
            (group-by! mproc (cdr alist)
                       (cons (list list-head) acc))))))

(define (group-by proc alist) (group-by! proc alist '(())))

(define (rotate-cc matrix) (apply map list matrix))


(define (map-matrix proc matrix)
  (map (lambda (row) (map proc row)) matrix))

(define (filter-matrix proc matrix)
  (filter proc (apply append matrix)))

(define (find-node x y matrix)
  (if (or (< x 0)
          (< y 0)
          (> x (- (matrix-width matrix) 1))
          (> y (- (matrix-height matrix) 1)))
    #f
    (letrec ((find-row (lambda (y matrix)
                         (if (= 0 y)
                           (car matrix)
                           (find-row (- y 1) (cdr matrix))))))
      (find-row x (find-row y matrix)))))

(define (matrix-width matrix) (length (car matrix)))
(define (matrix-height matrix) (length matrix))

(define (node-left node matrix)
      (find-node (- (node-x node) 1) (node-y node) matrix))

(define (node-right node matrix)
      (find-node (+ (node-x node) 1) (node-y node) matrix))

(define (node-down node matrix)
      (find-node (node-x node) (+ (node-y node) 1) matrix))

(define (node-up node matrix)
      (find-node (node-x node) (- (node-y node) 1) matrix))

(define (can-move? node-from node-to)
  (< (+ (node-used node-from) (node-used node-to))
    (node-size node-to)))

(define (node-neighbors node matrix)
  (filter (lambda (x) x) (list (node-up    node matrix)
                               (node-down  node matrix)
                               (node-left  node matrix)
                               (node-right node matrix))))

(define (move-node from to matrix)
  (map (lambda (row)
         (map (lambda (node)
                (cond ((eq? node from)
                       (make-node (node-x from)
                                  (node-y from)
                                  (node-size from)
                                  (node-used to)
                                  (node-available from)))
                      ((eq? node to)
                       (make-node (node-x to)
                                  (node-y to)
                                  (node-size to)
                                  (node-used from)
                                  (node-available to)))
                      (else node))) row)) matrix))

(define (make-grid nodes) (rotate-cc (group-by node-x nodes)))

(define nodes (with-input-from-file "input" (lambda () (port-map line->node read-line))))

(define node-grid (make-grid nodes))
(map (lambda (row) (display row) (print)) node-grid)
(define zero (car (filter-matrix (lambda (node) (= 0 (node-used node))) node-grid)))
(display (node-neighbors zero node-grid))
(print)
(display zero)
(print)
(display (can-move? zero (node-up zero node-grid)))
(print)
(map (lambda (row) (display row) (print)) (move-node zero (node-up zero node-grid) node-grid))
