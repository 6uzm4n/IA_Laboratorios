;LABORATORIO 7-5 INTELIGENCIA ARTIFICIAL

;Dado un hecho con un número, calcula el factorial de ese número.

(defrule R0 "Error para cuando no se ha definido ningun hecho."
  (declare (salience 1))
=>
  (printout t "ERROR: No se ha inicializado ningun hecho (numero x)." crlf)
)

(defrule R1 "Crea un hecho factorial."
  (declare (salience 5))
=>
  (assert (factorial 1))
)

(defrule R2 "Multiplica el hecho y reduce su valor."
  (declare (salience 15))
  ?n <- (numero ?x)
  ?f <- (factorial ?y)
=>
  (assert (factorial (* ?x ?y)))
  (retract ?f)
  (assert (numero (- ?x 1)))
  (retract ?n)
)

(defrule R3 "Finaliza el programa."
  (declare (salience 20))
  ?n <- (numero ?x)
  ?f <- (factorial ?y)
  (test (= ?x 1))
=>
  (printout t "El factorial es: " ?y crlf)
  (retract ?n)
  (retract ?f)
  (halt)
)
