(define (solve-2nd a b y0 dy0 dt)
    (define y (integral (delay dy) y0 dt))
    (define b-stream (scale-stream y b))
    (define a-stream (scale-stream (delay dy) a))
    (define dy (integral (add-streams a-stream b-stream)
                         dy0 dt))
    y)