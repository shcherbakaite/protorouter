; CAN B test

(apply-ground `J2-32) ; Ground the box

; Termination
(expect-resistance-eq `n2b-2 `n2b-7 120 5)
(expect-resistance-eq `UTSG-4 `UTSG-3 120 5)
(expect-resistance-eq `J2-47 `J2-48 120 5)
(expect-resistance-eq `J5a-13 `J5a-14 120 5)

; CAN B H
(expect-resistance-lt `n2b-2 `UTSG-4 0.5)
(expect-resistance-lt `n2b-2 `J2-47 0.5)
(expect-resistance-lt `n2b-2 `UTSG-3 0.5)
(expect-resistance-lt `n2b-2 `J5a-13 0.5)

; CAN B L
(expect-resistance-lt `n2b-7 `UTSG-3 0.5)
(expect-resistance-lt `n2b-7 `J2-47 0.5)
(expect-resistance-lt `n2b-7 `UTSG-4 0.5)
(expect-resistance-lt `n2b-7 `J5a-14 0.5)

; CAN B GND
(expect-resistance-lt `n2b-3 `GND 0.5)
(expect-resistance-lt `n2b-5 `GND 0.5)
(expect-resistance-lt `n2b-6 `GND 0.5)

; CAN B to GND isolation
(expect-resistance-gt `n2b-2 `GND 1000000)
(expect-resistance-gt `n2b-7 `GND 1000000)
