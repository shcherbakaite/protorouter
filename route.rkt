 #lang racket/gui

; ROADMAP
; 1. Draw configurable protomatrix
; 2. Detect mouse events on pads
; 3. Create, delete, edit and visualize connections
; 4. Route connections with matrix and visualize nets
; 5. Save results to file

(require ffi/vector
         opengl
         racket/flonum
         strokefont
         "connections.rkt"
         "targetnames.rkt"
         "jumpers.rkt"
         racket/class
         racket/gui/base
         data/pvector
         data/collection
         math/matrix
         "vec.rkt")




(require "drawing.rkt")

(define (draw-strokes strokes color width)
  (glLineWidth width)
  (glColor3f (vec-r color) (vec-g color) (vec-b color))
  (for ([stroke strokes])
  (glBegin GL_LINE_STRIP)
    (for ([p stroke])
      (glVertex2f (real->double-flonum (car p)) (real->double-flonum (* -1.0(cdr p)))))
  (glEnd)))

; Make a frame by instantiating the frame% class
(define frame (new frame% [label "Example"]))

; Make a static text message in the frame
(define msg (new message% [parent frame]
                          [label "No events so far..."]))

; Make a button in the frame
(new button% [parent frame]
             [label "Click Me"]
             ; Callback procedure for a button click:
             [callback (lambda (button event)
                         (send msg set-label "Button click"))])

; Derive a new canvas (a drawing window) class to handle events
(define my-canvas%
  (class canvas% ; The base class is canvas%
    ; Define overriding method to handle mouse events
    (define/override (on-event event)
      (send msg set-label "Canvas mouse"))
    ; Define overriding method to handle keyboard events
    (define/override (on-char event)
      (send msg set-label "Canvas keyboard"))
    ; Call the superclass init, passing on all init args
    (super-new)))

(define ppin 0.4)

(define ppmm (* ppin 0.03937) )



(define (fromMM x)
  (* x ppmm))


(define (fromIN x)
  (* x ppin))

(define (gradient-negate-dy gradient-function)
  (lambda (x y)
    (let ([dxdy (gradient-function x y)])
      (vec2 (vec-x dxdy) (- (vec-y dxdy))))))

(define (repeat position dx dy countx county operator)
  (for ([i countx])
    (for ([j county])
      (operator i j (+ (vec-x position) (* i dx)) (+ (vec-y position) (* j dy)) dx dy))))
      
(define (repeat-with-gradient offset gradient-function count-x count-y operator)
  (define current-offset (vec2 offset)) ; current operator position
  (define dxdy (gradient-function 0 0))

  (for ([i count-x])
    (vec-y! current-offset (vec-y offset))
    (for ([j count-y])
      (vec-y! dxdy (vec-y (gradient-function 0 j)))
      (operator i j current-offset gradient-function)
      (vec-y+! current-offset (vec-y dxdy))) ; advance y position by dy

    (vec-x! dxdy (vec-x (gradient-function i 0))) ; update gradient
    (vec-x+! current-offset (vec-x dxdy)))) ; advance x position by dx

