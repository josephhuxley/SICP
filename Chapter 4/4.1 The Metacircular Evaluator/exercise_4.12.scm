(load "Chapter 4/4.1 The Metacircular Evaluator/exercise_4.11.scm")
(define (env-loop env var null-proc found-proc)
    (define (search-enclosing-env)
        (env-loop (enclosing-environment env) var search-enclosing-env found-proc))

    (define (scan bindings)
        (cond ((null? bindings)
               (if (null? null-proc)
                   (search-enclosing-env)
                   (null-proc env)))
            ((eq? var (caar bindings)) (found-proc bindings))
            (else (scan (cdr bindings)))))

    (if (eq? env the-empty-environment)
            (error "Unbound variable" var)
            (let ((frame (first-frame env)))
                (scan (frame-bindings frame)))))

(define (lookup-variable-value var env)
    (env-loop env var '() (lambda (x) (cdar x))))

(define (set-variable-value! var val env)
    (env-loop env var '() (lambda (x) (set-cdr! (car x) (list val))))
    'ok )

(define (define-variable! var val env)
    (env-loop env var (lambda (x) (add-binding-to-frame! var val (first-frame env)))
                      (lambda (x) (set-cdr! (car x) val)))
    'ok )