(load "Chapter 2/2.5 Systems with Generic Operations/exercise_2.84.scm")
(define (install-polynomial-package)
    ;; internal procedures
    ;; representation of poly
    (define (make-poly variable term-list) (cons variable term-list))
    (define (variable p) (car p))
    (define (term-list p) (cdr p))

    (define (variable? x)
        (symbol? x))
    (define (same-variable? v1 v2)
        (and (variable? v1) (variable? v2) (eq? v1 v2)))
    (define (=zero? n)
        (define (poly? n)
            (eq? (type-tag n) 'polynomial ))
        (define (zero-terms? termlist) 
            (or (empty-termlist? termlist) 
                (and (=zero? (coeff (first-term termlist))) 
                    (zero-terms? (rest-terms termlist)))))
        (if (poly? n)
            (zero-terms? n)
            (zero? n)))

    ;; representation of terms and term lists
    (define (adjoin-term term term-list)
        (if (=zero? (coeff term))
            term-list
            (cons term term-list)))
    (define (the-empty-termlist) '())
    (define (first-term termlist) (car termlist))
    (define (rest-terms termlist) (cdr termlist))
    (define (empty-termlist? termlist) (null? termlist))
    (define (make-term order coeff) (list order coeff))
    (define (order term) (car term))
    (define (coeff term) (cadr term))
    ;; procedure to add and multiply term lists
    (define (add-terms L1 L2)
        (cond ((empty-termlist? L1) L2)
              ((empty-termlist? L2) L1)
              (else
                (let ((t1 (first-term L1))
                      (t2 (first-term L2)))
                    (cond ((> (order t1) (order t2))
                           (adjoin-term
                            t1 (add-terms (rest-terms L1) L2)))
                          ((< (order t1) (order t2))
                           (adjoin-term
                            t2 (add-terms L1 (rest-terms L2))))
                          (else
                            (adjoin-term
                             (make-term (order t1)
                                        (add (coeff t1) (coeff t2)))
                             (add-terms (rest-terms L1)
                                        (rest-terms L2)))))))))
    (define (mul-terms L1 L2)
        (if (empty-termlist? L1)
            (the-empty-termlist)
            (add-terms (mul-term-by-all-terms (first-term L1) L2)
                       (mul-terms (rest-terms L1) L2))))
    (define (mul-term-by-all-terms t1 L)
        (if (empty-termlist? L)
            (the-empty-termlist)
            (let ((t2 (first-term L)))
                (adjoin-term
                 (make-term (+ (order t1) (order t2))
                            (mul (coeff t1) (coeff t2)))
                 (mul-term-by-all-terms t1 (rest-terms L))))))

    (define (add-poly p1 p2)
        (if (same-variable? (variable p1) (variable p2))
            (make-poly (variable p1)
                (add-terms (term-list p1) (term-list p2)))
            (error "Polys not in same var: ADD-POLY" (list p1 p2))))
    (define (mul-poly p1 p2)
        (if (same-variable? (variable p1) (variable p2))
            (make-poly (variable p1)
                    (mul-terms (term-list p1) (term-list p2)))
            (error "Polys not in same var: MUL-POLY" (list p1 p2))))

    ;; interface to rest of the system
    (define (tag p) (attach-tag 'polynomial p))
    (put 'add '(polynomial polynomial)
        (lambda (p1 p2) (tag (add-poly p1 p2))))
    (put 'mul '(polynomial polynomial)
        (lambda (p1 p2) (tag (mul-poly p1 p2))))
    (put 'mul '(polynomial scheme-number)
        (lambda (p n) (tag (mul-poly p (make-poly 
                                        (variable p)
                                        (list (list 0 n)))))))
    (put 'make 'polynomial
        (lambda (var terms) (tag (make-poly var terms))))
    (put '=zero? 'polynomial =zero?)
'done )

(install-polynomial-package)

(define (make-polynomial var terms)
    ((get 'make 'polynomial ) var terms))