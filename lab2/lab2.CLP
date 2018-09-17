;LABORATORIO 2 INTELIGENCIA ARTIFICIAL

(deffunction cuentaAtras (?num)
  ;Devuelve una cuenta atrás desde el número que se pasa como parámetro.
	(if (integerp ?num)
		then
			(bind ?cont ?num)
			(while (> ?cont 0)
				(printout t ?cont )
				(bind ?cont (- ?cont 1))
			)
			(printout t " " crlf)
		else
			(printout t "Mete un numero" crlf)
	)
)

(deffunction hasta (?num)
  ;Devuelve una secuencia de números hasta el que se pasa como parámetro.
  (if (integerp ?num)
		then
			(bind ?cont 0)
			(while (< ?cont ?num)
				(printout t ?cont )
				(bind ?cont (+ ?cont 1))
			)
			(printout t " " crlf)
		else
			(printout t "Mete un numero" crlf)
	)
)

(deffunction sumatorioN (?num)
  ;Calcula el sumatorio de número que se pase como parámetro y todos sus anteriores.
	(bind ?result 0)
	(bind ?i 0)
  (loop-for-count (?i 0 ?num)
	 	(bind ?result (+ ?result ?i))
  )
	(printout t ?result crlf)
)

(deffunction sumatorioR (?num)
  ;Calcula el sumatorio de número que se pase como parámetro y todos sus anteriores.
  (if (= ?num 1) then
    (return 1)
  else
    (return (+ (sumatorioR (- ?num 1)) ?num))
  )
)


;----------------------------------------

(deffunction todosNumeros ($?mult)
	;Devuelve TRUE si todos los campos son integer, si no FALSE
	(bind ?cont 1)
	(bind ?end 0)
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

;------------------------------------------


(deffunction minimoMulti ($?serie)
  ;Devuelve el elemento más pequeño del multicampo pasado como parámetro.
  (if	(not (todosNumeros ?serie))
		then
			(printout t "No todos los elementos son numeros!!" crlf)

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
			(printout t "Min----->" ?min "<----" crlf)
	)
)



(deffunction maximoMulti ($?serie)
;Devuelve el elemento más grande del multicampo pasado como parámetro.
	(if	(not (todosNumeros ?serie))
		then
			(printout t "No todos los elementos son numeros!!" crlf)

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
			(printout t "Max----->" ?max "<----" crlf)
	)
)

(deffunction sumaMulti ($?mult)
  ;Calcula la suma de todos los elementos del multicampo pasado como parámetro.

	(if (not(todosNumeros ?mult))
		then
			(printout t "Mete todo numeros e intenta otra vez" crlf )
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
			(return (/ ?sum (length$ ?mult) ) )
	)
)

(deffunction switchin (?num)
  ;Si el primer parámetro es 1, calcula el máximo de todos los elementos del multicampo pasado como parámetro.
  ;Si el primer parámetro es 2, calcula el mínimo de todos los elementos del multicampo pasado como parámetro.


)

(deffunction multiplicarElemento (?num)
  ;Dado un número y un elemento multicampo como parámetro, devuelve el multicampo tras multiplicar cada valor por el número dado.

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

(deffunction fibonacci (?num)
  ;Dado un número como parámetro, devuelve los primeros n números de la serie de Fibonacci.
	(bind $?result (create$))
	(bind ?i 1)
  (loop-for-count (?i 1 ?num)
	 	(bind $?result $?result (fibonacciAux ?i))
  )
	(printout t ?result crlf)
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
