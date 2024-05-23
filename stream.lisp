; A more direct approach
(setq list-of-fibonacci-numbers '(0 1 1 2 3 5 8 13 21 34))

(defun sq-roots-1 (n l)
  (when (> n 0)
    (print (sqrt (car l)))
    (sq-roots-1 (1- n) (cdr l))))

; (sq-roots-1 5 list-of-fibonacci-numbers)


; Fibonacci numbers generation
; (defun fibonacci (n)
;   (if (<= n 1)
;     n
;     (+ (fibonacci (- n 2)) (fibonacci (- n 1)))))

(defun fibonacci (n)
  (labels ((rec (x)
             (if (<= x 1)
                 1
                 (progn
                   (print x)
                   (+ (rec (- x 1)) (rec (- x 2)))))
             ))
    (rec n)))

; (print (fibonacci 7))

; An insane approach
(defun sq-roots-2 (n)
  (when (> n 0)
    (print (fibonacci n))
    (sq-roots-2 (1- n))))

; (sq-roots-2 10)

; ================================
;             Streams
; ================================

(defmacro delay (expr)
  `(lambda () ,expr))

(defun force (delayer-object)
  (funcall delayer-object))

(defmacro stream-cons (x y)
  `(cons ,x (delay ,y)))

(defun stream-car (s)
  (car s))

(defun stream-cdr (s)
  (force (cdr s)))

; (defmacro stream-filter (f s)
;   "(lambda f (element-of s)) - takes element each of stream s, returns T or NIL
;   Return T if (f (every s)) returns T, othervise returns NIL"
;   `(when (not (not ,s))
;      (if (,f (stream-car ,s))
;      (stream-filter f)))


; Create the stream
(defun fibs (&optional (a 0) (b 1))
  (stream-cons a (fibs b (+ a b))))
; (defun fibs (&optional (a 0) (b 1))
;   (stream-cons a (fibs b (+ a b))))

; Read the stream

; (defun stream-read (n s)
;   (when (= n 0) (print (stream-car s)))
;   (when (> n 0)
;     ; (print s)
;     ; (print (stream-car s))
;     (stream-read (1- n) (stream-cdr s))))

(defun stream-read (n s)
  (dotimes (i n)
    ; (print s)
    (setq s (stream-cdr s)))
  (stream-car s))

(setq str (fibs))
; (print (stream-read 0 str))
; (print (stream-read 1 str))
; (print (stream-read 2 str))
; (print (stream-read 3 str))
(print (stream-read 10000 str))
; (stream-read 10 str)
; (stream-read 15 str)
; (print str)

; (defun fibonacci-stream (n s)
;   (if (<= n 1)
;     1
;     (fibonacci))

; (defun a (sieve stream)
;   (stream-cons
;     (stream-car stream)
;     (sieve (stream-filter
;              (lambda (x)
;                (not (divisible? x (stream-car stream))))
;              (stream-cdr stream)))))


