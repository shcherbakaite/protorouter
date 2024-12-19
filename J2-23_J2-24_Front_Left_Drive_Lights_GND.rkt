
; DI_COM test
(apply-ground `J2-32)
(expect-resistance-lt `J2-23 `GND 0.5)
(expect-resistance-lt `J2-24 `GND 0.5)
(disconnect-all)