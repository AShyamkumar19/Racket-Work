;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname lab1-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Problem 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; For any word of at least one character that starts with a letter,
; let’s say that its "bingo word" is the uppercase version of the
; first letter, followed by a space, and then followed by the number
; of characters in the word. For example, the bingo word of "bingo"
; is "B 5" and the bingo word of "Win" is "W 3".

; TODO 1/1: Define a function, bingo-word, that takes a string as an argument
;           and returns its bingo word. You may assume that the argument is a
;           valid word as described above.
;
;           Don't forget to include a signature and reasonable purpose statement!!
;
;           Hint: if you don't remember ALL the string functions in BSL, that's
;           ok!! :) Remember that you can right-click on a function and search
;           the Help Desk - as a start, string-append will be quite handy...
;           and now you just need some help with isolating substrings,
;           converting strings to upper case, getting the length of a string, and
;           converting a number to a string. Good luck!!

;bing-word: String -> String
; Takes the first letter the word and appends the length to it

; oyutputs the bingo-word of the inputted string

; (not expected/required)
#|(check-expect (bingo-word "bingo") "B 5")
(check-expect (bingo-word "Win") "W 3")

(define BINGO-WORD "bingo")
(define (bingo-word bw)
  (string-append (string-upcase (substring bw 0 1)) "" (number->string (string-length bw))))
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Problem 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Let's make a pretty animated scene with a house, in parts!

; TODO 1/4: Use the triangle, square, rectangle, above, and overlay/align
;           functions to define a constant HOUSE that is the image of a
;           house with a roof and door (and circle if you’re feeling bold
;           enough for a door handle). Be creative :)


(define roof(isosceles-triangle 70 110 "solid" "brown"))
(define body(square 100 "solid" "red"))
(define door(rectangle 30 50 "solid" "brown"))
(define h1(overlay/offset door 0 -45 (overlay/offset roof 0 70 body)))


; TODO 2/4: Define a constant WINDOW, as the image of a window, and place
;           two of them on your HOME, defining HOUSE-WITH-WINDOWS.
;           Note how in using a constant we only have to draw it once and
;           get to use it twice!
(define window1(square 20 "outline" "blue"))
(define window2(square 20 "outline" "blue"))
(define h2(overlay/offset window2 -30 0 (overlay/offset window1 30 0 h1)))


; The next step is a bit tricky, and will require you to understand a bit
; about how colors are represented in DrRacket (and other languages!).

; Colors in DrRacket can either defined via a name (like "blue" and "red"),
; or by numbers, representing the amount of red, green, and blue (each a
; number from 0-255) using the color function...

; (color red-val green-val blue-val)

; For example, a bright red square could be created as either of the following...

; (square 100 "solid" (color 255 0 0))
; (square 100 "solid" "red")

; Now consider the following function, which uses a mathematical formula to
; produce a range of blues...

; SIGNATURE HERE sky-colorr: real --> image 
(define (sky-color t)
  (color 0 0 (abs (- (remainder t 510) 255))))
 
    


; This function always uses 0's for red and green, but differs in the amount
; of blue. If it helps, here is an infix representation of the equation...

; |(t remainder 510) - 255|

; and here is a visual depiction of how the amount of blue changes as a function
; of the value of t: https://www.desmos.com/calculator/ntq43wwjpg

; As you can see, the amount of blue moves linearly up and down between 0 and 255.

; TODO 3/4: Replace "SIGNATURE HERE" above with a signature for this function.
;           Note: ordinarily we'd also have a purpose statement... but that's
;           kinda what this whole set of comments was about ;)


; TODO 4/4: Now finally we are ready to put it all together :)
;           The goal is that when you uncomment the final line below, you will see
;           a movie of your house, with the sky getting darker and then lighter
;           behind it. SO, define a function scene that uses your HOUSE-WITH-WINDOWS
;           constant, as well as the sky-color function, to visualize a single
;           frame of the movie, where the frame number determines the sky color,
;           and so...
;
; (scene 0)
;
;           should have your house in front of a bright blue background, whereas...
;
; (scene 255)
;           
;           should have your house in front of a black background (night!).

; scene : Nat -> Image
; visualizes a house where the supplied number determines
; the amount of blue in the sky behind the house


(define (scene s)
  (overlay h2 (rectangle 500 500 "solid"(sky-color s))))


(animate scene)
