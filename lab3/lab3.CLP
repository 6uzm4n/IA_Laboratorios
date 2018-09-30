;LABORATORIO 2 INTELIGENCIA ARTIFICIAL

-----------------------------------------------------------
;Funciones auxiliares

(deffunction isNumber(?var)
  ;Devuelve TRUE en caso de que el parámetro sea un número.
  (return (or (integerp ?var) (floatp ?var)))
)
-----------------------------------------------------------

(deffunction entre (?opc ?a ?b ?num)
	(switch ?opc
		(case 0 then
			(if (and (>= ?num ?a) (<= ?num ?b) )
				then

					(return TRUE)
				else
					(printout t ?num " no esta entre " ?a " y " ?b " " crlf)
					(return FALSE)
			)
		)
		(case 1 then

			(if (and (>= ?num ?b) (<= ?num ?a) )
				then
					(return TRUE)
				else
					(printout t ?num " no esta entre " ?b " y " ?a " " crlf)
					(return FALSE)
			)
		)
	)
)

(deffunction dentroDelRango (?a ?b)

	(while (not(integerp ?a))
		(printout t "Mete un núamero para el primer parámetro" crlf)
			(bind ?a (read))
	)
	(while (not(integerp ?b))
		(printout t "Mete un núamero para el segundo parámetro" crlf)
			(bind ?b (read))
	)
	(bind ?opc 1)
	(if (< ?a ?b)
		then
			(bind ?opc 0)
	)
	(bind ?num s)
	(bind ?entre FALSE)
	(while (not ?entre)
		(printout t "Mete un número que esté entre los dos parámetros" crlf)
		(bind ?num (read))
		(bind ?entre (entre ?opc ?a ?b ?num))
	)
	(printout t "Felicidades." crlf)
)

(deffunction acertijo (?num1 ?num2)
	;Después de recibir dos números como parámetros, eligirá un número en ese rango y le pedirá números al usuario hasta que lo acierte.

)

(deffunction mcd ( ?a ?b)
  	(if (integerp ?a)
		then
			(if (integerp ?b)
				then
					(if (= ?a ?b)
						then
							(printout t "mcd =" ?a crlf)
							(return ?a)
						else
							(if (< ?a ?b )
								then
									(mcd ?a(- ?b ?a))
								else
									(mcd (- ?a ?b) ?b)
							)
					)
				else
					(printout t "El elemento Nº2 no es válido" crlf)
			)
		else
			(printout t "El elemento Nº1 no es válido" crlf)
	)
)

(deffunction mcm (?a ?b)
	(if (integerp ?a)
		then
			(if (integerp ?b)
				then
					(bind ?sol (div (* ?a ?b) (mcd ?a ?b)))
					(printout t "mcm=" ?sol crlf)
				else
					(printout t "El elemento Nº2 no es válido" crlf)
			)
		else
			(printout t "El elemento Nº1 no es válido" crlf)
	)
)

(deffunction mes (?num)
	;Recibiendo un número como parámetro, devuelve cuántos días tiene el mes en esa posición.

)

(deffunction diferencia (?mult1 ?mult2)
	;Recibiendo dos parámetros multicampo, devuelve los valores del primero que no estén en el segundo.

)

(deffunction concatenacion (?mult1 ?mult2)
	;Recibiendo dos parámetros multicampo, devuelve la concatenación de estos.

)

(deffunction sustituir (?par1 ?par2 $?mult)
	;Recibiendo dos elementos simples y un elemento multicampo como parámetros,  sustituye las apariciones del primer elemento simple por el segundo.

)

(deffunction cartesiano (?mult1 ?mult2)
;Dados dos elementos multicampo como parámetro, devuelve el producto cartesiano de estos.

)

(deffunction escalar (?mult1 ?mult2)
	;Dados dos elementos multicampo como parámetro, devuelve el producto escalar de estos.

)

(deffunction unico (?mult)
	;Dado un elemento multicampo como parámetro, devuelve TRUE si ningún elemento se repite, FALSE en caso contrario.

)

(deffunction primo (?num)
	;Devuelve TRUE en caso de que el número introducido sea primo, FALSE en caso contrario.
  (if (isNumber ?num) then
    (bind ?i 2)
    (bind ?primo TRUE)
    (bind ?sqrt (sqrt ?num))
    (loop-for-count (?i 2 ?sqrt)
      (if (= (mod ?num ?i) 0) then
        (bind ?primo FALSE)
      )
    )
    return ?primo
  else
    (printout t "Los valores introducidos no son validos." crlf)
  )
)

(deffunction capicua (?num)
	;Devuelve TRUE en caso de que el número introducido sea capicúa, FALSE en caso contrario.
  (if (isNumber ?num) then
    (bind ?inv 0)
    (bind ?aux ?num)
    (while (not (= ?aux 0))
      (bind ?inv (+ (* ?inv 10) (mod ?aux 10)))
      (bind ?aux (div ?aux 10))
    )
    (return (= ?num ?inv))
  else
    (printout t "Los valores introducidos no son validos." crlf)
  )
)

(deffunction num_primos_y_capicua (?num)
	;Devuelve TRUE en caso de que el número introducido sea primo y capicúa, FALSE en caso contrario.
  (if (isNumber ?num) then
    (return (and (primo ?num) (capicua ?num)))
  else
    (printout t "Los valores introducidos no son validos." crlf)
  )
)

(deffunction num_magico (?num)
	;Dado un número como parámetro, sumará todas sus cifras hasta que el resultado final sea de una sola cifra.
  (if (isNumber ?num) then
    (bind ?magico 0)
    (bind ?aux ?num)
    (while (not (= ?aux 0))
      (bind ?magico (+ ?magico (mod ?aux 10)))
      (bind ?aux (div ?aux 10))
    )
    (if (>= ?magico 10) then
      (num_magico ?magico)
    else
      (return ?magico)
    )
  else
    (printout t "Los valores introducidos no son validos." crlf)
  )
)

(deffunction esMedio (?num)
	;Dado un número como parámetro, devuelve TRUE si este es medio, FALSE en caso contrario.
  (if (isNumber ?num) then
    (bind ?sum 0)
    (bind ?i 1)
    (bind ?aux ?num)
    (loop-for-count (?i 1 (- ?num 1))
      (bind ?sum (+ ?sum ?i))
    )
    (while (> ?sum 0)
      (bind ?aux (+ ?aux 1))
      (bind ?sum (- ?sum ?aux))
    )
    (return (= ?sum 0))
  else
    (printout t "Los valores introducidos no son validos." crlf)
  )
)

(deffunction esMedioOpt (?num)
  ;VERSIÓN OPTIMIZADA PARA NÚMEROS GRANDES, YA QUE CLIPS SE BLOQUEA FÁCILMENTE
  ;Dado un número como parámetro, devuelve TRUE si este es medio, FALSE en caso contrario.
  (if (isNumber ?num) then
    (bind ?sum 0)
    (bind ?i 1)
    (bind ?aux ?num)
    (loop-for-count (?i 1 (- ?num 1))
      (bind ?sum (+ ?sum ?i))
      (if (>= ?sum (+ 1 ?aux)) then
        (bind ?aux (+ ?aux 1))
        (bind ?sum (- ?sum ?aux))
      )
    )
    (return (= ?sum 0))
  else
    (printout t "Los valores introducidos no son validos." crlf)
  )
)

(deffunction lol ()
  (bind ?i 2)
  (loop-for-count (?i 1 100000)
    (if (esMedioOpt ?i) then
      (printout t ?i crlf)
    )
  )
)
