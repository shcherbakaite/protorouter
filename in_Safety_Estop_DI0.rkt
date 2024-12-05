#lang racket

; in_Safety_Estop_DI0 test
(connect `J5a-18 `VDC24)
(connect `AI0 `n1-1)
(enable `24VDC)
(expect "Applied 24V to J5a-18. Expected 24V on n1-1." (eq-within `AI0 24 1))