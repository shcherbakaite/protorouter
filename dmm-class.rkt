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
    
    (abstract dc-voltage)
    ;(abstract ac-voltage)
    ;(abstract resistance)
    ;(abstract dc-current)
    ;(abstract ac-current)
       
    ))


(require libserialport)

(displayln (serial-ports))

(define-values (in out)
  (open-serial-port  "/dev/ttyUSB0" #:baudrate 115200))

;(let loop ()
;  (displayln (read-line in))
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


;; Basic DMM Class Definition
(define fluke45-dmm%
  (class dmm%
    (super-new)

    (field [com-port "/dev/ttyUSB0"])
     
    (define/override (dc-voltage)
      (define-values (in out)
        (open-serial-port  "/dev/ttyUSB0" #:baudrate 115200))
      
      (write "VDC\n" out)
      (define resp (read-line in))

      (close-output-port out)
      (close-input-port in)
      resp
      )
      
    ;(abstract ac-voltage)
    ;(abstract resistance)
    ;(abstract dc-current)
    ;(abstract ac-current)


    ))