;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname lecture_9.12) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

(define SKY-WIDTH 300)
(define SKY-HEIGHT 200)
(define RADIUS 25)

(define SUN (circle RADIUS "solid" "yellow"))
(define MOON (circle RADIUS "solid" "gray"))
(define SKY (rectangle SKY-WIDTH SKY-HEIGHT "solid" "light blue"))
(define DARKSKY (rectangle SKY-WIDTH SKY-HEIGHT "solid" "dark blue"))
(define DIMSKY (rectangle SKY-WIDTH SKY-HEIGHT "solid" "blue"))
 

; draw-eclipse: Number -> Image
; visualize a moon at a position in the sky with the sun

(define (draw-eclipse moon-x)
  (place-image
   MOON
   moon-x (/ SKY-HEIGHT 2)
   (overlay SUN
            (cond
              [(= moon-x (/ SKY-WIDTH 2)) DARKSKY]
              [(< (abs (- moon-x (/ SKY-WIDTH 2))) (* 2 RADIUS)) DIMSKY]
              [else SKY]))))


;or


            ;(if (= moon-x (/ SKY-WIDTH 2))
             ;   DARKSKY SKY))))
(animate draw-eclipse)
   