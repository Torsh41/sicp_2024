; var 2
; 1/3**3 + 2/5**3 + 3/7**3

(defun qube (x) (* x x x))
(defun square (x) (* x x))
(defun line (x) x)

; compute var 1
; (defun (compute a1 a2) (/ 1 (+ a1 a2)))
; compute var 2
(defun compute (x) (/ x
                      (qube (+ 1 (* x 2)))))

; @param computer - function that computes some value at idx
; @param operator - does something to the result of `computer` and `(combine ... (+ 1 idx))`
; @param idx - current index of the series
; @param lim - final index of the series (precision?)
(defun combine (computer operator)
    (defun callback (idx lim) (if (> idx lim)
                               0
                               (funcall operator (funcall computer idx)
                                                 (callback (+ 1 idx) lim))
                               )))
  

; a wrapper
(defun model (lim) (if (< lim 0)
                     0
                     (funcall (combine2 'line '+) 0 lim)))

; (print (model 'line '+ 5))
(print (model2 4))
