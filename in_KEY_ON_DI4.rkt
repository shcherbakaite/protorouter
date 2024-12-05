#lang racket

; in_KEY_ON_DI4 test
(connect `J5a-19 `VDC24)
(connect `AI0 `n1-5)
(enable `24VDC)
(expect "Applied 24V to J5a-19. Expected 24V on n1-5" (EQ-WITHIN `AI0 24 1))