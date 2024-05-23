<?php
include_once("./Range.class.php");

abstract class Model {
    protected $upsilon;             // double;
    protected $sigma;               // double;
    protected $fun;                 // function(u, t, x) double;
    protected $initial;             // function(x) double;
    protected $boundary_left_type;  // int;
    protected $boundary_right_type; // int;
    private $boundary_left_phi;     // function(t) double;
    private $boundary_left_psi;     // function(t) double;
    private $boundary_right_phi;    // function(t) double;
    private $boundary_right_psi;    // function(t) double;

    private $ok = true;

    private const BOUNDARY_CONDITION_TYPES = array(1, 2, 3);

    
    abstract protected function compute(Range $range_x, Range $range_y);
    
    public function __construct($ups, $sig, $f, $init,
                                $lb_type, $lb_phi, $lb_psi,
                                $rb_type, $rb_phi, $rb_psi) {
        $this->upsilon = $ups ?? 0;
        $this->sigma = $sig ?? 0;
        $this->fun = $f;
        $this->initial = $init;
        $this->boundary_left_type = $lb_type;
        $this->boundary_left_phi = $lb_phi;
        $this->boundary_left_psi = $lb_psi;
        $this->boundary_right_type = $rb_type;
        $this->boundary_right_phi = $rb_phi;
        $this->boundary_right_psi = $rb_psi;
        if (!in_array($lb_type, self::BOUNDARY_CONDITION_TYPES) ||
            !in_array($rb_type, self::BOUNDARY_CONDITION_TYPES)) {
            $this->ok = false;
        }
    }
    protected function boundary_condition_compute_left_1($t) {
        return ($this->boundary_left_psi)($t);
    }
    protected function boundary_condition_compute_left_2($u, $t) {
        return $u - $this->range_x->step() * ($this->boundary_left_phi)($t);
    }
    protected function boundary_condition_compute_left_3($u, $t) {
        return ($u - $this->range_x->step() * ($this->boundary_left_psi)($t)) /
                (1 + $this->range_x->step() * ($this->boundary_left_phi)($t));
    }
    protected function boundary_condition_compute_right_1($t) {
        return ($this->boundary_left_psi)($t);
    }
    protected function boundary_condition_compute_right_2($t) {
        return $u + $this->range_x->step() * ($this->boundary_left_phi)($t);
    }
    protected function boundary_condition_compute_right_3($t) {
        return ($u + $this->range_x->step() * ($this->boundary_left_psi)($t)) /
                (1 - $this->range_x->step() * ($this->boundary_left_phi)($t));
    }
    
    public function ok() { return $this->ok; }
    private function default_f($u, $t, $x) {
        return 0;
    }
    private function default_initial($x) {
        return 0;
    }
    private function default_boundary_left($t) {
        return 0;
    }
    private function default_boundary_right($t) {
        return 0;
    }

}
