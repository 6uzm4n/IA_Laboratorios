;LABORATORIO 7-3 INTELIGENCIA ARTIFICIAL

;Dado un hecho con varios números, calcula el mayor de estos.

(deffunction maximoMulti ($?serie)
;Devuelve el elemento más grande del multicampo pasado como parámetro.
	(bind ?cont 1)
	(bind ?max -999999999)
	(while (<= ?cont (length$ ?serie))
		(if (< ?max (nth$ ?cont ?serie) )
			then
				(bind ?max (nth$ ?cont ?serie) )
		)
	(bind ?cont (+ ?cont 1))
	)
	(return ?max)
)

(defrule R0 "Error para cuando no se ha definido ningun hecho."
  (declare (salience 1))
=>
  (printout t "ERROR: No se ha inicializado ningun hecho (numeros $x)." crlf)
)

(defrule R1
	(declare (salience 5))
	(numeros $?multi)
 =>
	(printout t "El máximo es: " (maximoMulti $?multi) crlf)
	(halt)
)

