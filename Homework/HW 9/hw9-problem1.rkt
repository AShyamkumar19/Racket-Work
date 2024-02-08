;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname hw9-problem1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/batch-io)
(require 2htdp/image)
(require 2htdp/universe)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Problem 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; You are now ready to implement Wordle (https://www.nytimes.com/games/wordle/),
; at least most of it ;)

; You've actually done quite a bit this semester already, and so the first step
; is to review some of the definitions you'll use to build your game.

; TODO 0/8: Read the following sections of (annotated) definitions - as needed,
;           go back to the sample solutions & walkthrough videos of the
;           associated assignments in order to make sure you understand each
;           piece of the program we have thus far!


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;
; Data (General)
; --------------
;
; - Pair (NEW)
;   A generalized definition for associating two arbitrary
;   data types; this is used both for LetterStatusPair and
;   in helping to visualize elements of the game by
;   pairing up a game object, such as a guesed letter, with
;   a function used to visualize that type of object
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-struct pair [first second])

; A [Pair X Y] is a (make-pair X Y)
; Interpretation: a pairing of two values


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Data (Letters)
; --------------
;
; - LetterStatus (Homework 2)
;   A categorization of scored letters
;
; - LetterStatusPair (Homework 3)
;   An association between a specific letter and its scored
;   status; updated to use Pair
;
; - VizPair (NEW)
;   An association between a value and a function that can
;   produce an image for it
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; A LetterStatus (LS) is one of:
; - "wrong"
; - "misplaced"
; - "right"
; Interpretation: status of a guessed letter

(define LS-WRONG "wrong")
(define LS-MISPLACED "misplaced")
(define LS-RIGHT "right")


; A LetterStatusPair (LSP) is a [Pair 1String LetterStatus]
; Interpretation: a guess letter and its associated status


; A [VizPair X] is a [Pair X [X -> Image]]
; Interpretation: a pairing of a value with a function that
; produces a vizualization of it


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Constants (Visualization)
; -------------------------
;
; - Game background (BG-COLOR)
;
; - Current/upcoming guess border (BORDER-COLOR)
;
; - Current/upcoming guess background (GUESS-COLOR)
;
; - Letter size (LT-SIZE)
;
; - Buffer space between game objects (GAP)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define BG-COLOR "white")
(define BORDER-COLOR "dimgray")
(define GUESS-COLOR "black")

(define LT-SIZE 64)

(define GAP (square 5 "solid" BG-COLOR))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Functions (General)
; -------------------
;
; - mymap2 (Lab 9)
;   Abstraction for capturing the result of applying a
;   function to the elements from two parallel lists
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; mymap2 : (X Y Z) [List-of X] [List-of Y] [X Y -> Z] -> [List-of Z]
; produces a result list by applying the supplied function
; to parallel elements from the supplied lists (until either
; is empty)

