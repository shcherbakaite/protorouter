#lang racket

(require racket/class)
(require "connections.rkt")
(require "matrix.rkt")
(require libserialport)

(provide dmm% fluke45-dmm% )

;; Basic DMM Class Definition
(define dmm%
  (class object%
    (super-new)
 
      (abstract measure?)
      (abstract ohms!)
      (abstract vdc!)
      (abstract vac!)
      (abstract adc!)
      (abstract aac!)
      (abstract cont!)


       
    ))
                     


(define (read-full-response in)

  (define result "")
  (define buf (make-bytes 1024))
  (define cycles 0)
  (let loop ()
    (define avail (read-bytes-avail!* buf in))
    (when (> avail 0)
      ;(define n (read-bytes buf in avail))
      ;(displayln result)
      (set! result (string-append result (bytes->string/utf-8 (subbytes buf 0 avail)))))
    ;; Stop condition, e.g., newline or expected length
    (when (> avail 0)
      (set! cycles 0))
    (unless (or  (string-contains? result "=>") (string-contains? result "?>") (> cycles 50))
      (set! cycles (+ cycles 1))
      (displayln cycles)
      (sleep 0.1)
      (loop))
    result))

(define (flush-input in)
  (define buf (make-bytes 1024))
  (let loop ()
    (define avail (read-bytes-avail!* buf in))
    (when (> avail 0)
      (loop))))

;; helper: open port, run a thunk, then close everything
(define (with-serial com-port proc)
  (define-values (in out)
    (open-serial-port com-port #:baudrate 9600 #:flowcontrol `none))
  (define result (proc in out))
  (flush-output out)
  (flush-input in)
  (close-output-port out)
  (close-input-port in)
  result)

(define (send-cmd out cmd)
  (display (string-append cmd "\r") out)
  (flush-output out))

(define regex-number #px"([+-]?(?:\\d+(?:\\.\\d*)?|\\.\\d+)(?:[eE][+-]?\\d+)?)")

;; Basic DMM Class Definition
(define fluke45-dmm%
  (class dmm%
    (super-new)

    (field [com-port "/dev/ttyUSB0"])

    (define/override (adc!)
       (with-serial com-port
        (λ (in out)
          (send-cmd out "ADC")
          ;(send-cmd out "*OPC?")
          (read-full-response in))))

    (define/override (aac!)
      (with-serial com-port
        (λ (in out)
          (send-cmd out "AAC")
          ;(send-cmd out "*OPC?")
          (read-full-response in))))
    
    (define/override (vac!)
      (with-serial com-port
        (λ (in out)
          (send-cmd out "VAC")
          ;(send-cmd out "*OPC?")
          (flush-input in)
          (read-full-response in))))
    
    (define/override (ohms!)
        (with-serial com-port
        (λ (in out)
          (send-cmd out "OHMS")
          ;(send-cmd out "*OPC?")
          (flush-input in)
          (read-full-response in))))

    (define/override (cont!)
        (with-serial com-port
        (λ (in out)
          (send-cmd out "CONT")
          ;(send-cmd out "*OPC?")
          (flush-input in)
          (read-full-response in))))
    
    (define/override (vdc!)
      (with-serial com-port
        (λ (in out)
          (send-cmd out "VDC")
          ;(send-cmd out "*OPC?")
          (flush-input in)
          (read-full-response in))))

    (define/override (measure?)
      (with-serial com-port
        (λ (in out)
          (send-cmd out "MEAS1?")
          ;(send-cmd out "*OPC?")
          (define resp (read-full-response in))
          (displayln resp)
          (define matches (regexp-match* regex-number resp))
          ;matches)))
          (string->number  (car matches)))))

     (define/public (identify?)
      (with-serial com-port
        (λ (in out)
          (send-cmd out "*IDN?")
          (read-full-response in)
          )))
    ))


(define dmm1 (new  fluke45-dmm%))


(send dmm1 ohms!)
(send dmm1 measure?)
; (send dmm1 vdc!)
; (send dmm1 measure?)
