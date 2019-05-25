(define (make-zero-crossings input-stream last-value)
    (let ((avpt (/ (+ (stream-car input-stream)
                      last-value)
                   2)))
        (cons-stream
         (sign-change-detector avpt last-value)
        (make-zero-crossings
         (stream-cdr input-stream) avpt))))

; fixed version

(define (make-zero-crossings input-stream last-value last-avpt)
    (let ((avpt (/ (+ (stream-car input-stream)
                      last-value)
                   2)))
        (cons-stream
         (sign-change-detector avpt last-value)
        (make-zero-crossings
         (stream-cdr input-stream) 
         (stream-car input-stream)
         avpt))))