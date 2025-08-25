#lang racket/gui

(require racket/class
         racket/gui/base
         racket/string)

(require canvas-list)

; Create the main frame
(define main-frame (new frame% 
                       [label "Test Control Panel"]
                       [width 800]
                       [height 600]))

; Root layout: content (tabs) + REPL + status bar
(define root-panel (new vertical-panel% [parent main-frame]
                        [stretchable-width #t]
                        [stretchable-height #t]))

; Create a horizontal panel for side tabs
(define main-panel (new horizontal-panel% [parent root-panel]))

; Create a vertical panel for tab buttons on the left
(define tab-buttons-panel (new vertical-panel% 
                               [parent main-panel]
                               [style '(border)]
                               [min-width 60]
                               [stretchable-width #f]
                               [stretchable-height #f]
                               [alignment '(center top)]
                               [spacing 2]))

; Create a panel for content on the right
(define content-panel (new panel% [parent main-panel] [stretchable-width #t] [stretchable-height #t]))

; Tab button variables
(define test-runner-tab-btn #f)
(define config-tab-btn #f)
(define results-tab-btn #f)
(define help-tab-btn #f)

; Function to show a specific tab
(define (show-tab tab-name)
  ; Hide all panels
  (send test-runner-panel show #f)
  (send config-panel show #f)
  (send results-panel show #f)
  (send help-panel show #f)
  
  ; Show the selected panel
  (cond
    [(string=? tab-name "Power Source") (send test-runner-panel show #t)]
    [(string=? tab-name "DMM")         (send config-panel show #t)]
    [(string=? tab-name "Router")      (send results-panel show #t)]
    [(string=? tab-name "Tests")       (send help-panel show #t)])
  
  ; Update button styles - highlight active tab with different background
  (send test-runner-tab-btn set-label (if (equal? tab-name "Power Source") "⚡" "⚡"))
  (send config-tab-btn set-label (if (equal? tab-name "DMM") "⚙️" "⚙️"))
  (send results-tab-btn set-label (if (equal? tab-name "Router") "🔗" "🔗"))
  (send help-tab-btn set-label (if (equal? tab-name "Tests") "✅" "✅")))

; Create content for the Test Runner tab
(define test-runner-panel (new panel% [parent content-panel]))
(define test-runner-msg (new message% 
                             [parent test-runner-panel]
                             [label "Power Source Panel"]))
(define run-test-btn (new button% 
                          [parent test-runner-panel]
                          [label "Run Current Test"]
                          [callback (lambda (button event)
                                      (displayln "Running current test..."))]))
(define run-all-btn (new button% 
                         [parent test-runner-panel]
                         [label "Run All Tests"]
                         [callback (lambda (button event)
                                     (displayln "Running all tests..."))]))

; Create content for the Configuration tab
(define config-panel (new panel% [parent content-panel]))
(define config-msg (new message% 
                        [parent config-panel]
                        [label "DMM Panel"]))
(define config-list (new list-box% 
                         [parent config-panel]
                         [label "Test Configuration"]
                         [choices (list "Power Supply Settings" 
                                       "Connection Settings" 
                                       "Matrix Settings" 
                                       "DMM Settings")]
                         [callback (lambda (list-box event)
                                     (let ([selection (send list-box get-selection)])
                                       (when selection
                                         (displayln (format "Selected config: ~s" selection)))))]))

; Create content for the Results tab
(define results-panel (new panel% [parent content-panel]))
(define results-msg (new message% 
                         [parent results-panel]
                         [label "Router Panel"]))
(define results-text (new text-field% 
                          [parent results-panel]
                          [label "Results Output"]
                          [style '(multiple)]
                          [min-height 200]
                          [init-value "Test results will appear here..."]))

; Create content for the Help tab
(define help-panel (new panel% [parent content-panel]))
(define help-msg (new message% 
                      [parent help-panel]
                      [label "Tests Panel"]))
(define help-text (new canvas-list%
       [parent help-panel]
       [items (range 1000)]
       [item-height 100]
       [action-callback (λ (canvas item event)
                          (displayln item))]))

; Create grouped icon buttons with labels underneath (compact)
; Power Source group
(define power-group (new vertical-panel% [parent tab-buttons-panel]
                         [alignment '(center center)]
                         [stretchable-width #f]
                         [spacing 0]))
(set! test-runner-tab-btn (new button% 
                               [parent power-group]
                               [label "⚡"]
                               [min-width 40]
                               [min-height 40]
                               [callback (lambda (button event) (show-tab "Power Source"))]))
(define power-label (new message% [parent power-group] [label "Power Source"]))

; DMM group
(define dmm-group (new vertical-panel% [parent tab-buttons-panel]
                       [alignment '(center center)]
                       [stretchable-width #f]
                       [spacing 0]))
(set! config-tab-btn (new button% 
                           [parent dmm-group]
                           [label "⚙️"]
                           [min-width 40]
                           [min-height 40]
                           [callback (lambda (button event) (show-tab "DMM"))]))
(define dmm-label (new message% [parent dmm-group] [label "DMM"]))

; Router group
(define router-group (new vertical-panel% [parent tab-buttons-panel]
                          [alignment '(center center)]
                          [stretchable-width #f]
                          [spacing 0]))
(set! results-tab-btn (new button% 
                           [parent router-group]
                           [label "🔗"]
                           [min-width 40]
                           [min-height 40]
                           [callback (lambda (button event) (show-tab "Router"))]))
(define router-label (new message% [parent router-group] [label "Router"]))

; Tests group
(define tests-group (new vertical-panel% [parent tab-buttons-panel]
                         [alignment '(center center)]
                         [stretchable-width #f]
                         [spacing 0]))
(set! help-tab-btn (new button% 
                         [parent tests-group]
                         [label "✅"]
                         [min-width 40]
                         [min-height 40]
                         [callback (lambda (button event) (show-tab "Tests"))]))
(define tests-label (new message% [parent tests-group] [label "Tests"]))

; Small font for labels under buttons (disabled to avoid font constructor issues)

; Tooltips are not set (the current Racket version doesn't support help-string for button%)

; Show the first tab by default
(show-tab "Power Source")

; --------------------
; Bottom REPL (visible on all tabs)
; --------------------

; REPL container at bottom
(define repl-group (new group-box-panel% [parent root-panel]
                        [label "REPL"]
                        [stretchable-width #t]
                        [stretchable-height #f]))

; Output area
(define repl-output-text (new text%))
(define repl-output (new editor-canvas% [parent repl-group]
                         [editor repl-output-text]
                         [style '(auto-vscroll auto-hscroll)]
                         [min-height 120]
                         [stretchable-width #t]
                         [stretchable-height #f]))

; Input row
(define repl-input-row (new horizontal-panel% [parent repl-group]
                            [stretchable-width #t]
                            [stretchable-height #f]))
(new message% [parent repl-input-row] [label "> "])
(define repl-input (new text-field% [parent repl-input-row]
                        [init-value ""]
                        [label ""]
                        [style '(single)]
                        [stretchable-width #t]
                        [callback (lambda (_field event)
                                    (when (eq? (send event get-event-type) 'text-field-enter)
                                      (repl-submit!)))]))

; Simple evaluator in a separate namespace
(define repl-ns (make-base-namespace))
(define (repl-append s)
  (send repl-output-text insert (string-append s "\n")))

(define (repl-eval-one expr-str)
  (with-handlers ([exn:fail? (lambda (e)
                                (repl-append (string-append "Error: " (exn-message e)))
                                #f)])
    (parameterize ([current-namespace repl-ns])
      (define in (open-input-string expr-str))
      (define stx (read-syntax 'repl in))
      (cond
        [(eof-object? stx) #f]
        [else (eval stx)]))))

(define (repl-submit!)
  (define cmd (string-trim (send repl-input get-value)))
  (when (positive? (string-length cmd))
    (repl-append (string-append "> " cmd))
    (send repl-input set-value "")
    (let ([v (repl-eval-one cmd)])
      (when (not (eq? v #f))
        (repl-append (format "~s" v))))))

; Submit on Enter handled via the text-field% callback above

; Create a status bar at the bottom
(define status-bar (new message% 
                        [parent root-panel]
                        [label "Ready"]))

; Create a menu bar
(define menu-bar (new menu-bar% [parent main-frame]))

; File menu
(define file-menu (new menu% [parent menu-bar] [label "File"]))
(void (new menu-item% [parent file-menu] 
                      [label "Open Test File..."]
                      [callback (lambda (item event) (displayln "Open file..."))]))
(void (new menu-item% [parent file-menu] 
                      [label "Save Results..."]
                      [callback (lambda (item event) (displayln "Save results..."))]))
(void (new separator-menu-item% [parent file-menu]))
(void (new menu-item% [parent file-menu] 
                      [label "Exit"]
                      [callback (lambda (item event) (send main-frame show #f))]))

; Test menu
(define test-menu (new menu% [parent menu-bar] [label "Test"]))
(void (new menu-item% [parent test-menu] 
                      [label "Run Current Test"]
                      [callback (lambda (item event) (displayln "Running current test..."))]))
(void (new menu-item% [parent test-menu] 
                      [label "Run All Tests"]
                      [callback (lambda (item event) (displayln "Running all tests..."))]))

; Help menu
(define help-menu (new menu% [parent menu-bar] [label "Help"]))
(void (new menu-item% [parent help-menu] 
                      [label "About"]
                      [callback (lambda (item event) 
                                 (message-box "About" 
                                             "Test Control Panel v1.0\n\nA GUI interface for managing test execution." 
                                             main-frame 
                                             '(ok)))]))
(void (new menu-item% [parent help-menu] 
                      [label "Documentation"]
                      [callback (lambda (item event) (displayln "Show documentation..."))]))

; Function to show the window
(define (show-tab-window)
  (send main-frame show #t))

; Function to update status
(define (update-status message)
  (send status-bar set-label message))

; Function to add test result
(define (add-test-result result-text)
  (send results-text set-value (string-append (send results-text get-value) "\n" result-text)))

; Export functions for external use
(provide show-tab-window update-status add-test-result)

; ; Show the window when the file is run directly
; (when (eq? (current-command-line-arguments) #())
;   (show-tab-window))



 (show-tab-window)