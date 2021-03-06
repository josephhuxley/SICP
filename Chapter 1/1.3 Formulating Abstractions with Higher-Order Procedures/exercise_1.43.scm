(define (repeated f n)
    (if (= n 1)
         f
         (repeated (lambda (x) (f (f x))) (- n 1))))
    
(define (square x) (* x x))