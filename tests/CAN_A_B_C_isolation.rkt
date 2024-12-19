; CAN A test

(apply-ground `J2-32) ; Ground the box

; CAN B to CAN A isolation
(expect-resistance-gt `n2b-2 `n2a-2 1000000)
(expect-resistance-gt `n2b-7 `n2a-7 1000000)

; CAN B to CAN C isolation
(expect-resistance-gt `n2a-2 `n4-2 1000000)
(expect-resistance-gt `n2a-7 `n4-7 1000000)

; CAN B to CAN A isolation
(expect-resistance-gt `n4-2 `n2a-2 1000000)
(expect-resistance-gt `n4-7 `n2a-7 1000000)