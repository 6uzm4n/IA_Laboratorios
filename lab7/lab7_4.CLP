;LABORATORIO 7-4 INTELIGENCIA ARTIFICIAL

;Tras pedir un número por pantalla, realiza el sumatorio desde 0 a ese número.

(defrule R1 "Crea un hecho sumatorio."
	(declare (salience 5))
=>
  (assert (sumatorio 0))
)

(defrule R2 "Pide por pantalla un numero."
	(declare (salience 5))
=>
  (printout t "Introduce un número:" crlf)
  (bind ?aux (read))
  (assert (numero ?aux))
)

(defrule R3 "Suma el hecho y reduce su valor."
	(declare (salience 15))
  ?n <- (numero ?x)
  ?s <- (sumatorio ?y)
=>
  (assert (sumatorio (+ ?x ?y)))
  (retract ?s)
  (assert (numero (- ?x 1)))
  (retract ?n)
)

(defrule R4 "Finaliza el programa."
	(declare (salience 20))
  ?n <- (numero ?x)
  ?s <- (sumatorio ?y)
  (test (= ?x 0))
=>
	(printout t "El sumatorio es: " ?y crlf)
  (retract ?n)
  (retract ?s)
  (halt)
)
