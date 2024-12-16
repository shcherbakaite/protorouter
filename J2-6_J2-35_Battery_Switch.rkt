#lang racket
(prompt "Turn the switch OFF and press continue." 10000)
(expect "Expected open circuit between J2-35 and J2-6 with SWITCH OFF." (> (resistance `J2-6 `J2-35) 1000000))
(prompt "Turn the switch ON and press continue." 10000)
(expect "Expected connection J2-6 to J2-35 with SWITCH ON." (< (resistance `J2-6 `J2-35) 0.5))