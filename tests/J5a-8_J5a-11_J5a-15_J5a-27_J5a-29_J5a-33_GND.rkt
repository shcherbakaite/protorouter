(apply-ground `J2-32)     ; Ground

; GND 5V
(expect-resistance-lt `J5a-8 `GND 0.5)

; JOYSTICK SHIELD
(expect-resistance-lt `J5a-11 `GND 0.5)

; CAN A SHIELD
(expect-resistance-lt `J5a-15 `GND 0.5)

; STEER ELMO GND
(expect-resistance-lt `J5a-27 `GND 0.5)

; OP CONSOLE 24V RTN
(expect-resistance-lt `J5a-29 `GND 0.5)

; MICROPLEX 12V RTN
(expect-resistance-lt `J5a-33 `GND 0.5)
