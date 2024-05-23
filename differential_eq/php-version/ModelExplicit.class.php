<?php
include_once("./Model.class.php");
include_once("./Range.class.php");


Class ModelExplicit exteNDs Model {
    // (setf compute-lbc
    //       (funcall (lambda (phi)
    //                  (cond ((eq phi 'nil) (lambda (u phi psi) psi))
    //                        ((= phi 0) (lambda (u phi psi)
    //                                     (- u (* (range-step xr) psi))))
    //                        (t (lambda (u phi psi)
    //                             (/ (- u (* (range-step xr) psi))
    //                                (+ 1 (* (range-step xr) phi)))))))
    //                (car (funcall lbc (range-start tr)))))

    private $range_x;
    private $range_t;
    private $data;
    
    public function compute(Range $range_x, Range $range_t) {
        if (!$this->ok()) {
            echo "Oh no!\n";
            return;
        }
        // echo $range_x, $range_t;
        $this->range_x = $range_x;
        $this->range_t = $range_t;
        $this->data = array();
        $this->nth_loop();
    }
    public function print() {
        echo "Hello there!";
        print_r($this->data);
    }
    
    private function nth_loop() {
        $row = array();
        for ($i = 0; $i < $this->range_x->count(); ++$i) {
            $x = $this->compute_x($i);
            $row[$i] = ($this->initial)($x);
        }
        $this->data[0] = $row;
        
        print_r($this->data[0]);
        for ($n = 1; $n < $this->range_t->count(); $n++) {
            $row = array();
            
            // echo $n-1, "\n";
            // print_r($this->data[$n-1]);
            // TODO: something wrong with $this->data[$n-1]
            // Does incorrect computations
            for ($i = 1; $i < $this->range_x->count() - 1; $i++) {
                $row[$i] = $this->compute_next_row_element($this->data[$n-1], $n, $i);
            }
            echo " HERE ";
            $row[0] = $this->compute_boundary_left($n, $row);
            $row[$this->range_x->count() - 1] = $this->compute_boundary_right($n, $row);
            $this->data[$n] = $row;
            echo "END\n";
        }
    }
    
    private function compute_x($i) {
        return $this->range_x->start() + $i * $this->range_x->step();
    }
    private function compute_t($n) {
        return $this->range_t->start() + $n * $this->range_t->step();
    }
    private function compute_next_row_element($row, $n, $i) {
        $ul = $row[$i-1];
        $uc = $row[$i];
        $ur = $row[$i+1];
        $dt = $this->range_t->step();
        $dx = $this->range_x->step();
        $t = $this->compute_t($n - 1);
        $x = $this->compute_x($i);
        // echo $ul, $uc, $ur, $dt, $dx, $t, $x;
        // echo $ul, $uc, $ur;
        // echo "\n";
        // echo $dt, $dx;
        // echo "\n";
        // echo $t, $x;
        // echo "\n";
        // echo $this->upsilon, " ", $this->sigma;
        // echo ($this->fun)($uc, $t, $x);
        // echo "\n";
        return $uc + $dt * ($this->upsilon * ($ul - $uc) / $dx +
                            $this->sigma * ($ur - 2 * $uc + $ul) / ($dx * $dx) +
                            ($this->fun)($uc, $t, $x));
    // (setf compute-next-row-element
    //       (lambda (nth-row n i)
    //         (+ uc
    //            (/ (* upsilon dt (- ul uc))
    //               dx)
    //            (/ (* sigma dt (+ ur (* -2 uc) ul))
    //               (* dx dx))
    //            (* (funcall fun uc t x
    //               dt))))
    }
    private function compute_boundary_left($n, $row = NULL) {
        $u = $row[1];
        $t = $this->compute_t($n);
        $action = array(1 => function($u, $t) { return $this->boundary_condition_compute_left_1($t); },
                        2 => function($u, $t) { return $this->boundary_condition_compute_left_2($u, $t); },
                        3 => function($u, $t) { return $this->boundary_condition_compute_left_3($u, $t); });
        return ($action[$this->boundary_left_type])($u, $t);
    }
    private function compute_boundary_right($n, $row = NULL) {
        $u = $row[$this->range_x->count() - 2];
        $t = $this->compute_t($n);
        $action = array(1 => function($u, $t) { return $this->boundary_condition_compute_right_1($t); },
                        2 => function($u, $t) { return $this->boundary_condition_compute_right_2($u, $t); },
                        3 => function($u, $t) { return $this->boundary_condition_compute_right_3($u, $t); });
        return ($action[$this->boundary_right_type])($u, $t);
    }
    
}
