(load "Chapter 4/4.1 The Metacircular Evaluator/exercise_4.12.scm")
(define (make-unbound! var env)
    (env-loop env var '() (lambda (x)
                            (if (null? (cdr x))
                                (set-car! x '())
                                (set-car! x (cdr x)))))
    'ok )