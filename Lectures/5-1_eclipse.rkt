;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 5-1_eclipse) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)
 
(define SKY-WIDTH 300)
(define SKY-HEIGHT 200)
(define RADIUS 25)
 
(define SUN (circle RADIUS "solid" "yellow"))
(define MOON (circle RADIUS "solid" "gray"))
(define SKY (rectangle SKY-WIDTH SKY-HEIGHT "solid" "light blue"))
 
; draw-eclipse : Nat -> Image
; Draw the moon at the given x-coordinate, on a scene with the sun

; TODO 0: missing something!?
 
(define (draw-eclipse x-moon)
  (place-image
   MOON
   x-moon (/ SKY-HEIGHT 2)
   (overlay SUN SKY)))

; TODO 1/4: replace with big-bang
; TODO 2/4: make the moon faster
; TODO 3/4: enable restart
; TODO 4/4: stop when off-screen
; (animate draw-eclipse)

(define (move-moon x-moon)
  (+ x-moon 1))


; eclipse: Nat -> Nat
; animates an eclipse



(define (eclipse start-location)
  (big-bang start-location
    [to-draw draw-eclipse]
    [on-tick move-moon]
    [on-key restart-moon]
    [stop-when offscreen? quick]))

(define (quick x-moon)
  (text "the end of the class/week" 50 "black")) 
 
;(big-bang 0
 ; [to-draw draw-eclipse]
  ;[on-tick move-moon])


; move-moon: Nat -> Nat
; move the moon

(check-expect (move-moon 0) 1)
(check-expect (move-moon 14) 15)


 ; restart-moon : Nat KeyEvent -> Nat
; moves the moon back to the start

(check-expect (restart-moon 65 " ") 0)
(check-expect (restart-moon 14 "r") 0)

(define (restart-moon x-moon ke) 
  0)


 ; offscreen? : Nat -> Boolean
; is the supplied number grater than SKY-WIDTH?

(check-expect (offscreen? 5) #f)
(check-expect (offscreen? 500) #t)

(define (offscreen? x-moon)
  (if (> x-moon SKY-WIDTH) #t #f))
