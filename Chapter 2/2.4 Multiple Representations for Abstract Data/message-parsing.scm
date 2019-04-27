(define (make-from-real-imag x y)
    (define (dispatch op)
        (cond ((eq? 'real-part op) x)
              ((eq? 'imag-part op) y)
              ((eq? 'magnitude op) (sqrt (+ (square x) (square y))))
              ((eq? 'angle op) (atan y x))
              (else (error "Unknown op: MAKE-FROM-REAL-IMAG" op))))
    dispatch)
(define (apply-generic p arg) (arg op))