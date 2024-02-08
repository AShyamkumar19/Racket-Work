;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |Practice Exam Problem 1|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Problem 6
;;
;; *This is a programming problem that you should do in DrRacket.*
;;
;; Consider the following data definition that represents the available letters
;; in a simplified game of Spelling Bee (identical to the project you've worked
;; on before).

(define-struct letters [center left right top bottom])
;; A Letters is a (make-letter 1String 1String 1String 1String 1String)
;; Interpretation: the letters available in a game of Spelling Bee:
;; - center: the letter at the center that must be used
;; - left, right, top, bottom: the four other letters

(define LETTERS-1 (make-letters "a" "b" "c" "d" "e"))
(define LETTERS-2 (make-letters "q" "b" "c" "d" "e"))
(define LETTERS-3 (make-letters "a" "b" "u" "d" "e"))
(define LETTERS-4 (make-letters "a" "q" "u" "d" "e"))

(define (letters-template l)
  (... (letters-center l) ...
       (letters-left l) ...
       (letters-right l) ...
       (letters-top l) ...
       (letters-bottom l) ...))

;; The letter "Q" is typically followed by the letter "U". So, it would be
;; very unfortunate if the available letters had a "Q" and *not* a "U".
;; Design a function that produces #false when a Letters has a "Q" but
;; omits a "U".

;; Ensure you follow the complete function design recipe, including for any
;; appropriate helper functions you may choose to write.

;; [TODO] Function design

; letter-has-usable-q? : letters -> boolean
; Purpose: determines if the letters have both a q and a u

(check-expect (letter-has-usable-q? LETTERS-1) #true)
(check-expect (letter-has-usable-q? LETTERS-2) #false)
(check-expect (letter-has-usable-q? LETTERS-3) #true)
(check-expect (letter-has-usable-q? LETTERS-4) #true)

(define (letter-has-usable-q? l)
  (or (not (letter-has-q? l))
      (letter-has-u? l)))

; letter-has-q? : letters -> boolean
; determines if the letters contain a "q"

(check-expect (letter-has-q? LETTERS-1) #false)
(check-expect (letter-has-q? LETTERS-2) #true)
(check-expect (letter-has-q? LETTERS-3) #false)
(check-expect (letter-has-q? LETTERS-4) #true)


(define (letter-has-q? l)
  (or (string=? (letters-center l) "q")
      (string=? (letters-left l) "q")
      (string=? (letters-right l) "q")
      (string=? (letters-top l) "q")
      (string=? (letters-bottom l) "q")))



; letter-has-u? : letters -> boolean
; determines if the letters contain a "u"

(check-expect (letter-has-u? LETTERS-1) #false)
(check-expect (letter-has-u? LETTERS-2) #false)
(check-expect (letter-has-u? LETTERS-3) #true)
(check-expect (letter-has-u? LETTERS-4) #true)


(define (letter-has-u? l)
  (or (string=? (letters-center l) "u")
      (string=? (letters-left l) "u")
      (string=? (letters-right l) "u")
      (string=? (letters-top l) "u")
      (string=? (letters-bottom l) "u")))

