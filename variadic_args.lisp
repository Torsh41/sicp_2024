(defun len (&rest args) (length args))
(print (len '1 '2 '3 '4 '5 '6))

(defun sum (&rest args) (apply #'+ args))
(print (sum '1 '2 '3 '4 '5 '6))
