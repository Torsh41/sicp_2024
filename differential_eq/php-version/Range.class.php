<?php

class Range {
    private $start;
    private $end;
    private $step;
    private $count;

    public function start() { return $this->start; }
    public function end() { return $this->end; }
    public function step() { return $this->step; }
    public function count() { return $this->count; }
    
    public function __construct($start, $end, $step) {
        $this->start = $start;
        $this->end = $end;
        $this->step = $step;
        $this->count = 1 + floor(($end - $start) / $step);
    }
}
