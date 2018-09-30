;LABORATORIO 2 INTELIGENCIA ARTIFICIAL

;----------------------------------------

(deffunction todosNumeros ($?mult)
	;Devuelve TRUE si todos los campos son integer, si no FALSE
	(bind ?cont 1)
	(bind ?end 0)
	(if (= (length$ ?mult) 0)
		then
			(bind ?end 1)
	)
	(while (and (= ?end 0) (< ?cont (+ (length$ ?mult) 1) ) )
		(bind ?act (nth$ ?cont ?mult) )
		(if (not (integerp ?act) )
			then
				(bind ?end 1)
			else
				(bind ?cont (+ ?cont 1) )
		)
	)
	(if (= ?end 0)
		then
			(return TRUE)
		else
			(return FALSE)
	)
)



(deffunction isNumber (?in)
	(if (integerp ?in)
		then
			(return TRUE)
		else
			(printout t "Introduce un numero valido." crlf)
			(return FALSE)
	)
)

;------------------------------------------

(deffunction cuentaAtras (?num)
  ;Devuelve una cuenta atrás desde el número que se pasa como parámetro.
	(while (not(isNumber ?num))
		(bind ?num (read))
	)
	(bind ?cont ?num)
	(printout t " " crlf)
	(while (> ?cont 0)
		(printout t ?cont)
		(if (= (mod ?cont 10) 0)
			then
				(printout t " " crlf)
			else
				(printout t " ")
		)
		(bind ?cont (- ?cont 1))
	)
	(printout t " " crlf)

)

(deffunction hasta (?num)
  ;Devuelve una secuencia de números hasta el que se pasa como parámetro.
	(while (not(isNumber ?num))
		(bind ?num (read))
	)
		(bind ?cont 0)
		(printout t " " crlf)
		(while (< ?cont ?num)
			(printout t ?cont )
			(if (= (mod ?cont 10) 0)
			then
				(printout t " " crlf)
			else
				(printout t " ")
			)
			(bind ?cont (+ ?cont 1))
		)
		(printout t " " crlf)
)

(deffunction sumatorioN (?num)
  ;Calcula el sumatorio de número que se pase como parámetro y todos sus anteriores.

	(while (not(isNumber ?num))
		(bind ?num (read))
	)
	(bind ?result 0)
	(bind ?i 0)
	(loop-for-count (?i 0 ?num)
		(bind ?result (+ ?result ?i))
	)
	(printout t ?result crlf)
)

(deffunction sumatorioR (?num)
  ;Calcula el sumatorio de número que se pase como parámetro y todos sus anteriores.

	(while (not(isNumber ?num))
		(bind ?num (read))
	)

	(if (= ?num 1)
		then
			(return 1)
		else
			(return (+ (sumatorioR (- ?num 1)) ?num))
	)
)

(deffunction minimoMulti ($?serie)
  ;Devuelve el elemento más pequeño del multicampo pasado como parámetro.
  (if	(not(todosNumeros ?serie))
		then
			(printout t "No todos los elementos son numeros validos." crlf)

		else
			(bind ?cont 1)
			(bind ?min 999999999)
			(while (<= ?cont (length$ ?serie))
				(if (> ?min (nth$ ?cont ?serie) )
					then
						(bind ?min (nth$ ?cont ?serie) )
				)
			(bind ?cont (+ ?cont 1))
			)
			(printout t "Min -----> " ?min " <----" crlf)
	)
)



(deffunction maximoMulti ($?serie)
;Devuelve el elemento más grande del multicampo pasado como parámetro.
	(if	(not (todosNumeros ?serie))
		then
			(printout t "No todos los elementos son numeros validos." crlf)

		else
			(bind ?cont 1)
			(bind ?max -999999999)
			(while (<= ?cont (length$ ?serie))
				(if (< ?max (nth$ ?cont ?serie) )
					then
						(bind ?max (nth$ ?cont ?serie) )
				)
			(bind ?cont (+ ?cont 1))
			)
			(printout t "Max -----> " ?max " <----" crlf)
	)
)

(deffunction sumaMulti ($?mult)
  ;Calcula la suma de todos los elementos del multicampo pasado como parámetro.

	(if (not(todosNumeros ?mult))
		then
			(printout t "No todos los elementos son numeros validos." crlf )
		else
			(bind ?sum 0)
			(bind ?cont 1)
			(while (<= ?cont (length$ ?mult))
				(bind ?sum (+ ?sum (nth$ ?cont ?mult) ) )
				(bind ?cont (+ ?cont 1))

			)
			(return ?sum )
	)
)

(deffunction mediaMulti ($?mult)
	;Calcula la media de todos los elementos del multicampo pasado como parámetro.

	(if (todosNumeros ?mult)

		then
			(bind ?sum (sumaMulti ?mult) )
			(printout t "Media: " (/ ?sum (length$ ?mult) ) crlf)
		else
			(printout t "No todos los elementos son numeros validos." crlf )
	)
)

(deffunction switchin ( ?num $?serie)
	;Si el primer parámetro es 1, calcula el máximo de todos los elementos del multicampo pasado como parámetro.
	;Si el primer parámetro es 2, calcula el mínimo de todos los elementos del multicampo pasado como parámetro.
	(if	(not (todosNumeros ?serie))
		then
			(printout t "No todos los elementos son numeros validos." crlf)
		else
			(if (integerp ?num)
				then
					(if (= ?num 1)
						then
							(maximoMulti $?serie)
						else
							(if (= ?num 2)
								then
									(minimoMulti $?serie)
								else
								(printout t "La elección debe ser 1 o 2" crlf)
							)
					)
			)
	)
)

(deffunction multiplicarElemento ( ?num $?serie)
	;Dado un número y un elemento multicampo como parámetro, devuelve el multicampo tras multiplicar cada valor por el número dado.
  (if	(not (todosNumeros ?serie))
		then
			(printout t "No todos los elementos son numeros validos" crlf)

		else
			(if (integerp ?num)
				then
					(bind ?cont 1)
					(while (< ?cont (+ (length$ ?serie) 1) )
						(bind ?act (*(nth$ ?cont ?serie) ?num))
						(bind ?serie (replace$ ?serie ?cont ?cont ?act ))
						(bind ?cont (+ ?cont 1))
					)
					(printout t ?serie crlf)
			)
	)
)

(deffunction factorialN (?num)
  ;Devuelve el factorial del número pasado como parámetro.
	(bind ?result 1)
	(bind ?i 1)
  (loop-for-count (?i 1 ?num)
	 	(bind ?result (* ?result ?i))
  )
	(printout t ?result crlf)
)

(deffunction factorialR (?num)
  ;Devuelve el factorial del número pasado como parámetro.
	(if (<= ?num 1) then
		(return 1)
	else
		(return (* (factorialR (- ?num 1)) ?num))
	)
)

(deffunction fibonacciAux (?num)
  ;Dado un número como parámetro, devuelve el número en esa posición de la serie de Fibonacci.
	(if (<= ?num 0) then
		(return 0)
	else
		(if (= ?num 1) then
			(return 1)
		else
			(return (+ (fibonacciAux (- ?num 2)) (fibonacciAux (- ?num 1))))
		)
	)
)


(deffunction fibonacci (?num)
  ;Dado un número como parámetro, devuelve los primeros n números de la serie de Fibonacci.
	(bind $?result (create$))
	(bind ?i 1)
  (loop-for-count (?i 1 ?num)
	 	(bind $?result $?result (fibonacciAux ?i))
  )
	(printout t ?result crlf)
)
