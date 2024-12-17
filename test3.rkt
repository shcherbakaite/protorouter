#lang racket

(require "connections.rkt")

(require "power-supply.rkt")

(connect `GND `J2-1)

(connect `GND `J2-1)

(connect `J2-1 `GND)

(connect `J2-2 `GND)

(connect `J5a-1 `GND)

(apply-voltage `J2-5 10)

connections