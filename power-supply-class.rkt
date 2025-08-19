#lang racket

(require racket/class)
(require "connections.rkt")
(require "matrix.rkt")

;; Power Supply Class Template
;; 
;; This is a proper Racket class template for implementing power supply functionality.

(provide power-supply%)

;; Power Supply Class Definition
(define power-supply%
  (class object%
    (super-new)
    
    ;; Class fields (private state)
    (field [voltage 0]
           [current 0]
           [enabled #f]
           [output-name "DEFAULT"])
    
    ;; Constructor
    (init [initial-voltage 0]
          [initial-current 0]
          [initial-enabled #f]
          [name "DEFAULT"])
    
    ;; Initialize fields
    (set! voltage initial-voltage)
    (set! current initial-current)
    (set! enabled initial-enabled)
    (set! output-name name)
    
    ;; Public methods
    
    ;; Set voltage
    (define/public (set-voltage new-voltage)
      (matrix-update)
      (printf "Setting ~a voltage to ~a V...\n" output-name new-voltage)
      (set! voltage new-voltage))
    
    ;; Set current limit
    (define/public (set-current new-current)
      (matrix-update)
      (printf "Setting ~a current limit to ~a A...\n" output-name new-current)
      (set! current new-current))
    
    ;; Enable output
    (define/public (enable)
      (matrix-update)
      (printf "Enabling ~a output...\n" output-name)
      (set! enabled #t))
    
    ;; Disable output
    (define/public (disable)
      (matrix-update)
      (printf "Disabling ~a output...\n" output-name)
      (set! enabled #f))
    
    ;; Get voltage
    (define/public (get-voltage)
      (matrix-update)
      (printf "Reading ~a voltage...\n" output-name)
      voltage)
    
    ;; Get current
    (define/public (get-current)
      (matrix-update)
      (printf "Reading ~a current...\n" output-name)
      current)
    
    ;; Get power
    (define/public (get-power)
      (matrix-update)
      (printf "Reading ~a power...\n" output-name)
      (* voltage current))
    
    ;; Get status
    (define/public (get-status)
      (matrix-update)
      (printf "~a Status: Voltage=~aV, Current=~aA, Enabled=~a\n" 
              output-name voltage current enabled)
      (list voltage current enabled))
    
    ;; Connect to target
    (define/public (connect target)
      (matrix-update)
      (printf "Connecting ~a to ~a...\n" output-name target)
      (connect output-name target))
    
    ;; Disconnect from target
    (define/public (disconnect target)
      (matrix-update)
      (printf "Disconnecting ~a from ~a...\n" output-name target)
      (disconnect output-name target))
    
    ;; Reset to defaults
    (define/public (reset)
      (matrix-update)
      (printf "Resetting ~a...\n" output-name)
      (set! voltage 0)
      (set! current 0)
      (set! enabled #f))
    
    ;; Example of how to use this class:
    ;; (define ps1 (new power-supply% [initial-voltage 5.0] [initial-current 1.0] [name "P6V"]))
    ;; (send ps1 enable)
    ;; (send ps1 connect 'J2-1)
    ;; (send ps1 get-status)
    ))
