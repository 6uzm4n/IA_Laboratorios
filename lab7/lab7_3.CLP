;LABORATORIO 7-3 INTELIGENCIA ARTIFICIAL

;Dado un hecho con varios números, calcula el mayor de estos.

(defrule mayor
	(declare (salience 5))
	(numeros $?multi)
 =>
	(printout t "El máximo es: " (maximoMulti $?multi) crlf)
)

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