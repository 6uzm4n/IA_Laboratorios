;LABORATORIO 7-2 INTELIGENCIA ARTIFICIAL

;Dados diferentes hechos que contengan números, calcula cuál es el más grande.

(defrule R1 "Error para cuando no se ha definido ningun hecho."
	(declare (salience 1))
=>
	(printout t "ERROR: No se ha inicialidado ningun hecho (numero x)." crlf)
)

(defrule R2 "Imprime por pantalla el hecho final."
	(declare (salience 5))
  ?f <- (numero ?x)
=>
  (printout t "El mayor es: " ?x crlf)
  (retract ?f)
  (halt)
)

(defrule R3 "Elimina el hecho menor."
	(declare (salience 10))
  ?f <- (numero ?x)
  ?g <- (numero ?y)
  (test (> ?x ?y))
=>
  (retract ?g)
)

(defrule R4 "Elimina el hecho menor."
	(declare (salience 10))
  ?f <- (numero ?x)
  ?g <- (numero ?y)
  (test (< ?x ?y))
=>
  (retract ?f)
)
