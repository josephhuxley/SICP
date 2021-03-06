(define (timed-prime-test n)
    (newline)
    (display n)
    (start-prime-test n (runtime)))
(define (start-prime-test n start-time)
    (if (fermat-test n)
        (report-prime (- (runtime) start-time))))
(define (report-prime elapsed-time)
    (display " *** ")
    (display elapsed-time))

(define (search-for-primes lowerbound upperbound)
    (if (is-even? lowerbound)
        (search-for-primes (+ lowerbound 1) upperbound)
        (cond ((< lowerbound upperbound) (timed-prime-test lowerbound)
            (search-for-primes (+ lowerbound 2) upperbound)))))

(define (is-even? n)
    (= (remainder n 2) 0))

(define (expmod base exp m)
    (cond ((= exp 0) 1)
          ((even? exp)
           (remainder
            (square (expmod base (/ exp 2) m))
            m))
           (else
            (remainder
                (* base (expmod base (- exp 1) m))
                m))))
(define (fermat-test n)
    (define (try-it a)
        (= (expmod a n n) a))
    (try-it (+ 1 (random (- n 1)))))
(define (fast-prime? n times)
    (cond ((= n 1) false)
          ((= times 0) true)
          ((fermat-test n) (fast-prime? n (- times 1)))
          (else false)))