<?php
// @note Requires at least PHP7
// ; ====================================
// ;       PARAMETER CLASS CONFIG
// ; ====================================
//
// ;;; Problem template:
// ;; Differential equation:
// ; TODO case: upsilon and/or omega are functions
// ; TODO upsilon and omega can be functions of (t,x)
// ; TODO More derivatives
// ; TODO More comutation methods
// ; TODO Algorithm to decide which method to use (an interpreter)
// ;  ∂u     ∂u     ∂²u
// ;  -- + υ -- = σ --- + f(u,t,x)
// ;  ∂t     ∂x     ∂x²
// ;; Initial value:
// ; u(0,x) = u⁰(x)
// ;; Boundary conditions:
// ; - 1st type
// ;       u(t,0) = ψ₁(t)
// ;       u(t,l) = ψ₂(t)
// ; - 2nd type
// ;       (∂u / ∂x) (t,0) = ψ₁(t)
// ;       (∂u / ∂x) (t,l) = ψ₂(t)
// ; - 3nd type
// ;       (∂u / ∂x) (t,0) = u * φ₁(t) + ψ₁(t)
// ;       (∂u / ∂x) (t,l) = u * φ₂(t) + ψ₂(t)
// ;
// ;;; Parameters:
// ; υ - <upsilon>
// ; σ - <sigma>
// ; f(u,t,x)
// ; u⁰(x)
// ; <Left boundary condition>
// ; <Right boundary condition>
// ; 
// If one of the parameters is not required, use NULL
// ;; Boundary conditions shall have the following format:
// ; '(NIL   ψ(t)) <-- 1st boundary condition
// ; '(φ(t)  ψ(t)) <-- 2nd boundary condition, where #'φ === (lambda (t) 0)
// ; '(φ(t)  ψ(t)) <-- 3rd boundary condition
// ; @note y is equivalent to t
// ; 


include_once("./Range.class.php");
include_once("./ModelExplicit.class.php");

// (defvar upsilon 0)
// (defvar sigma 1)
// (defun fun (u y x) (* 2 (1- y)))
// (defun initial-value (x) (sqr x))
// (defun left-boundary-condition (y) (list NIL (sqr y)))
// (defun right-boundary-condition (y) (list NIL (1+ (sqr y))))
$upsilon = 0;
$sigma = 1;
$fun = function($u, $t, $x) { return 2 * ($t - 1); };
$initial_value = function($x) { return $x * $x; };
$boundary_left_type = 1;
$boundary_left_phi = function($t) { return NULL; };
$boundary_left_psi = function($t) { return $t * $t; };
$boundary_right_type = 1;
$boundary_right_phi = function($t) { return NULL; };
$boundary_right_psi = function($t) { return 1 + $t * $t; };

$range_x = new Range(0, 1, 0.1);
$range_t = new Range(0, 1, 0.1);

$model = new ModelExplicit($upsilon, $sigma, $fun, $initial_value,
                        $boundary_left_type, $boundary_left_phi, $boundary_left_psi,
                        $boundary_right_type, $boundary_right_phi, $boundary_right_psi);
$model->compute($range_x, $range_t);
// print_r($model);
// $model->print();
