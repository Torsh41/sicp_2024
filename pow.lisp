;gnu clisp  2.49.60

(defun mult_rec(base exp)
    (if (eq exp 0)
        1
        (if (eq (mod exp 2) 0)
            (mult_rec (* base base) (/ exp 2))
            (* base (mult_rec base (- exp 1)))
        )
    )
)
(defun mult_iter(base exp)
    (progn
        (setq res 1)
        (dotimes (n exp)
            (setq res (* res base))
        )
        res
     )
)


(print "RECURSION")
(print (mult_rec 2 0))
(print (mult_rec 2 1))
(print (mult_rec 2 2))
(print (mult_rec 2 3))
(print (mult_rec 2 4))
(print (mult_rec 2 5))
(print (mult_rec 2 6))
(print "ITERATION")
(print (mult_iter 2 0))
(print (mult_iter 2 1))
(print (mult_iter 2 2))
(print (mult_iter 2 3))
(print (mult_iter 2 4))
(print (mult_iter 2 5))
(print (mult_iter 2 6))

