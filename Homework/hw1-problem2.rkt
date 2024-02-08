;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname hw1-problem2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Problem 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Throughout this semester we'll be working on problems related to the game
; Wordle. If you haven't played before, visit the official NYT site to read the
; rules and play for free: https://www.nytimes.com/games/wordle/

; And if you want to practice, there are many unofficial sites that let you
; play more than one game per day (e.g., https://wordplay.com/new).

; For now, your task is to practice with DrRacket drawing functions to design
; a function for visualizing a single letter within a box. You'll notice that
; in various contexts, the size of the box, the color of the letter, as well
; as the outline/fill color of the box differ, but instead of writing a
; separate function for each of these situations (each having VERY similar code),
; these differences should all be supplied as arguments to a single function.

; TODO 1/1: Define the function boxed-letter that could reasonably handle all
;           of the following situations (and more!)...
;           - no guess yet: empty-looking black box with a grey border
;             (boxed-letter 40 " " "black" "black" "dimgray")
;           - in-progress guessed: white letter on a black box with a grey border
;             (boxed-letter 40 "A" "white" "black" "dimgray")
;           - correct: white letter on a green box with a green border
;             (boxed-letter 40 "B" "white" "darkgreen" "darkgreen")
;           - misplaced: white letter on a yellow box with a yellow border
;             (boxed-letter 40 "C" "white" "goldenrod" "goldenrod")
;           - unused: white letter on a grey box with a grey border
;             (boxed-letter 40 "D" "white" "dimgray" "dimgray")
;           - keyboard unguessed: white letter on a small, light grey box
;             with a light grey border
;             (boxed-letter 30 "E" "white" "gray" "gray")
;           - keyboard instructions: offwhite letter on a small, grey box
;             with a grey border
;             (boxed-letter 30 "F" "gray" "dimgray" "dimgray")
;           - demo logo: black letter on a big white box with a black border
;             (boxed-letter 50 "G" "black" "white" "black")
;             public static void boxed-letter(int num, char letter, string c1, string c2, string c3)
;
;           Notes:
;           - Make sure to have a signature and purpose statement for your function,
;             noting that in this class, the data type of a single character is termed
;             a 1String
;           - An easy way to have a shape's outline and fill colors be different
;             is to overlay the outline image on top of the fill
;           - There is no single correct answer here - have fun and be creative :)


; Statement: boxed-letter: real string color color color
; Purpose: when boxed-letter is declared with its respective inputs, it will display a single
; colored character on a colored square border which is on a colored square box
(define (boxed-letter boxnum letter letcol boxcol borcol)
  (overlay (text letter 30 letcol)
           (square boxnum "outline" borcol)
           (square boxnum "solid" boxcol)))

(boxed-letter 40 " " "black" "black" "dimgray")
(boxed-letter 40 "A" "white" "black" "dimgray")
(boxed-letter 40 "B" "white" "darkgreen" "darkgreen")
(boxed-letter 40 "C" "white" "goldenrod" "goldenrod")
(boxed-letter 40 "D" "white" "dimgray" "dimgray")
(boxed-letter 30 "E" "white" "gray" "gray")
(boxed-letter 50 "F" "gray" "dimgray" "dimgray")
(boxed-letter 50 "G" "black" "white" "black")



; (overlay (text "A" 30 "white")
; (square 40 "outline" "grey")
; (square 40 "solid" "black"))
