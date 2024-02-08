;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname wp-backspace) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

; Design a world program word-processor that renders
; the characters that the user types in black text on
; a yellow background.




























































; word-processor : String -> String
; Runs a simplified word processor
 
(define (word-processor initial-word)
  (big-bang initial-word
    [to-draw draw-word]
    [stop-when done? draw-word]
    [on-key key-wp]))

; draw-word : String -> Image
; Draws the current word

(define BACKGROUND (empty-scene 600 100 "yellow"))
(define WORD-SIZE 20)
(define WORD-COLOR "black")

(check-expect (draw-word "hello")
              (overlay (text "hello" WORD-SIZE WORD-COLOR) BACKGROUND))
 
(check-expect (draw-word "a")
              (overlay (text "a" WORD-SIZE WORD-COLOR) BACKGROUND))
 
(define (draw-word s)
  (overlay (text s WORD-SIZE WORD-COLOR) BACKGROUND))

; done? : String -> Boolean
; is the current word "done"?

(check-expect (done? "done") #true)
(check-expect (done? "progress") #false)

(define (done? s)
  (string=? s "done"))
 
; key-wp : String KeyEvent -> String
; Adds key to the end of s, or removes the last letter if backspace is entered
 
(check-expect (key-wp "e" "") "e")
(check-expect (key-wp "l" "e") "le")
(check-expect (key-wp "le" "\b") "l")
(check-expect (key-wp "" "\b") "")
 
(define (key-wp s key)
  (cond
    [(string=? key "\b") (remove-last s)]
    [else (string-append s key)]))
 
; remove-last : String -> String
; Removes the last letter of the supplied string
 
(check-expect (remove-last "") "")
(check-expect (remove-last "apple") "appl")
 
(define (remove-last s)
  (cond
    [(string=? s "") s]
    [else (substring s 0 (sub1 (string-length s)))]))


(word-processor "")
