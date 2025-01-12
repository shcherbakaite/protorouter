 #lang racket/gui

; ROADMAP
; 1. Draw configurable protomatrix
; 2. Detect mouse events on pads
; 3. Create, delete, edit and visualize connections
; 4. Route connections with matrix and visualize nets
; 5. Save results to file

(require ffi/vector
         opengl
         racket/class
         racket/gui/base
         "vec.rkt")


(require "drawing.rkt")

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

(define (repeat x y dx dy countx county operator)
  (for ([i countx])
    (for ([j county])
      (operator i j (+ x (* i dx)) (+ y (* j dy)) dx dy))))
      



(define protomatrix%
  (class object%
    (super-new)
    
    (define position-x -4.0)
    (define position-y 0)
    (define breadboard-hole-diameter (fromMM 1.2))
    ; Pitch of main prototyping area in both directions, also used for matrix X-direction pitch
    (define breadboard-pitch (fromIN 0.1))
    ; The vertical gap between two breadboard prototyping areas
    (define breadboard-gap (fromIN 0.3))
    ; Horizontal size of the breadboard and the matrix
    (define x-size 200)
    ; Vertical size of each column of the matrix
    (define breadboard-column-size 5)
    ; Vertical dimension of the matrix
    (define matrix-y-size 30)
    ; Vertical space between matrix area and prototyping area
    (define matrix-to-breadboard-v-space (fromIN 0.1))
    ; Number of matrix rows after which an additional vertical space is added
    (define matrix-break-every 10)
    ; Additional break size
    (define matrix-break-size (fromIN 0.030))

    (define style-line-width 1.0)
    (define style-line-color (vec3 1.0 0.7804 0.0))
    
    (define/public (draw-breadboard-area)
      ;repeat(self.position[0], self.position[1], self.proto_pitch, self.proto_pitch, self.proto_area[0], self.proto_area[1], pad_operator)
      (define (draw-pad i j x y dx dy)
        (gl-draw-circle (vec2 x y) breadboard-hole-diameter style-line-color style-line-width #f)
        )

      (repeat position-x position-y breadboard-pitch breadboard-pitch x-size breadboard-column-size draw-pad)

      
      )
    


    

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


(define opengl-canvas
  (class canvas%
    (inherit with-gl-context swap-gl-buffers)

    (define gl-config (new gl-config%))
    (send gl-config set-legacy? #t)
    (super-new [style '(gl no-autoclear)]
               [gl-config gl-config])

    (define/override (on-size width height)
      (let-values ([(client-width client-height) (send this get-scaled-client-size)])
      (define aspect (/ client-width client-height))
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

         (gl-draw-line (vec2 0.0 0.0) (vec2 -100.0 0.0) (vec3 0.0 1.0 0.0) 2.0)
   
         (gl-draw-circle (vec2 0.0 0.0) 1.0 (vec3 0.0 1.0 1.0) 5.0 #f)
       
         (send protomatrix draw-breadboard-area)
         (swap-gl-buffers))))))

; Make a canvas that handles events in the frame
(new my-canvas% [parent frame])

; Show the frame by calling its show method
(send frame show #t)




(define (show-frame label triangle-canvas%)
  (define frame (new frame% [label label] [width 3840] [height 600]))
  ; Make a button in the frame
  (new triangle-canvas% [parent frame])
  (send frame show #t))

(show-frame "Fixed-Function" opengl-canvas)