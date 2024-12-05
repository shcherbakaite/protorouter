#lang racket

; in_AMS_KEY_DI3 test
(connect `J5a-20 `VDC24)
(connect `AI0 `n1-4)
(enable `24VDC)
(expect "Applied 24V to J5a-20. Expected 24V on n1-4." (EQ-WITHIN `AI0 24 1))