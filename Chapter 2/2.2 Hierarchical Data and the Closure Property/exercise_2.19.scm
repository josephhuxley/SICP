(load "Chapter 2/2.2 Hierarchical Data and the Closure Property/list-operations.scm")
(define us-coins (list 50 25 10 5 1))
(define uk-coins (list 100 50 20 10 5 2 1 0.5))
(define (cc amount coin-values)
    (cond ((= amount 0) 1)
          ((or (< amount 0) (no-more? coin-values)) 0)
          (else
            (+ (cc amount
                   (except-first-denomination
                    coin-values))
               (cc (- amount
                      (first-denomination
                       coin-values))
                    coin-values)))))
(define (first-denomination items) (car items))
(define (except-first-denomination items) (cdr items))
(define (no-more? items) (= (length items) 0))