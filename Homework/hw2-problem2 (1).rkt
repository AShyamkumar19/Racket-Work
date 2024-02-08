;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |hw2-problem2 (1)|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Problem 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Let's return to Wordle (https://www.nytimes.com/games/wordle/)!

; Eventually we'll want to visualize a prior guess, which means categorizing
; each letter as either correct (i.e., used letter in the correct spot),
; misplaced (i.e., used letter, but in the wrong spot), or wrong (i.e.,
; the letter is not in the word in any spot).

; TODO 1/2: Design the data type LetterStatus (LS), which represents the three
;           categories of letters described above. Make sure to follow all steps
;           of the design recipe for data!

; LetterStatus can either correct, misplaced, or wrong
; Interpretation LetterStatus is a type of guess
(define ls-correct "correct")
(define ls-misplaced "misplaced")
(define ls-wrong "wrong")

(define (ls-temp ls)
   (cond
     [(string=? ls ls-correct) ...]
     [(string=? ls ls-misplaced) ...]
     [(string=? ls ls-wrong) ...]))

; TODO 2/2: Design the function ls->color, which accepts a LetterStatus and
;           produces an associated Color (an existing type - look up the
;           image-color? function for details and examples). In the NYT game,
;           correct letters are green, misplaced letters are yellow, and wrong
;           letters are gray - feel free to choose the shades of these colors
;           that bring you happiness :) And make sure to follow all steps of
;           the design recipe for functions!

; ls->color is a function that takes in a letter and produces a color based on the 3 options
; Interpretation: it will tell you the result of the guess(whether it's right, wrong, or misplaced)

(check-expect (ls->color "correct") "green")
(check-expect (ls->color "misplaced") "yellow")
(check-expect (ls->color "wrong") "gray")

(define (ls->color LetterStatus) 
  (cond
     [(string=? LetterStatus ls-correct) "green"] 
     [(string=? LetterStatus ls-misplaced) "yellow"]
     [(string=? LetterStatus ls-wrong) "gray"])) 






