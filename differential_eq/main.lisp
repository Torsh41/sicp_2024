; Как использовать:
; (Расчет)
; - Разкомментировать один из примеров в конце файла
; - Запустить программу
; (Вывод графика)
; - Переписать результат выполнения программы в отдельный файл в формате:
;       <Пустая строка>
;       (print-range tr)
;       (print-range xr)
;       ... <-- Данные
;       ...
;       ...
; - Открыть скрипт 'datafile.py'
; - В низу изменить путь до файла, в котором сохранены данные
; - Запустить скрипт



; TODO: add README
; TODO: use the streams
; ================================
;             Streams
; ================================

(defun stream-read-custom-bullshit-lab4 (p-func c-func)
  (defun stream-read (s)
    (progn
      ; (print s)
      ; (print (car (stream-car s)))
      ; (print (cdr (stream-car s)))
      (funcall p-func (car (stream-car s)))
      (if (funcall c-func
                   (car (stream-car s))
                   (cdr (stream-car s)))
        (funcall p-func (cdr (stream-car s)))
        ; (print "FINISH")
        (stream-read (stream-cdr s))
        ))))

(defun stream-read-custom (p-func)
  (defun stream-read (n s)
    (when (> n 0)
      (funcall p-func (stream-car s))
      (stream-read (1- n) (stream-cdr s)))))
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


(defun sqr (x) (* x x))
(defmacro print-row (row size)
  `(progn
  (terpri)
  (dotimes (i ,size)
    (format T "~,5f," (aref ,row i)))))

(defstruct range
  start
  end
  step
  count)
(defun init-range (start end step)
  (make-range :start start
              :end end
              :step step
              :count (1+ (floor (- end start) step))))
(defmacro print-range (range) 0)
(defmacro print-range (range)
  `(progn
     (terpri)
     (format T "~d, ~d, ~d, ~d"
             (range-start ,range)
             (range-end ,range)
             (range-step ,range)
             (range-count ,range))))
; (defmacro range-start (range)
;   `(nth 0 ,range))
; (defmacro range-end (range)
;   `(nth 1 ,range))
; (defmacro range-step (range)
;   `(nth 2 ,range))
; (defmacro range-count (range)
;   `(nth 3 ,range))
; TODO: turn into a precomputed function?
(defmacro t-nth (range n)
  `(+ (* (range-step ,range) ,n)
      (range-start ,range)))
(defmacro x-ith (range i)
  `(t-nth ,range ,i))

; ====================================
;               LOOPS
; ====================================
(defun nth-loop (iv)
  (lambda (ith-loop-explicit tr xr)
    (lambda ()
      (print-range tr)
      (print-range xr)
      ; create the array
      ; TODO: set initial element prettier (generate values in a list, then apply to :initial-content)
      (setf nth-row (make-array (list (range-count xr))
                                ; :element-type float
                                :initial-element 0.0))
      ; set initial values for n=0
      (dotimes (i (range-count xr))
        (setf (aref nth-row i) (funcall iv (x-ith xr i))))
      (defun nth-loop-stream (&optional (row nth-row) (n 1))
        (stream-cons row (nth-loop-stream (funcall ith-loop-explicit n row)
                                          (1+ n))))
      ; calculate the matrix with streams
      (funcall (stream-read-custom (lambda (row) (print-row row (range-count xr))))
               (range-count tr)
               (nth-loop-stream)))))
(defun nth-loop-bullshit-lab4 (iv epsylon)
  (lambda (ith-loop tr xr)
    (setf exit-condition
          (lambda (u uprev)
            (progn
              (setf sum_sq 0)
              (loop as i from 0 to (1- (range-count xr))
                    do (setf sum_sq (+ sum_sq (sqr (- (aref u i) (aref uprev i))))))
              (<= (sqrt (* (range-step xr) sum_sq)) epsylon))))
  (lambda ()
      (print-range tr)
      (print-range xr)
      ; create the array
      ; TODO: set initial element prettier (generate values in a list, then apply to :initial-content)
      (setf nth-row (make-array (list (range-count xr))
                                ; :element-type float
                                :initial-element 0.0))
      ; set initial values for n=0
      (dotimes (i (range-count xr))
        (setf (aref nth-row i) (funcall iv (x-ith xr i))))
      (setf n1th-row (funcall ith-loop 0 nth-row))

      (defun nth-loop-stream (&optional (rows (cons n1th-row nth-row))
                                        (n 1))
        (stream-cons rows
                     (nth-loop-stream (cons
                                        (funcall ith-loop n (car rows))
                                        (car rows))
                                      (1+ n))))
      ; calculate the matrix with streams
      (funcall (stream-read-custom-bullshit-lab4
                 (lambda (row) (print-row row (range-count xr)))
                 exit-condition)
               (nth-loop-stream)))))
