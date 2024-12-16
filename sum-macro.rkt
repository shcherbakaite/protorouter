#lang racket


(define-syntax sum*
  (syntax-rules ()
    [(sum*) 0] ; Base case: empty list
    [(sum* a rest ...) (+ a (sum* rest ...))])) ; Recursive case

(sum* 1 2 3)


;(define-syntax measure*
;  (syntax-rules ()
;    [(measure* ) 0])) ; Base case: empty list

; (measure* 1)
    
    ;[(measure* a rest ...) (+ a (sum* rest ...))])) ; Recursive case



;; (define-syntax (sum** stx)
;;   (syntax-case stx ()
;;     [(sum**) #'0] ; Base case: empty list
;;     [(sum** a rest ...) #'(+ a (sum** rest ...))])) ; Recursive case
;; 



(define-syntax (measure stx)
  (syntax-case stx ()
    [(measure (a rest ...)) #'( (measure (+ a 1)) (measure rest ...))] ; Recursive case
    [(measure a) #'a])) ; Base case: empty list


(define-syntax my-let*
  (syntax-rules ()
    [(my-let* () body-expr)
     body-expr]
    [(my-let* ([id rhs-expr] binding ...) body-expr)
     (let ([id rhs-expr]) (my-let* (binding ...) body-expr))]))