(define location%
  (class object%
    (super-new)
    (init [x #f] [y #f]) 
    (define location-x x)
    (define location-y y)

    (define/public (get-values)
      (values location-x location-y))))

(define pad%
  (class object%
    (super-new)
    (init init-position init-location init-size)
    (define position init-position) ; physical position
    (define location init-location) ; logical position
    (define size init-size) ; physical size

    (define/public (get-position)
      position)

    (define/public (set-position p0)
      (set! position p0))

    (define/public (set-location l0)
      (set! location l0))

    (define/public (get-location)
      location)

    (define/public (get-size)
      size)

    (define/public (set-size s0)
      (set! size s0))
    
    (define/public (draw)
      (void))

    (define/public (hit-test p0)
      (let ([d (vec-len (vec- position p0))])
        (< d (/ size 2))))

    ))

(define breadboard-jumper
  (class object%
    (define/public (draw)
      (void))))

(define breadboard-pad%
  (class pad%
    (define breadboard-hole-diameter (fromMM 1.2))
    (init init-position init-location)
    (super-new [init-position init-position] [init-location init-location] [init-size breadboard-hole-diameter])
    (define color (vec3 1.0 0.7804 0.0))
    
    (define line-width 1.0)

    (define/override (draw)
       (gl-draw-circle (send this get-position) (send this get-size) color line-width #f))

    ))
    
(define matrix-pad%
  (class pad%
    (define matrix-pad-diameter (fromMM 0.7))
    (init init-position init-location)
    (super-new [init-position init-position] [init-location init-location] [init-size matrix-pad-diameter])
    (define color (vec3 1.0 0.7804 0.0))
    
    (define line-width 1.0)

    (define/override (draw)
       (gl-draw-point (send this get-position) 5.0 color))

    ))

;(define (neg_dy_gradient gradient)
  
  
  
;(operator i j current-x current-y gradient-function)

; Application state
(define application%
  (class object%
    (super-new)))

(define protomatrix%
  (class object%
    (super-new)
    ; Breadboard position
    (define position  (vec2 0))
    (define breadboard-hole-diameter (fromMM 1.2))
    ; Pitch of main prototyping area in both directions, also used for matrix X-direction pitch
    (define breadboard-pitch (fromIN 0.1))
    ; The vertical gap between two breadboard prototyping areas
    (define breadboard-gap (fromIN 0.3))
    ; Horizontal size of the breadboard and the matrix
    (define x-size 80)
    ; Vertical size of each column of the matrix
    (define breadboard-column-size 5)
    ; Vertical dimension of the matrix
    (define matrix-y-size 30)
    ; Vertical space between matrix area and prototyping area
    (define matrix-to-breadboard-y-gap (fromIN 0.3))
    ; Matrix vertical pitch
    (define matrix-y-pitch (fromIN 0.045))
    ; Number of matrix rows after which an additional vertical space is added
    (define matrix-break-every 10)
    ; Additional break size
    (define matrix-break-size (fromIN 0.010))

    (define style-line-width 1.0)
    (define style-line-color (vec3 1.0 0.7804 0.0))

    (define pads (pvector))

    (define/private (build-breadboard-area)
       ;repeat(self.position[0], self.position[1], self.proto_pitch, self.proto_pitch, self.proto_area[0], self.proto_area[1], pad_operator)
      (define (draw-pad i j x y dx dy)
        (let ([new-pad (new breadboard-pad% [init-position (vec2 x y)] [init-location (new location% [x 0.0] [y 0.0])])])
          (set! pads (conj pads new-pad))))
        

      (repeat position breadboard-pitch breadboard-pitch x-size breadboard-column-size draw-pad)
      (let ([new-position (vec2 (vec-x position) (- (vec-y position) breadboard-gap)) ])
        (repeat new-position breadboard-pitch (- breadboard-pitch) x-size breadboard-column-size draw-pad)))

    ; Relative position of lower matrix area
    (define/private (get-lower-matrix-offset)
      (vec2 0.0 (* breadboard-column-size breadboard-pitch)))

    ; Relative position of lower matrix area
    (define/private (get-upper-matrix-offset)
      (vec2 0.0 (+ (- (* breadboard-column-size breadboard-pitch)) (- matrix-to-breadboard-y-gap)) ) )

    ; Create pads
    (build-breadboard-area)

    (define/public (set-position p)
      (set! position p))

    (define/public (draw)
      (for-each (lambda (pad)
                  (send pad draw))
                pads))
    
    ; (define/public (draw-breadboard-area)
    ;   ;repeat(self.position[0], self.position[1], self.proto_pitch, self.proto_pitch, self.proto_area[0], self.proto_area[1], pad_operator)
    ;   (define (draw-pad i j x y dx dy)
    ;     (new breadboard-pad% [init-position (vec2 x y)] [init-location (new location% [x 0.0] [y 0.0])] [init-size 0.0])
    ;     (gl-draw-circle (vec2 x y) breadboard-hole-diameter style-line-color style-line-width #f))

    ;   (repeat position breadboard-pitch breadboard-pitch x-size breadboard-column-size draw-pad)
    ;   (let ([new-position (vec2 (vec-x position) (- (vec-y position) breadboard-gap)) ])
    ;     (repeat new-position breadboard-pitch (- breadboard-pitch) x-size breadboard-column-size draw-pad)))
   
    ; Function that defines spacing of matrix pads
    (define/public (get-matrix-gradient-function)
      (lambda (i j)
        (define matrix-y-modified-pitch
          (if (and (= (remainder j matrix-break-every) 0) (not (= j 0)))
              (+ matrix-y-pitch matrix-break-size)
              matrix-y-pitch))

        (vec2 breadboard-pitch matrix-y-modified-pitch)))

;     (define/public (draw-matrix-area)
;       (define (draw-pad i j position _)
;          (let ([new-pad (new matrix-pad% [init-position position] [init-location (new location% [x 0.0] [y 0.0])])])
;           (set! pads (conj pads new-pad))))
        

;       (let* ([new-position (vec+ position (get-lower-matrix-offset))])
;         (repeat-with-gradient new-position (send this get-matrix-gradient-function) x-size matrix-y-size draw-pad))
      
; `()
;       )

     (define/public (build-matrix-area)
      (define (draw-pad i j position _)
         (let ([new-pad (new matrix-pad% [init-position position] [init-location (new location% [x 0.0] [y 0.0])])])
          (set! pads (conj pads new-pad))))

      (let* ([new-position (vec+ position (get-lower-matrix-offset))])
        (repeat-with-gradient new-position (send this get-matrix-gradient-function) x-size matrix-y-size draw-pad))

      (let* ([new-position (vec+ position (get-upper-matrix-offset))])
       (repeat-with-gradient new-position (gradient-negate-dy (send this get-matrix-gradient-function)) x-size matrix-y-size draw-pad))
      
`()
      )

    
    (build-matrix-area)


    
      
    ))

(new canvas% [parent frame]
             [paint-callback
              (lambda (canvas dc)
                (send dc set-scale 1 1)
                (send dc set-text-foreground "blue")
                (send dc draw-text "Don't Panic!" 2500 0))])


(define vertex-data
  (f32vector
   ;; Character 'A'
   0.0  0.0    ; Line from (0.0, 0.0) to (0.5, 1.0)
   0.5  1.0
   0.5  1.0    ; Line from (0.5, 1.0) to (1.0, 0.0)
   1.0  0.0
   0.25 0.5    ; Line for crossbar from (0.25, 0.5) to (0.75, 0.5)
   0.75 0.5))

(define protomatrix (new protomatrix%))




(send protomatrix set-position (vec3 -1.0 0.0 1.0))




(define opengl-canvas
  (class canvas%
    (inherit with-gl-context swap-gl-buffers)

    (define gl-config (new gl-config%))
    (send gl-config set-legacy? #t)
    (super-new [style '(gl no-autoclear)]
               [gl-config gl-config])

    (define is-dragging #f)
    (define drag-origin-x 0.0)
    (define drag-origin-y 0.0)
    (define offset-x 0.0)
    (define offset-y 0.0)
    
    (define mouse-x 0.5)
    (define mouse-y 0.0)
    (define aspect 1.0)
    
    (define/override (on-size width height)
      (let-values ([(client-width client-height) (send this get-scaled-client-size)])
      (set! aspect (/ client-width client-height))
       (with-gl-context
       (λ ()
         (glViewport 0 0 client-width client-height)
         (glMatrixMode GL_PROJECTION)
         (glLoadIdentity)
         (if (<= client-width client-height)
             (glOrtho -1.0 1.0 (/ 1 (- aspect)) (/ 1 aspect) 1.0 -1.0)
             (glOrtho (- aspect) aspect -1.0 1.0 1.0 -1.0))
         (glMatrixMode GL_MODELVIEW)
         (glLoadIdentity)
         ))
     (displayln (format "~s ~s ~s" client-width client-height aspect))))

    ;(define/public (hit-test position)
      
      ;'upper-prototype-area x y
      ;'lower-prototype-area x y
      ;'lower-matrix-area x y
      ;'upper-matrix-area x y

    (define/public (get-canvas-offset-x)
      (if is-dragging
          (+ offset-x (- mouse-x drag-origin-x))
          offset-x))
     

    (define/public (get-canvas-offset-y)
      (if is-dragging
          (+ offset-y (- mouse-y drag-origin-y))
          offset-y))
      
      
    
    (define/override (on-event event)
      (when (is-a? event mouse-event%)

        (with-gl-context
            (λ ()
              (define a (glGetIntegerv GL_VIEWPORT))
              ;(displayln (format "~s ~s ~s ~s" (s32vector-ref a 0) (s32vector-ref a 1) (s32vector-ref a 2) (s32vector-ref a 3)))
         
              (let-values ([(w h) (send this get-client-size)])
                (displayln (format "~s ~s : ~s ~s : ~s, ~s "(send event get-x) (send event get-y) w h (exact->inexact (/ w h)) (exact->inexact aspect)))

                (define a (/ w h))
                (define M 
                  (if (> a 1.0)
                    (matrix [[(* 2 (/ 1 w) a) 0 (- a)]
                                    [0 (* -2 (/ 1 h) ) 1 ]
                                    [0 0 0]])
                    (matrix [[(* 2 (/ 1 w) ) 0 -1]
                                    [0 (* -2 (/ 1 h) (/ 1 a)) (/ 1 a) ]
                                    [0 0 0]])))


                (define mouse-raw (matrix [[(send event get-x)]
                                   [(send event get-y)]
                                   [1]]))

                (define mouse-gl (matrix* M mouse-raw))


                ;(define mouse-raw (vec4 (send event get-x) (send event get-y) 1 1))
                ;(define mouse-opengl (mat*  M mouse-raw))

                (set! mouse-x (matrix-ref mouse-gl 0 0))
                (set! mouse-y (matrix-ref mouse-gl 1 0))

                (displayln (format "~s ~s" (exact->inexact mouse-x) (exact->inexact mouse-y)))
                (send this refresh))
              ))

      (when (and (not is-dragging) (send event button-down? 'middle))
          (set! is-dragging #t)
          (set! drag-origin-x mouse-x)
          (set! drag-origin-y mouse-y)
      )

;      (when is-dragging
;        (set! offset-x (- mouse-x drag-origin-x))
;        (set! offset-y (- mouse-y drag-origin-y)))


      (when (send event button-changed? 'middle)
        (when (and is-dragging (not (send event button-down? 'middle)))
          (set! is-dragging #f)
          (set! offset-x (+ offset-x (- mouse-x drag-origin-x)))
          (set! offset-y (+ offset-y (- mouse-y drag-origin-y)))

          ))

      ))

    (with-gl-context
        (λ ()
          (glNewList 1 GL_COMPILE)

          (draw-strokes  (char->strokes (real->double-flonum 0.01) #\ξ) (vec3 0.75 0.0 0.0) 1.0)
          (send protomatrix draw)

          (glEndList)))
        
    
    (define/override (on-paint)
      (with-gl-context
       (λ ()

         (glMatrixMode GL_MODELVIEW)
         (glLoadIdentity)
         
         (glClearColor 0.0 0.0 0.1 0.0)
         (glClear (bitwise-ior GL_COLOR_BUFFER_BIT GL_DEPTH_BUFFER_BIT))
         
         (glVertexPointer 2 GL_FLOAT 0 (line-geometry #[0.0 0.0] #[0.5 0.1]))
         (glEnableClientState GL_VERTEX_ARRAY)
         (glLineWidth 5.0)
         ;(glDrawArrays GL_LINES 0 6)
         (glDisableClientState GL_VERTEX_ARRAY)


         (gl-draw-circle (vec2  mouse-x  mouse-y) 0.05 (vec3 0.75 0.0 0.0) 5.0 #t)

         (send protomatrix set-position (vec2 (* 0.001 mouse-x) (* mouse-y -0.001)))
         ;(send protomatrix draw-breadboard-area) 
         ;(send protomatrix draw-matrix-area)
         ;(send protomatrix draw)
         (glTranslatef   (get-canvas-offset-x) (get-canvas-offset-y) 0.0)
         (glCallList 1)
         (swap-gl-buffers))))))

; Make a canvas that handles events in the frame
(new my-canvas% [parent frame])



; create jumpers
; jumpers create connections
; connections create nets
; nets colorize jumpers
; nets set crosspoints

; Show the frame by calling its show method
(send frame show #t)

(define (show-frame label triangle-canvas%)
  (define frame (new frame% [label label] [width 1500] [height 1000]))

  ; main menu
  (define main-menu (new menu-bar% [parent frame]))
  (define menu-file (new menu% [label "File"] [parent main-menu]))
  (new menu-item%	[label "Open"] [parent menu-file] 
      [callback  (λ (r e) `())])

  (connect (XA 1) (XB 2))
  (connect (XA 1) (XB 2))


  (define menu-edit (new menu% [label "Edit"] [parent main-menu]))
  (define menu-settings (new menu% [label "Settings"] [parent main-menu]))
  (new menu-item%	[label "Board Size"] [parent menu-settings] 
      [callback  (λ (r e) `())])

  ;(send main-menu enable #t)




  ; Make a button in the frame
  (new triangle-canvas% [parent frame])
  (send frame show #t))

(show-frame "Fixed-Function" opengl-canvas)