(check-expect
 (mymap2 '() '() *)
 '())

(check-expect
 (mymap2 (list 2 3) (list 4) *)
 (list 8))

(check-expect
 (mymap2 (list "a" "b")
         (list "1" "2" "3")
         string-append)
 (list "a1" "b2"))

(check-expect
 (mymap2 (list "a" "c")
         (list (list "x") (list 3 1 4))
         (λ (s l) (string-append
                   s
                   "-"
                   (number->string (length l)))))
 (list "a-1" "c-3"))

(define (mymap2 l1 l2 f)
  (cond
    [(or (empty? l1) (empty? l2)) '()]
    [(and (cons? l1) (cons? l2)) 
     (cons (f (first l1) (first l2))
           (mymap2 (rest l1) (rest l2) f))]))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Functions (Visualizing Letters)
; -------------------------------
;
; - boxed-letter (Homework 6)
;   Abstraction for drawing a letter over a box; uses an
;   updated test to reflect that a "blank" box for guesses
;   is now local to a helper
;
; - guess-letter->image (Homework 6)
;   Uses boxed-letter to provide a simple way to visualize
;   letters and empty spaces that have yet to be scored;
;   updated to make its background (blank) a local helper
;
; - lsp->image (Homework 6, Lab 8)
;   Uses boxed-letter to provide a simple way to visualize
;   scored letters; updated to (a) make its background a
;   set of local functions and (b) utilize pair data
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; boxed-letter : 1String NonNegReal [NonNegReal -> Image] -> Image
; produces an image of a letter on a background of a particular size

(check-expect
 (boxed-letter "A" 10 (λ (_) empty-image))
 (text "A" 5 BG-COLOR))

(check-expect
 (boxed-letter "B" 64 (λ (s) (overlay (square s "outline" BORDER-COLOR)
                                      (square s "solid" GUESS-COLOR))))
 (overlay
  (text "B" 32 BG-COLOR)
  (square 64 "outline" BORDER-COLOR)
  (square 64 "solid" GUESS-COLOR)))

(define (boxed-letter s size bgf)
  (overlay
   (text s (/ size 2) BG-COLOR)
   (bgf size)))


; guess-letter->image : 1String -> Image
; visualizes a guessed character

(check-expect
 (guess-letter->image "A")
 (overlay
  (text "A" (/ LT-SIZE 2) BG-COLOR)
  (square LT-SIZE "outline" BORDER-COLOR)
  (square LT-SIZE "solid" GUESS-COLOR)))

(check-expect
 (guess-letter->image "B")
 (overlay
  (text "B" (/ LT-SIZE 2) BG-COLOR)
  (square LT-SIZE "outline" BORDER-COLOR)
  (square LT-SIZE "solid" GUESS-COLOR)))

(define (guess-letter->image s)
  (local [; blank : NonNegReal -> Image
          ; produces a blank box of the appropriate size
          (define (blank size)
            (overlay (square size "outline" BORDER-COLOR)
                     (square size "solid" GUESS-COLOR)))]
    (boxed-letter s LT-SIZE blank)))


; lsp->image : LetterStatusPair -> Image
; produces a visualization of a letter with status

(check-expect (lsp->image (make-pair "A" LS-RIGHT))
              (overlay
               (text "A" (/ LT-SIZE 2) BG-COLOR)
               (square LT-SIZE "solid" "darkgreen")))

(check-expect (lsp->image (make-pair "B" LS-WRONG))
              (overlay
               (text "B" (/ LT-SIZE 2) BG-COLOR)
               (square LT-SIZE "solid" "dimgray")))

(check-expect (lsp->image (make-pair "C" LS-MISPLACED))
              (overlay
               (text "C" (/ LT-SIZE 2) BG-COLOR)
               (square LT-SIZE "solid" "goldenrod")))

(define (lsp->image lsp)
  (local [; ls->color : LS -> Color
          ; produces a background color associated with a letter status
          (define (ls->color ls)
            (cond
              [(string=? ls LS-WRONG) "dimgray"]
              [(string=? ls LS-MISPLACED) "goldenrod"]
              [(string=? ls LS-RIGHT) "darkgreen"]))

          ; ls->color-fn : LetterStatus -> [NonNegReal -> Image]
          ; produces a function for a status-specific background
          ; of the appropriate size
          (define (ls->color-fn ls)
            (λ (size) (square size "solid" (ls->color ls))))]
    (boxed-letter
     (pair-first lsp)
     LT-SIZE
     (ls->color-fn (pair-second lsp)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Functions (Visualizing Letters)
; -------------------------------
;
; - stack (Lab 8)
;   Abstraction for separating a set of images using a
;   pairwise orientation function
;
; - stack/v (Homework 7, Lab 8)
;   Uses stack to easily visualize a list of images in
;   a horizontal fashion
; 
; - stack/h (Homework 7, Lab 8)
;   Uses stack to easily visualize a list of images in
;   a horizontal fashion
;
; - row->image (NEW)
;   Uses stack/h to easily visualize a list of objects, each
;   with an associated visualization function (e.g., a list
;   of letters with one of the functions from the preceding
;   section).
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; stack : [List-of Images] [Image Image -> Image] -> Image
; space separates a list of images via a pairwise orientation function

(check-expect
 (stack '() beside)
 GAP)

(check-expect
 (stack '() above)
 GAP)

(check-expect
 (stack
  (list
   (text "A" 5 "black")
   (text "B" 10 "black")
   (text "C" 50 "black"))
  above)
 (above
  GAP
  (text "A" 5 "black")
  GAP
  (text "B" 10 "black")
  GAP
  (text "C" 50 "black")
  GAP))

(check-expect
 (stack
  (list
   (text "A" 5 "black")
   (text "B" 10 "black")
   (text "C" 50 "black"))
  beside)
 (beside
  GAP
  (text "A" 5 "black")
  GAP
  (text "B" 10 "black")
  GAP
  (text "C" 50 "black")
  GAP))

(define (stack images addf)
  (local [; buffer : Image Image -> Image
          ; positions the supplied image
          ; relative to the supplied background
          ; with a gap
          (define (buffer i bg)
            (addf GAP i bg))]
    (foldr
     buffer
     GAP
     images)))


; stack/v : [List-of Images] -> Image
; space-separates a list of images vertically

(check-expect
 (stack/v '())
 GAP)

(check-expect
 (stack/v
  (list
   (text "A" 5 "black")
   (text "B" 10 "black")
   (text "C" 50 "black")))
 (above
  GAP
  (text "A" 5 "black")
  GAP
  (text "B" 10 "black")
  GAP
  (text "C" 50 "black")
  GAP))

(define (stack/v images)
  (stack images above))


; stack/h : [List-of Image] -> Image
; space-separates a list of images horizontally

(check-expect
 (stack/h '())
 GAP)

(check-expect
 (stack/h
  (list
   (text "A" 5 "black")
   (text "B" 10 "black")
   (text "C" 50 "black")))
 (beside
  GAP
  (text "A" 5 "black")
  GAP
  (text "B" 10 "black")
  GAP
  (text "C" 50 "black")
  GAP))

(define (stack/h images)
  (stack images beside))


; row->image : [List-of [VizPair Any]] -> Image
; horizontally visualizes a list of elements, each with an
; associated visualization function

(check-expect
 (row->image '())
 GAP)

(check-expect
 (row->image
  (list
   (make-pair "X" guess-letter->image)
   (make-pair "Y" guess-letter->image)
   (make-pair " " guess-letter->image)))
 (beside
  GAP
  (guess-letter->image "X")
  GAP
  (guess-letter->image "Y")
  GAP
  (guess-letter->image " ")
  GAP))

(check-expect
 (row->image
  (list
   (make-pair (make-pair "A" LS-RIGHT) lsp->image)
   (make-pair (make-pair "B" LS-WRONG) lsp->image)
   (make-pair (make-pair "C" LS-MISPLACED) lsp->image)))
 (beside
  GAP
  (lsp->image (make-pair "A" LS-RIGHT))
  GAP
  (lsp->image (make-pair "B" LS-WRONG))
  GAP
  (lsp->image (make-pair "C" LS-MISPLACED))
  GAP))

(check-expect
 (row->image
  (list
   (make-pair "X" guess-letter->image)
   (make-pair (make-pair "A" LS-RIGHT) lsp->image)))
 (beside
  GAP
  (guess-letter->image "X")
  GAP
  (lsp->image (make-pair "A" LS-RIGHT))
  GAP))

(define (row->image ips)
  (stack/h
   (map
    (λ (ip) ((pair-second ip) (pair-first ip)))
    ips)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Now let's get to work :)


; In Homework 6, you created the following very useful abstraction for
; determining if a value is present in a list...


; value-in-list? : (X) X [List-of X] [X X -> Boolean] -> Boolean
; is the supplied value in the list according to the supplied predicate?

#|
(define (value-in-list? x lox p?)
  (cond
    [(empty? lox) #f]
    [(cons? lox)
     (or (p? x (first lox))
         (value-in-list? x (rest lox) p?))]))
|#


; TODO 1/8: This function should remind you a great deal of one of the ISL list
;           abstractions - so as a warm-up, use that abstraction to rewrite the
;           code above; if you are successful, all the supplied tests will still
;           pass (once uncommented) AND you will have a much better abstraction
;           design to use when wordle'ing. ALSO, you can then make use of
;           common special cases, like string-in-list? (also from Homework 6,
;           supplied below).


; string-in-list? : String [List-of String] -> Boolean
; is the supplied string in the list?

(check-expect (string-in-list? "a" (list)) #f)
(check-expect (string-in-list? "a" (list "a" "b" "c")) #t)
(check-expect (string-in-list? "A" (list "a" "b" "c")) #f)
(check-expect (string-in-list? "b" (list "a" "b" "c")) #t)
(check-expect (string-in-list? "c" (list "a" "b" "c")) #t)
(check-expect (string-in-list? "d" (list "a" "b" "c")) #f) 

(define (string-in-list? s los)
  (value-in-list? s los string=?))

; value-in-list? : (X) X [List-of X] [X X -> Boolean] -> Boolean
; is the supplied value in the list according to the supplied predicate?


(check-expect (value-in-list? 1 (list) =) #f)
(check-expect (value-in-list? "a" (list) string=?) #f)
(check-expect (value-in-list? 1 (list 1 2 3) =) #t)
(check-expect (value-in-list? 5 (list 1 2 3) =) #f)
(check-expect (value-in-list? "a" (list "a" "b" "c") string=?) #t)
(check-expect (value-in-list? "A" (list "a" "b" "c") string-ci=?) #t)

(define (value-in-list? x lox p?)
  (ormap (λ (val) (p? x val)) lox))   



; TODO 2/8: Now, finish designing the function read-dictionary, which reads and
;           capitalizes all the words from a supplied file (assumed to be one
;           word per line). The supplied tests are sufficient for your function
;           and should both pass once complete (which means, please do NOT
;           create a file named "BAD.EVIL" and make sure to have the provided
;           "little.txt" file in the same folder as this code.


; read-dictionary : String -> [List-of String]
; reads the words in a supplied file and capitalizes them all

(define LITTLE-WORDS
  (list "ACT"
        "BAD"
        "CAT"
        "DAB"
        "ETA"))


(check-expect
 (read-dictionary "BAD.EVIL")
 '())

(check-expect
 (read-dictionary "little.txt")
 LITTLE-WORDS)
 
(define (read-dictionary file)
  (if (file-exists? file)
      (map string-upcase (read-lines file))
      '()))
 


 

; TODO 3/8: Your next task is to finish designing the score function, which
;           implements a simplified version of Wordle scoring, wherein each
;           letter of the supplied guess is independently associated with a
;           status in the supplied correct word.
;
;           Notes:
;           - Make sure you read and understand all the supplied tests, which
;             capture how the function is supposed to work. Once your code is
;             complete, all of these tests should pass (and that is sufficient
;             testing for this function).
;           - You are highly encouraged to use mymap2 (see "Functions (General)"
;             section above), as well as string-in-list? (TODO #1).
;           - FYI: this approach is not 100% consistent with the NY Times, which
;             handles repeated letters in a somewhat more complicated fashion
;             (that we'll consider this in a later assignment!).


; score : String String -> [List-of LetterStatusPair]
; Given a guess and the correct string (assumed to be the same length, and both
; uppercase), produce the resulting pairing of each character and its status


(check-expect (score "ABC" "ABC")
              (list (make-pair "A" LS-RIGHT)
                    (make-pair "B" LS-RIGHT)
                    (make-pair "C" LS-RIGHT)))

(check-expect (score "ABC" "XYZ")
              (list (make-pair "A" LS-WRONG)
                    (make-pair "B" LS-WRONG)
                    (make-pair "C" LS-WRONG)))

(check-expect (score "CBA" "ABC")
              (list (make-pair "C" LS-MISPLACED)
                    (make-pair "B" LS-RIGHT)
                    (make-pair "A" LS-MISPLACED)))


(check-expect (score "AAA" "ABC")
              (list (make-pair "A" LS-RIGHT)
                    (make-pair "A" LS-MISPLACED)
                    (make-pair "A" LS-MISPLACED)))

(check-expect (score "AAAXB" "ABCAD")
              (list (make-pair "A" LS-RIGHT)
                    (make-pair "A" LS-MISPLACED)
                    (make-pair "A" LS-MISPLACED)
                    (make-pair "X" LS-WRONG)
                    (make-pair "B" LS-MISPLACED)))

(check-expect (score "WEARY" "DONOR")
              (list (make-pair "W" LS-WRONG)
                    (make-pair "E" LS-WRONG)
                    (make-pair "A" LS-WRONG)
                    (make-pair "R" LS-MISPLACED)
                    (make-pair "Y" LS-WRONG)))

(check-expect (score "BROIL" "DONOR")
              (list (make-pair "B" LS-WRONG)
                    (make-pair "R" LS-MISPLACED)
                    (make-pair "O" LS-MISPLACED)
                    (make-pair "I" LS-WRONG)
                    (make-pair "L" LS-WRONG)))

(check-expect (score "ROUND" "DONOR")
              (list (make-pair "R" LS-MISPLACED)
                    (make-pair "O" LS-RIGHT)
                    (make-pair "U" LS-WRONG)
                    (make-pair "N" LS-MISPLACED)
                    (make-pair "D" LS-MISPLACED)))

(check-expect (score "DONOR" "DONOR")
              (list (make-pair "D" LS-RIGHT)
                    (make-pair "O" LS-RIGHT)
                    (make-pair "N" LS-RIGHT)
                    (make-pair "O" LS-RIGHT)
                    (make-pair "R" LS-RIGHT)))

(check-expect (score "GOALS" "ATONE")
              (list (make-pair "G" LS-WRONG)
                    (make-pair "O" LS-MISPLACED)
                    (make-pair "A" LS-MISPLACED)
                    (make-pair "L" LS-WRONG)
                    (make-pair "S" LS-WRONG)))

(check-expect (score "AROMA" "ATONE")
              (list (make-pair "A" LS-RIGHT)
                    (make-pair "R" LS-WRONG)
                    (make-pair "O" LS-RIGHT)
                    (make-pair "M" LS-WRONG)
                    (make-pair "A" LS-MISPLACED)))

(check-expect (score "AWOKE" "ATONE")
              (list (make-pair "A" LS-RIGHT)
                    (make-pair "W" LS-WRONG)
                    (make-pair "O" LS-RIGHT)
                    (make-pair "K" LS-WRONG)
                    (make-pair "E" LS-RIGHT)))

(check-expect (score "ABODE" "ATONE")
              (list (make-pair "A" LS-RIGHT)
                    (make-pair "B" LS-WRONG)
                    (make-pair "O" LS-RIGHT)
                    (make-pair "D" LS-WRONG)
                    (make-pair "E" LS-RIGHT)))

(check-expect (score "ATONE" "ATONE")
              (list (make-pair "A" LS-RIGHT)
                    (make-pair "T" LS-RIGHT)
                    (make-pair "O" LS-RIGHT)
                    (make-pair "N" LS-RIGHT)
                    (make-pair "E" LS-RIGHT)))





; When a player is actively guessing, they may have fewer letters than are
; required of a full Wordle guess (5, in the NYT version).

; TODO 4/8: Finish designing the function partial-guess->full-guess, which pads
;           a string with spaces up to the supplied length.
;
;           Notes:
;           - You have been supplied a sufficient set of tests for this
;             function; they should all pass once your code is written.
;           - You have ALSO been supplied a working coded version of the
;             function that uses string-based helpers; to practice ISL list
;             abstractions, your code is REQUIRED to instead solve this task
;             using explode (to convert the string to a list of 1String's),
;             build-list (to produce extra spaces, as necessary), append (to
;             combine the guess with its padding), and then implode (to convert
;             the list of 1String's back into a string).
;           - Once these tests pass, uncomment the partial-guess->image design
;             below, which allows you to easily visualize a partial guess:
;             BOTH the current guess, as well as the remaining (blank) guesses.


; partial-guess->full-guess : String Nat -> String
; expands a guess with spaces to fill up the supplied length

#|
(check-expect (partial-guess->full-guess "" 3) "   ")
(check-expect (partial-guess->full-guess "ABC" 3) "ABC")
(check-expect (partial-guess->full-guess "XYZ" 5) "XYZ  ")
|#

; (example using string-based functions, see instructions above)
(define (partial-guess->full-guess/string s len)
  (string-append
   s
   (replicate (- len (string-length s)) " ")))

; YOUR (LIST-BASED) partial-guess->full-guess CODE HERE!
; (once this is working, uncomment & review the code below)


; partial-guess->image : String Nat -> Image
; visualizes a partial guess (up to a supplied length,
; assumed to be at least as long as the supplied string)

#|
(check-expect
 (partial-guess->image "" 3)
 (beside GAP
         (guess-letter->image " ")
         GAP
         (guess-letter->image " ")
         GAP
         (guess-letter->image " ")
         GAP))

(check-expect
 (partial-guess->image "ABC" 3)
 (beside GAP
         (guess-letter->image "A")
         GAP
         (guess-letter->image "B")
         GAP
         (guess-letter->image "C")
         GAP))

(check-expect
 (partial-guess->image "XYZ" 5)
 (beside GAP
         (guess-letter->image "X")
         GAP
         (guess-letter->image "Y")
         GAP
         (guess-letter->image "Z")
         GAP
         (guess-letter->image " ")
         GAP
         (guess-letter->image " ")
         GAP))

(define (partial-guess->image s len)
  (row->image
   (map
    (λ (l) (make-pair l guess-letter->image))
    (explode
     (partial-guess->full-guess s len)))))
|#



; Now you are ready to implement your program :)
; First, review the following representation we'll use for state...


(define-struct wordle [past current])

; A WordleState (WS) is a (make-wordle [List-of String] String)
; Interpretation: the previous and current guess in a Wordle game

(define WS-START (make-wordle '() ""))
(define WS-TYPE1 (make-wordle '() "C"))
(define WS-TYPE2 (make-wordle '() "CA"))
(define WS-TYPE3 (make-wordle '() "CAT"))
(define WS-TYPE-BAD (make-wordle '() "CAX"))
(define WS-WORD1 (make-wordle (list "CAT") ""))
(define WS-WORD2 (make-wordle (list "CAT" "DAB") ""))
(define WS-WORD3 (make-wordle (list "CAT" "DAB" "BAD") ""))


; TODO 5/8: Now design the on-key handler by finishing the design for key-wordle.
;
;           Notes:
;           - Make sure you read and understand all the supplied tests, which
;             capture how the function is supposed to work. Once your code is
;             complete, all of these tests should pass (and that is sufficient
;             testing for this function).
;           - We recommend breaking this function into helpers based upon the
;             type of supplied key, as you see in the organization of the tests.
;           - It might help to review Homework 2, where we did a simpler version
;             of Wordle keyboard handling.


; key-wordle : WS KeyEvent [List-of String] Nat -> WS
; processes a keyboard event given a list of valid words and the required word length


; backspace tests
(check-expect
 (key-wordle WS-START "\b" LITTLE-WORDS 3)
 WS-START)

(check-expect
 (key-wordle WS-TYPE1 "\b" LITTLE-WORDS 3)
 WS-START)

(check-expect
 (key-wordle WS-TYPE2 "\b" LITTLE-WORDS 3)
 WS-TYPE1)

(check-expect
 (key-wordle WS-TYPE3 "\b" LITTLE-WORDS 3)
 WS-TYPE2)

(check-expect
 (key-wordle WS-TYPE-BAD "\b" LITTLE-WORDS 3)
 WS-TYPE2)

(check-expect
 (key-wordle WS-WORD1 "\b" LITTLE-WORDS 3)
 WS-WORD1)

; return tests
(check-expect
 (key-wordle WS-START "\r" LITTLE-WORDS 3)
 WS-START)

(check-expect
 (key-wordle WS-TYPE1 "\r" LITTLE-WORDS 3)
 WS-TYPE1)

(check-expect
 (key-wordle WS-TYPE2 "\r" LITTLE-WORDS 3)
 WS-TYPE2)

(check-expect
 (key-wordle WS-TYPE3 "\r" LITTLE-WORDS 3)
 WS-WORD1)

(check-expect
 (key-wordle WS-TYPE-BAD "\r" LITTLE-WORDS 3)
 WS-TYPE-BAD)

(check-expect
 (key-wordle WS-WORD1 "\r" LITTLE-WORDS 3)
 WS-WORD1)

; other keys
(check-expect
 (key-wordle WS-START "C" LITTLE-WORDS 3)
 WS-TYPE1)

(check-expect
 (key-wordle WS-START "c" LITTLE-WORDS 3)
 WS-TYPE1)

(check-expect
 (key-wordle WS-START "1" LITTLE-WORDS 3)
 WS-START)

(check-expect
 (key-wordle WS-TYPE1 "A" LITTLE-WORDS 3)
 WS-TYPE2)

(check-expect
 (key-wordle WS-TYPE1 "A" LITTLE-WORDS 1)
 WS-TYPE1)

(check-expect
 (key-wordle WS-TYPE1 "2" LITTLE-WORDS 3)
 WS-TYPE1)

(check-expect
 (key-wordle WS-TYPE2 "T" LITTLE-WORDS 3)
 WS-TYPE3)

(check-expect
 (key-wordle WS-TYPE2 "X" LITTLE-WORDS 3)
 WS-TYPE-BAD)

(check-expect
 (key-wordle WS-TYPE3 "S" LITTLE-WORDS 3)
 WS-TYPE3)




; TODO 6/8: And now design the stop-when handler by finishing the design for
;           end-wordle?.
;
;           Notes:
;           - Make sure you read and understand all the supplied tests, which
;             capture how the function is supposed to work. Once your code is
;             complete, all of these tests should pass (and that is sufficient
;             testing for this function).


; end-wordle? : WS String Nat -> Boolean
; determines if the game is over, either because the
; (supplied) maximum number of guesses has been made,
; or the (supplied) correct word had been previously
; guessed


(check-expect (end-wordle? WS-START "BAD" 5) #false)
(check-expect (end-wordle? WS-TYPE1 "BAD" 5) #false)
(check-expect (end-wordle? WS-TYPE2 "BAD" 5) #false)
(check-expect (end-wordle? WS-TYPE3 "BAD" 5) #false)
(check-expect (end-wordle? WS-TYPE-BAD "BAD" 5) #false)
(check-expect (end-wordle? WS-WORD1 "BAD" 5) #false)
(check-expect (end-wordle? WS-WORD1 "BAD" 1) #true)
(check-expect (end-wordle? WS-WORD1 "CAT" 3) #true)

(check-expect (end-wordle? WS-WORD2 "BAD" 5) #false)
(check-expect (end-wordle? WS-WORD2 "BAD" 2) #true)
(check-expect (end-wordle? WS-WORD2 "DAB" 2) #true)

(check-expect (end-wordle? WS-WORD3 "BAD" 5) #true)
(check-expect (end-wordle? WS-WORD3 "ETA" 5) #false)





; TODO 7/8: Design the function used to draw the final state (when stop-when
;           returns true) by finishing the design for draw-end-wordle.
;
;           Notes:
;           - Your end screen should indicate...
;             * Whether the player won or lost
;             * And if they won, how many guesses it took
;           - You haven't been supplied tests so that you have some room for
;             creativity in your visualization :)


; draw-end-wordle : WS String Nat -> Image
; produces the game end screen




; TODO 8/8: And now, design the to-draw handler by finishing the design for
;           draw-wordle.
;
;           Notes:
;           - Your play screen should (at least)...
;             * Visualize all prior guesses (a combination of score, lsp->image,
;               and row->image are useful here)
;             * Visualize the current partial guess (partial-guess->image is
;               quite useful here; note that the length of the correct word
;               tells you the number of letters per guess)
;             * Visualize any remaining future guesses (partial-guess->image can
;               also be quite useful here)
;           - As a suggestion: separate each piece of the interface into
;             separate values/functions, then combine via stack/v
;           - You haven't been supplied tests so that you have some room for
;             creativity in your interface :)


; draw-wordle : WS String Nat -> Image
; visualizes the play state of wordle given the correct answer
; and number of available guesses




; When you have completed all the TODOs, it's game time!!! :)
; Uncomment the function below


; play : String Nat String -> [List-of String]
; starts a game of Wordle given the correct answer,
; the number of guesses, and the location of the valid
; guesses and produces the guesses

#|
(define (play correct num-guesses guesses-file)
  (local [(define VALID (read-dictionary guesses-file))
          (define UP-CORRECT (string-upcase correct))]
    (wordle-past
     (big-bang WS-START
       [to-draw (λ (ws) (draw-wordle ws UP-CORRECT num-guesses))]
       [on-key (λ (ws ke) (key-wordle ws ke VALID (string-length UP-CORRECT)))]
       [stop-when (λ (ws) (end-wordle? ws UP-CORRECT num-guesses))
                  (λ (ws) (draw-end-wordle ws UP-CORRECT num-guesses))]))))
|#



; Make sure you understand the function, and then...

; run for a tiny, testing game:
; (play "bad" 4 "little.txt")

; run for full-on prior game from the NYT
; (play "berth" 6 "nyt.txt")
