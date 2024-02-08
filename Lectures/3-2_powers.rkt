;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 3-2_powers) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Create the function has-airline-powers? that accepts
; your current miles and returns whether or not you
; receive airline perks (starts at 25k)

; has-airline-powers? : PosReal -> Boolean
; Returns whether or not you're going to get airline perks
; Examples:
; (has-airline-powers? 10000) should be #false
(check-expect (has-airline-powers? 10000) #false)
; (has-airline-powers? 24000) should be #false

(check-expect (has-airline-powers? 24000) #false)
; (has-airline-powers? 95000) should be #true
(check-expect (has-airline-powers? 95000) #false)
; (has-airline-powers? 25000) should be #true
(check-expect (has-airline-powers? 25000) #false)

; v: check-expect
; syn: (check-expect func-call exp-value)

(define (has-airline-powers? miles)
  (> miles 25000))