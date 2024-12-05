#lang racket

; out_Relay_4_GndDrive_KSI_DO3, J2-1 test
(connect `n1-14 `24VDC)
(connect `AI0 `J2-1)
(enable `24VDC)
(expect "Applied 24V via n1-14 to Coil of Relay K4. Expected 48V on J2-1" (EQ-WITHIN `AI0 48 1))