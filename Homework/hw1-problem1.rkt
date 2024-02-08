;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname hw1-problem1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Problem 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Understanding code that doesn't have effective naming and documentation
; can be really challenging! (That's part of the reason that this class, and
; most organizations with software-development teams, employ style guides.)

; As an example, consider the confusing functions defined below...

; Hints:
;  - For built-in functions that aren’t familiar to you,
;    be sure to look them up in the DrRacket documentation!
;  - Once you have a theory about what a function is doing, try
;    running it in the interactions window, then try changing
;    parameters to confirm how it all works!
;  - You might start with smaller, simpler functions, and
;    then that can help understand bigger ones (that use them!)


; SIGNATURE HERE: nonplus1: string natural number ----> string 
; PURPOSE HERE: replicates b number of exclamation points
; capitalizes a variable
; concatenates strings a and b
(define (nonplus1 a b)
  (string-append
   (string-upcase a)
   (replicate b "!")))


; SIGNATURE HERE: nonplus2: real string real ----> real 
; PURPOSE HERE: first it find the length of string b (a real number)
; then it finds the max value between a and the string length of b
; lastly it finds the min value between c and the max value between a and the string length of b 
(define (nonplus2 a b c)
  (min
   (max
    (string-length b)
    a)
   c))


; SIGNATURE HERE: nonplus3: string real string(color) ---> string
; PURPOSE HERE: the first text is the string from the variable
; nonplus1 and is set in font-size 30 and the color is "c"
; it is layered above another text of a star that's repeated by
; nonplus2 number of times and is set font size of 20 and the color is c
(define (nonplus3 a b c)
  (above
   (text (nonplus1 a b) 30 c)
   (text (replicate (nonplus2 b a 5) "⭐") 20 c)))


; TODO 1/2: Replace each "SIGNATURE HERE" and "PURPOSE HERE" with signature
;           and purpose statements for that function. Remember, a purpose
;           statement should say *what* a function does, not just re-state
;           the signature; the signature precisely *how* to use the function,
;           that is, what type(s) of data need to be supplied (in what order)
;           and what type of data will be returned. In some sense, the purpose
;           helps someone figure out if they will find a function useful, and
;           then the signature helps them use it.

; TODO 2/2: Confirm the above TODO by defining at least one pair of constants
;           per function, according to the following rules...
;           - In each pair, end the name of one -ACTUAL and the other -EXPECTED;
;             for example, NONPLUS1-ACTUAL and NONPLUS1-EXPECTED
;           - The "ACTUAL" value should call the function with a set of arguments
;             you select, which must adhere to your signature; the "EXPECTED"
;             should be the value (like "hi!") or expression (like (text "hi!" 5 "black"))
;             you expect ACTUAL to be when executed;
;             for example, the value for NONPLUS1-ACTUAL could be (nonplus1 3 4)
;             and the value for NONPLUS1-EXPECTED could be 7, if you thought the
;             function added two numeric arguments
;           - If you would like to demonstrate multiple actual/expected pairs, you are
;             welcome, in which case just be reasonable in how you name them (e.g.,
;             NONPLUS1-ACTUAL-A, NONPLUS1-EXPECTED-A)
;           - Now run your program and make sure each ACTUAL/EXPECTED pair is equal
;             (you can do this in the intermediate window, or using a check-expect)
;
;           Note: as we proceed in the course, you'll be doing this a lot in the form
;           of tests, since they are helpful to document your code, as well as make
;           sure it works the way you think it does!

(define NONPLUS1-ACTUAL (nonplus1 "log" 3))
(define NONPLUS1-EXPECTED "LOG!!!")

(define NONPLUS2-ACTUAL (nonplus2 3 "Barrel" 5))
(define NONPLUS2-EXPECTED 5)

(define NONPLUS3-ACTUAL (nonplus3 "log" 3 "red"))
(define NONPLUS3-EXPECTED
  (above
   (text "LOG!!!" 30 "red")
   (text "⭐⭐⭐" 20 "red")))



