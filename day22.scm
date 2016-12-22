(use srfi-1)
(use srfi-13)
(use irregex)

(define-record-type node
                    (make-node x y size used available)
                    node?
                    (x node-x)
                    (y node-y)
                    (size node-size)
                    (used node-used)
                    (available node-available))

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

(define nodes (with-input-from-file "input" (lambda () (port-map line->node read-line))))

(define non-empty (filter (lambda (node) (not (= 0 (node-used node)))) nodes))

(define node-lists (map (lambda (a-node)
       (filter (lambda (b-node)
                 (and
                   (not (eq? a-node b-node))
                   (<= (node-used a-node) (node-available b-node)))) nodes))
     non-empty))

(display (apply + (map length node-lists)))
(print)