(defun ith-loop-explicit (upsilon sigma fun lbc rbc)
  (lambda (tr xr)
    (setf compute-next-row-element
          (lambda (nth-row n i)
            (+ (aref nth-row i)
               (/ (* upsilon
                     (range-step tr)
                     (- (aref nth-row (1- i))
                        (aref nth-row i)))
                  (range-step xr))
               (/ (* sigma
                     (range-step tr)
                     (+ (aref nth-row (1+ i))
                        (* -2 (aref nth-row i))
                        (aref nth-row (1- i))))
                  (sqr (range-step xr)))
               (* (funcall fun
                           (aref nth-row i)
                           (t-nth tr n)
                           (x-ith xr i))
                  (range-step tr)))))
    (setf compute-lbc
          (funcall (lambda (phi)
                     (cond ((eq phi 'nil) (lambda (u phi psi) psi))
                           ((= phi 0) (lambda (u phi psi)
                                        (- u (* (range-step xr) psi))))
                           (t (lambda (u phi psi)
                                (/ (- u (* (range-step xr) psi))
                                   (+ 1 (* (range-step xr) phi)))))))
                   (car (funcall lbc (range-start tr)))))
    (setf compute-rbc
          (funcall (lambda (phi)
                     (cond ((eq phi 'nil) (lambda (u phi psi) psi))
                           ((= phi 0) (lambda (u phi psi)
                                        (+ u (* (range-step xr) psi))))
                           (t (lambda (u phi psi)
                                (/ (+ u (* (range-step xr) psi))
                                   (- 1 (* (range-step xr) phi)))))))
                   (car (funcall rbc (range-start tr)))))
    (lambda (n nth-row) ;TODO: change result to row-prev
      (setf row (make-array (list (range-count xr))
                            ; :element-type float
                            :initial-element 0.0))
      (loop as i from 1 to (- (range-count xr) 2)
            do (setf (aref row i)
                     (funcall compute-next-row-element nth-row n i)))
      (setf (aref row 0)
            (apply compute-lbc
                   (cons (aref row 1)
                         (funcall lbc (t-nth tr n)))))
      (setf (aref row (1- (range-count xr)))
            (apply compute-rbc
                   (cons (aref row (- (range-count xr) 2))
                         (funcall rbc (t-nth tr n)))))
      ; TODO: wrap ALL this into a more functional thing
      row)))
(defun ith-loop-implicit-right (upsilon sigma fun lbc rbc)
  ; loop to calculate coeficients from left to right
  ; loop to calculate from right to left
  (lambda (tr xr)
    ; TODO: convert pm-a, pm-b and pm-c into a function f(t,x)
    (defvar pm-a (- (/ (* sigma (range-step tr))
                       (sqr (range-step xr)))))
    (defvar pm-b (+ 1
                    (/ (* upsilon (range-step tr))
                       (range-step xr))
                    (/ (* 2 sigma (range-step tr))
                        (sqr (range-step xr)))))
    (defvar pm-c (+ (- (/ (* upsilon (range-step tr))
                          (range-step xr)))
                    (- (/ (* sigma (range-step tr))
                          (sqr (range-step xr))))))
    (setf compute-epsylon (lambda (u y x) (+ u (* (range-step tr)
                                                  (fun u y x)))))
    (setf compute-alpha (lambda (a b c alpha)
                          (/ (- a)
                             (+ b (* c alpha)))))
    (setf compute-betta (lambda (b c alpha betta epsylon)
                          (/ (- epsylon (* c betta))
                             (+ b (* c alpha)))))
    (setf compute-next-row-element
          (lambda (alpha betta u)
            (+ (* u alpha) betta)))
    ; Same as: (setf compute-lbc (list compute-alpha-0 compute-betta-0))
    (setf compute-lbc
          (funcall (lambda (phi)
                     (cond ((eq phi 'nil) (list (lambda (phi psi) 0)
                                                (lambda (phi psi) psi)))
                           ((= phi 0) (list (lambda (phi psi) 1)
                                            (lambda (phi psi)
                                              (- (* (range-step xr) psi)))))
                           (t (list (lambda (phi psi)
                                      (/ 1
                                         (1+ (* (range-step xr) psi))))
                                    (lambda (phi psi)
                                      (/ (- (* (range-step xr) psi))
                                         (1+ (* (range-step xr) phi))))))))
                   (car (funcall lbc (range-start tr)))))
    (setf compute-rbc
          (funcall (lambda (phi)
                     (cond ((eq phi 'nil) (lambda (alpha betta phi psi) psi))
                           ((= phi 0) (lambda (alpha betta phi psi)
                                        (/ (+ (* (range-step xr) psi) betta)
                                           (- 1 alpha))))
                           (t (lambda (alpha betta phi psi)
                                (/ (+ (* (range-step xr) psi) betta)
                                   (- 1 alpha (* (range-step xr) phi)))))))
                   (car (funcall rbc (range-start tr)))))
    ;; The loop function
    (lambda (n nth-row)
      ;; calculate coefs
      (setf alphas (make-array (list (range-count xr))
                               ; :element-type float
                               :initial-element 0.0))
      (setf bettas (make-array (list (range-count xr))
                               ; :element-type float
                               :initial-element 0.0))
      (setf (aref alphas 0) (apply (car compute-lbc)
                                   (funcall lbc (t-nth tr n))))
      (setf (aref bettas 0) (apply (car (cdr compute-lbc))
                                   (funcall lbc (t-nth tr n))))
      (loop as i from 1 to (1- (range-count xr))
            do (funcall
                 (lambda (alpha betta epsylon)
                   (progn
                     (setf (aref alphas i) (funcall compute-alpha
                                                    pm-a pm-b pm-c alpha))
                     (setf (aref bettas i) (funcall compute-betta
                                                    pm-b pm-c alpha betta epsylon))))
                 (aref alphas (1- i))
                 (aref bettas (1- i))
                 (funcall compute-epsylon
                          (aref nth-row i)
                          (t-nth tr (1- n)) (x-ith xr i))))
      ;; Calculate the next row
      (setf row (make-array (list (range-count xr))
                            ; :element-type float
                            :initial-element 0.0))
      (setf (aref row (1- (range-count xr))) (apply compute-rbc
                                                    (append (list (aref alphas (- (range-count xr) 2))
                                                                  (aref bettas (- (range-count xr) 2)))
                                                            (funcall rbc (t-nth tr n)))))
      (loop as i from (- (range-count xr) 2) downto 0
            do (setf (aref row i) (funcall compute-next-row-element
                                           (aref alphas i)
                                           (aref bettas i)
                                           (aref row (1+ i)))))
      ;; return the (n+1)th-row
      row)))
(defun ith-loop-implicit-left (upsilon sigma fun lbc rbc)
  ; TODO: completely broken. Somwhere between debug messages
  ; loop to calculate coeficients from right to left
  ; loop to calculate values from left to right
; -a = alpha b + alpha ap c
; -a - alpha b = alpha ap c
; ap = - (a + alpha b) / (alpha c)

; betta b + betta c ap = eps - c bp
; c bp = betta (b + c ap) - eps
; bp = (betta (b + c ap) - eps) / c

; up = a u + b
; u = (up - b) / a

  (lambda (tr xr)
    ; TODO: convert pm-a, pm-b and pm-c into a function f(t,x)
    (defvar pm-a (- (/ (* sigma (range-step tr))
                       (sqr (range-step xr)))))
    (defvar pm-b (+ 1
                    (/ (* upsilon (range-step tr))
                       (range-step xr))
                    (/ (* 2 sigma (range-step tr))
                        (sqr (range-step xr)))))
    (defvar pm-c (+ (- (/ (* upsilon (range-step tr))
                          (range-step xr)))
                    (- (/ (* sigma (range-step tr))
                          (sqr (range-step xr))))))
    (setf compute-epsylon (lambda (u y x) (+ u (* (range-step tr)
                                                  (fun u y x)))))
    (setf compute-alpha (lambda (a b c alpha)
                          (/ (+ a (* b alpha))
                             (* c alpha))))
    (setf compute-betta (lambda (b c alpha betta epsylon)
                          (/ (+ (* b betta) (* c alpha betta) (- epsylon))
                             c)))
    (setf compute-next-row-element
          (lambda (alpha betta u)
            (/ (- u betta) alpha)))
    ; Same as: (setf compute-lbc (list compute-alpha-0 compute-betta-0))
    (setf compute-lbc
          (funcall (lambda (phi)
                     (cond ((eq phi 'nil) (lambda (alpha betta phi psi) psi))
                           ; ((= phi 0) (lambda (alpha betta phi psi)
                           ;              (/ (+ (* (range-step xr) psi) betta)
                           ;                 (- 1 alpha))))
                           ; (t (lambda (alpha betta phi psi)
                           ;      (/ (+ (* (range-step xr) psi) betta)
                           ;         (- 1 alpha (* (range-step xr) phi)))))))
                           ((= phi 0) (lambda (alpha betta phi psi)
                                (* alpha (range-step rx) psi)
                                   ))
                           (t (lambda (alpha betta phi psi)
                                (/ (+ (* alpha (range-step rx) psi) (* betta (1- (* (range-step rx) phi))))
                                   (- 1 (* (range-step rx) phi) alpha))))))
                   (car (funcall lbc (range-start tr)))))
    (setf compute-rbc
          (funcall (lambda (phi)
                     (cond ((eq phi 'nil) (list (lambda (phi psi) 0)
                                                (lambda (phi psi) psi)))
                           ((= phi 0) (list (lambda (phi psi) 1)
                                            (lambda (phi psi)
                                              (- (* (range-step xr) psi)))))
                           (t (list (lambda (phi psi)
                                      (/ 1
                                         (1+ (* (range-step xr) psi))))
                                    (lambda (phi psi)
                                      (/ (- (* (range-step xr) psi))
                                         (1+ (* (range-step xr) phi))))))))
                   (car (funcall rbc (range-start tr)))))
    ;; The loop function
    (lambda (n nth-row)
      ;; calculate coefs
      (setf alphas (make-array (list (range-count xr))
                               ; :element-type float
                               :initial-element 0.0))
      (setf bettas (make-array (list (range-count xr))
                               ; :element-type float
                               :initial-element 0.0))
      (setf (aref alphas (1- (range-count xr)))
            (apply (car compute-rbc)
                   (funcall rbc (t-nth tr n))))
      (setf (aref bettas (1- (range-count xr)))
            (apply (car (cdr compute-rbc))
                   (funcall rbc (t-nth tr n))))
; ap = - (a + alpha b) / (alpha c)
; bp = (betta (b + c ap) - eps) / c
; u = (up - b) / a
; *** - CAR: #<FUNCTION :LAMBDA (ALPHA BETTA PHI PSI) PSI> is not a list
      (print "HAY")
      (loop as i from (- (range-count xr) 2) downto 0
            do (funcall
                 (lambda (alpha betta epsylon)
                   (progn
                     (setf (aref alphas i) (funcall compute-alpha
                                                    pm-a pm-b pm-c alpha))
                     (setf (aref bettas i) (funcall compute-betta
                                                    pm-b pm-c
                                                    (aref alphas i)
                                                    betta epsylon))))
                 (aref alphas (1+ i))
                 (aref bettas (1+ i))
                 ;; TODO:
                 (funcall compute-epsylon
                          (aref nth-row i)
                          (t-nth tr (1- n)) (x-ith xr i))))
      (print "DAY")
      ; (setf (aref row (1- (range-count xr))) (apply compute-rbc
      ;                                               (append (list (aref alphas (- (range-count xr) 2))
      ;                                                             (aref bettas (- (range-count xr) 2)))
      ;                                                       (funcall rbc (t-nth tr n)))))
      ;; Calculate the next row
      (setf row (make-array (list (range-count xr))
                            ; :element-type float
                            :initial-element 0.0))
      (print "NAY")
      (setf (aref row 0)
            (apply compute-lbc
                   (append (list (aref alphas 0)
                                 (aref bettas 0))
                           (funcall lbc (t-nth tr n)))))
      (print "YAY")
      (loop as i from 1 to (1- (range-count xr))
            do (setf (aref row i) (funcall compute-next-row-element
                                           (aref alphas i)
                                           (aref bettas i)
                                           (aref row (1- i)))))
      ;; return the (n+1)th-row
      row)))
(defun ith-loop-implicit-special-left (upsilon sigma fun lbc rbc)
  ; Special case, sigma=0; upsilon>0
  (lambda (tr xr)
    (setf compute-next-row-element
          (lambda (nth-row n i)
            (+ (aref nth-row i)
               (/ (* upsilon
                     (range-step tr)
                     (- (aref nth-row (1- i))
                        (aref nth-row i)))
                  (range-step xr))
               ; (/ (* sigma
               ;       (range-step tr)
               ;       (+ (aref nth-row (1+ i))
               ;          (* -2 (aref nth-row i))
               ;          (aref nth-row (1- i))))
               ;    (sqr (range-step xr)))
               (* (funcall fun
                           (aref nth-row i)
                           (t-nth tr n)
                           (x-ith xr i))
                  (range-step tr)))))
    (setf compute-lbc
          (funcall (lambda (phi)
                     (cond ((eq phi 'nil) (lambda (u phi psi) psi))
                           ((= phi 0) (lambda (u phi psi)
                                        (- u (* (range-step xr) psi))))
                           (t (lambda (u phi psi)
                                (/ (- u (* (range-step xr) psi))
                                   (+ 1 (* (range-step xr) phi)))))))
                   (car (funcall lbc (range-start tr)))))
    (setf compute-rbc
          (funcall (lambda (phi)
                     (cond ((eq phi 'nil) (lambda (u phi psi) psi))
                           ((= phi 0) (lambda (u phi psi)
                                        (+ u (* (range-step xr) psi))))
                           (t (lambda (u phi psi)
                                (/ (+ u (* (range-step xr) psi))
                                   (- 1 (* (range-step xr) phi)))))))
                   (car (funcall rbc (range-start tr)))))
    (lambda (n nth-row) ;TODO: change result to row-prev
      (setf row (make-array (list (range-count xr))
                            ; :element-type float
                            :initial-element 0.0))
      (setf (aref row 0)
            (apply compute-lbc
                   (cons (aref row 1)
                         (funcall lbc (t-nth tr n)))))
      ; (setf (aref row (1- (range-count xr)))
      ;       (apply compute-rbc
      ;              (cons (aref row (- (range-count xr) 2))
      ;                    (funcall rbc (t-nth tr n)))))
      (loop as i from 1 to (- (range-count xr) 1)
            do (setf (aref row i)
                     (funcall compute-next-row-element nth-row n i)))
      ; TODO: wrap ALL this into a more functional thing
      row)))

; ====================================
;           FUNCTIONS CONFIG
; ====================================

;;; Problem template:
;; Differential equation:
; TODO case: upsilon and/or omega are functions
; TODO upsilon and omega can be functions of (t,x)
; TODO More derivatives
; TODO More comutation methods
; TODO Algorithm to decide which method to use (an interpreter)
;  ∂u     ∂u     ∂²u
;  -- + υ -- = σ --- + f(u,t,x)
;  ∂t     ∂x     ∂x²
;; Initial value:
; u(0,x) = u⁰(x)
;; Boundary conditions:
; - 1st type
;       u(t,0) = ψ₁(t)
;       u(t,l) = ψ₂(t)
; - 2nd type
;       (∂u / ∂x) (t,0) = ψ₁(t)
;       (∂u / ∂x) (t,l) = ψ₂(t)
; - 3nd type
;       (∂u / ∂x) (t,0) = u * φ₁(t) + ψ₁(t)
;       (∂u / ∂x) (t,l) = u * φ₂(t) + ψ₂(t)
;
;;; Parameters:
; υ - <upsilon>
; σ - <sigma>
; f(u,t,x)
; u⁰(x)
; <Left boundary condition>
; <Right boundary condition>
; 
;; Boundary conditions shall have the following format:
; '(NIL   ψ(t)) <-- 1st boundary condition
; '(φ(t)  ψ(t)) <-- 2nd boundary condition, where #'φ === (lambda (t) 0)
; '(φ(t)  ψ(t)) <-- 3rd boundary condition
; @note y is equivalent to t
; 

; 1st set of parameters
; (defvar upsilon 0)
; (defvar sigma 1)
; (defun fun (u y x) (* 2 (1- y)))
; (defun initial-value (x) (sqr x))
; (defun left-boundary-condition (y) (list NIL (sqr y)))
; (defun right-boundary-condition (y) (list NIL (1+ (sqr y))))

; 2nd set of parameters
; (defvar upsilon 1)
; (defvar sigma 0)
; (defun fun (u y x) (* (exp y) (1+ x)))
; (defun initial-value (x) x)
; (defun left-boundary-condition (y) (list NIL 0))
; (defun right-boundary-condition (y) (list NIL (exp y)))

; 3rd set of parameters (lab4)
(defvar upsilon 1)
(defvar sigma 1)
(defun fun (u y x) (initial-value x))
(defun initial-value (x) (1+ (* 4 x)))
(defun left-boundary-condition (y) (list NIL 0))
(defun right-boundary-condition (y) (list NIL 7))

(defvar eps 1e-4)

; (defvar upsilon (lambda (u, y, x) 1))
; (defvar sigma (lambda (u, y, x) 0))
; TODO: upsilon & sigma as functions
; (defvar upsilon (lambda (u, y, x) 1))
; (defvar sigma (lambda (u, y, x) 0))
; (defun fun (u y x) (* (exp y) (1+ x)))
; (defun initial-value (x) x)
; (defun left-boundary-condition (y) (list NIL 0))
; (defun right-boundary-condition (y) (list NIL (exp y)))


; ====================================
;               EXAMPLE
; ====================================


; The function takes a function to loop over the first parameter (over t, thus
; n-loop-generator, nl-g) and a list of arguments nl-arg to the nl-g. And similarly,
; il-g and il-arg
; The function returns a Function with preset (modular) functions and
; parameters, that can be called multiple times
; tr xr - range of parameter 't' and 'x'
(defun assemble (nl-g nl-arg il-g il-arg)
  (lambda (tr xr)
    (funcall (apply nl-g nl-arg)
             (funcall (apply il-g il-arg) tr xr)
             tr xr))) ; <-- RETURNS THE FUNCTION

; Example
(setf generate-grid (assemble
                            #'nth-loop
                            (list #'initial-value)
                            ; #'ith-loop-explicit
                            ; #'ith-loop-implicit-right
                            #'ith-loop-implicit-special-left
                            (list upsilon
                                  sigma
                                  #'fun
                                  #'left-boundary-condition
                                  #'right-boundary-condition)))
(setf generate-grid-bullshit-lab4 (assemble
                            #'nth-loop-bullshit-lab4
                            (list #'initial-value eps)
                            #'ith-loop-implicit-right
                            (list upsilon
                                  sigma
                                  #'fun
                                  #'left-boundary-condition
                                  #'right-boundary-condition)))
; (setf print-grid (funcall generate-grid
;                           (init-range 0 1 0.001)      ; t range
;                           (init-range 0 1 0.1)))    ; x range
(print "YAY")
(setf print-grid (funcall generate-grid-bullshit-lab4
                          (init-range 0 1 0.001)      ; t range
                          (init-range 0 1 0.01)))    ; x range
(funcall print-grid)



