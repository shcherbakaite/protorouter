; CAN C test

(apply-ground `J2-32) ; Ground the box

; Termination
(expect-resistance-eq `n4-2 `n4-7 120 5)
(expect-resistance-eq `J30-A `J30-B 120 5)

; CAN C H
(expect-resistance-lt `n2a-2 `J30-A 0.5)

; CAN C L
(expect-resistance-lt `n4-7 `J30-B 0.5)

; CAN C J20 GND
(expect-resistance-lt `J30-C `GND 0.5)

; CAN A to GND isolation
(expect-resistance-gt `n4-2 `GND 1000000)
(expect-resistance-gt `n4-7 `GND 1000000)
