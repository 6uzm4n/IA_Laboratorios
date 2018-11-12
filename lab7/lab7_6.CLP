;LABORATORIO 7-6 INTELIGENCIA ARTIFICIAL

;Dado un hecho con varios números, devuelve un hecho con dichos números ordenados.

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

(deffunction ordenadosMulti ($?multi)
	(bind ?i (length$ ?multi))
	(bind ?cont 1)
	(bind ?ordenados (create$ ))
	(while (<= ?cont ?i)
		(bind ?max (maximoMulti ?multi))
		(bind ?pos (member$ ?max ?multi))
		(bind ?ordenados(insert$ ?ordenados 1 ?max))
		(bind ?multi (delete$ ?multi ?pos ?pos))
		(bind ?cont (+ ?cont 1))
	)
	(return ?ordenados)
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
	(printout t "El orden es: " (ordenadosMulti $?multi) crlf)
	(halt)
)


