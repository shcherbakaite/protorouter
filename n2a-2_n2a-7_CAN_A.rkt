#lang racket

; CAN A test

(apply-ground `J2-32) ; Ground the box

; Termination
(expect-resistance-eq `n2a-2 `n2a-7 120 5)
(expect-resistance-eq `J5a-9 `J5a-10 120 5)
(expect-resistance-eq `J20-A `J20-B 120 5)

; CAN A H
(expect-resistance-lt `n2a-2 `J5a-9 0.5)
(expect-resistance-lt `n2a-2 `J20-A 0.5)

; CAN A L
(expect-resistance-lt `n2a-7 `J5a-10 0.5)
(expect-resistance-lt `n2a-7 `J20-B 0.5)

; CAN A GND
(expect-resistance-lt `J20-C `GND 0.5)
(expect-resistance-lt `n2a-3 `GND 0.5)
(expect-resistance-lt `n2a-5 `GND 0.5)
(expect-resistance-lt `n2a-6 `GND 0.5)

; CAN A to GND isolation
(expect-resistance-gt `n2a-2 `GND 1000000)
(expect-resistance-gt `n2a-7 `GND 1000000)
