#lang racket

(require racket/class)
(require "connections.rkt")
(require "matrix.rkt")

;; Basic DMM Class Template
;; 
;; This is a proper Racket class template for implementing basic DMM functionality.
;; Basic measurement modes: VDC, VAC, OHMS, CONTINUITY, ADC, AAC, RANGE

(provide dmm%)

;; Basic DMM Class Definition
(define dmm%
  (class object%
    (super-new)

    (abstract measure?)
    (abstract resistance-mode!)
    (abstract dc-voltage-mode!)
    (abstract ac-voltage-mode!)
    (abstract dc-current-mode!)
    (abstract ac-current-mode!)
       
    ))


(require libserialport)

(displayln (serial-ports))

;(define-values (in out)
;  (open-serial-port  "COM5"))
                     
(define read-buffer (make-bytes 100))

;(let loop ()
;    (define read-result (read-bytes-avail!* read-buffer in))
;    (cond [(or (eof-object? read-result)
;               (and (number? read-result) (not (= read-result 0))))
;           (display (bytes->string/utf-8 (read-bytes read-result in)))
;           (display "")]
;          [else (sleep 0.1)])
;    (loop))

;(let loop ()
;  (writeln "OHMS" out)
  ;(displayln (read-line in))
;  (sleep 1)
;  (loop)
;)
  
(define buf (make-bytes 100))

;(let loop ()
;  (define n (read-bytes-avail! buf in))
;  (cond
;    [(eof-object? n)
;     (displayln "Port closed")]
;    [(positive? n)
;     (define msg (subbytes buf 0 n))
;     ;; Print as text (replace invalid UTF-8 with �)
;     (display (bytes->string/utf-8 msg ))])
;  (sleep 0.5) ; prevent busy-waiting
;  (loop))

;; helper: open port, run a thunk, then close everything
(define (with-serial com-port proc)
  (define-values (in out)
    (open-serial-port com-port #:baudrate 9600))
  (define result (proc in out))
  (close-output-port out)
  (close-input-port in)
  result)

;; Basic DMM Class Definition
(define fluke45-dmm%
  (class dmm%
    (super-new)

    (field [com-port "COM5"])

    (define/override (dc-current-mode!)
       (with-serial com-port
        (λ (in out)
          (write "ADC\n" out)
          (read-line in))))

    (define/override (ac-current-mode!)
      (with-serial com-port
        (λ (in out)
          (write "AAC\n" out)
          (read-line in))))
    
    (define/override (ac-voltage-mode!)
      (with-serial com-port
        (λ (in out)
          (write "VAC\n" out)
          (read-line in))))
    
    (define/override (resistance-mode!)
        (with-serial com-port
        (λ (in out)
          (write "OHMS\n" out)
          (read-line in))))
    
    (define/override (dc-voltage-mode!)
      (with-serial com-port
        (λ (in out)
          (write "VDC\n" out)
          (read-line in))))

    (define/override (measure?)
      (with-serial com-port
        (λ (in out)
          (write "*OPN?\n" out)
          (write "MEAS1?\n" out)
          (string->number (read-line in)))))
    
    ))