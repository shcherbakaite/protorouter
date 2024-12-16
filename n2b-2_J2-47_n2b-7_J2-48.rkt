#lang racket

; CAN B test

(apply-ground `J2-32) ; Ground the box

; Termination
(expect-resistance-eq `n2b-2 `n2b-7 120 5)
(expect-resistance-eq `UTSG-4 `UTSG-3 120 5)
(expect-resistance-eq `J2-47 `J2-48 120 5)

; CAN B H
(expect-resistance-lt `n2b-2 `UTSG-4 0.5)
(expect-resistance-lt `n2b-2 `J2-47 0.5)
(expect-resistance-lt `n2b-2 `UTSG-3 0.5)

; CAN B L
(expect-resistance-lt `n2b-7 `UTSG-3 0.5)
(expect-resistance-lt `n2b-7 `J2-47 0.5)
(expect-resistance-lt `n2b-7 `UTSG-48 0.5)

; CAN B to CAN A isolation
(expect-resistance-gt `n2b-2 `n1a-2 1000000)
(expect-resistance-gt `n2b-7 `n1a-7 1000000)

; CAN B to CAN C isolation
(expect-resistance-gt `n2b-2 `n4-2 1000000)
(expect-resistance-gt `n2b-7 `n4-7 1000000)

; CAN B to GND isolation
(expect-resistance-gt `n2b-2 `GND 1000000)
(expect-resistance-gt `n2b-7 `GND 1000000)
