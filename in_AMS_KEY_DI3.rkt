#lang racket

; in_AMS_KEY_DI3 test
(connect `PS_RAIL1 `J5a-20 )
(connect `DMM_V_HI `n1-4)
(connect `DMM_LO `GND)
(enable `24VDC)
(expect "Applied 24V to J5a-20. Expected 24V on n1-4." (EQ-WITHIN `DMM_V 24 1))
(disable `24VDC)

; Alternative version using resistance 
(connect `DMM_LO `J5a-20 )
(connect `DMM_V_HI `n1-4)
(expect "Measured resistance from J5a-20 to n1-4. Expected < 0.5 Ohm." (LT `DMM_R 0.5))