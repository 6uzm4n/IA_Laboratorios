;LABORATORIO 7-1 INTELIGENCIA ARTIFICIAL

;Dado un hecho con un número, realiza una cuenta atrás desde ese número.

(defrule R1 "Error para cuando no se ha definido ningun hecho."
	(declare (salience 1))
=>
	(printout t "ERROR: No se ha inicialidado un hecho (numero x)." crlf)
)

(defrule R2 "Elimina hecho al valer 0."
	(declare (salience 5))
  ?f <- (numero ?x)
=>
  (retract ?f)
  (halt)
)

(defrule R3 "Imprime el hecho y reduce su valor."
	(declare (salience 10))
  ?f <- (numero ?x)
  (test (> ?x 0))
=>
	(printout t ?x crlf)
  (assert (numero (- ?x 1)))
  (retract ?f)
)
