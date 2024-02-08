;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 3-3_cond) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; v: cond
; syntax:

#|
(cond
  [test-1 answer-1]
  [test-2 answer-2]
  ...
  [test-n/else answer-n])
|#

; semantics: cond returns the first answer whose test is #true

















; TODO
; sign : Number -> String
; Returns "positive", "negative", or "zero" for the number


(check-expect (sign 5) "positive")
(check-expect (sign -5) "negative")
(check-expect (sign 0) "zero")

(define (sign num)
  (cond
    [(positive? num) "positive"]
    [( negative? num) "negative"]
    [(zero? num) "zero"]
    )
  )











; TODO
; miles->medallion : Nat -> String
; Returns the Delta status


(check-expect (miles->medallion 10) "member")
(check-expect (miles->medallion 26000) "silver")
(check-expect (miles->medallion 51000) "gold")
(check-expect (miles->medallion 80000) "platinum")
(check-expect (miles->medallion 130000) "diamond")
 
(define (miles->medallion miles)
  (cond
    [(>= miles 100000) "diamond"]
    [(>= miles 75000) "platinum"]
    [(>= miles 50000) "gold"]
    [(>= miles 25000) "silver"]
    [else "member"]
  ))








; TODO
; miles->access : Nat -> String
; Returns "None" or "Sky Priority" based upon num->grade


(check-expect (miles->access 10000) "None")
(check-expect (miles->access 30000) "None")
(check-expect (miles->access 60000) "Sky Priority")
 
(define (miles->access miles)
  (if (or (string=? (miles->medallion miles) "member")
          (string=? (miles->medallion miles) "silver"))
          "None" "Sky Priority")
  )

(miles->access 30000)


