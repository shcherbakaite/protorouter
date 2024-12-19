
; DI_COM test
(apply-ground `J2-32)
(expect-resistance-lt `J2-30 `GND 0.5)
(disconnect-all)