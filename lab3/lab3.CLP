;LABORATORIO 2 INTELIGENCIA ARTIFICIAL

-----------------------------------------------------------
;Funciones auxiliares

(deffunction isNumber(?var)
  ;Devuelve TRUE en caso de que el parámetro sea un número.
  (return (or (integerp ?var) (floatp ?var)))
)
-----------------------------------------------------------

;1
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
	(while (not(isNumber ?a))
		(printout t "Mete un numero para el primer parametro" crlf)
			(bind ?a (read))
	)
	(while (not(isNumber ?b))
		(printout t "Mete un numero para el segundo parametro" crlf)
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
		(printout t "Mete un numero que este entre los dos parametros" crlf)
		(bind ?num (read))
		(bind ?entre (entre ?opc ?a ?b ?num))
	)
	(printout t "Felicidades." crlf)
)

;2
(deffunction acertijo (?a ?b)
	;Después de recibir dos números como parámetros, eligirá un número en ese rango y le pedirá números al usuario hasta que lo acierte.

	(while (not(isNumber ?a))
		(printout t "Mete un numero para el primer parametro" crlf)
			(bind ?a (read))
	)
	(while (not(isNumber ?b))
		(printout t "Mete un numero para el segundo parametro" crlf)
			(bind ?b (read))
	)
	(bind ?opc 1)
	(if (< ?a ?b)
		then
			(bind ?opc 0)
			(bind ?rand (random ?a ?b))
		else
			(bind ?rand (random ?b ?a))
	)
	(bind ?num s)
	(bind ?entre FALSE)
	(bind ?iguales FALSE)

	(while (not ?iguales)
		(while (not ?entre)
			(printout t "Trate de adivinar el numero premiado entre los dos parametros" crlf)
			(bind ?num (read))
			(if (isNumber ?num)
				then
				(bind ?entre (entre ?opc ?a ?b ?num))
			)
		)
		(if (= ?rand ?num)
			then
				(bind ?iguales TRUE)
			else
				(bind ?entre FALSE)
				(printout t "Siga Jugando..." crlf)
		)
	)
	(printout t "Felicidades " crlf)
)

;3
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

;4
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


;5
(deffunction mes (?num)
	;Recibiendo un número como parámetro, devuelve cuántos días tiene el mes en esa posición.
  (if (and (integerp ?num) (<= ?num 12) (>= ?num 1)) then
    (if (= ?num 2) then
      (return 28)
    else
      (if (or (= ?num 4) (= ?num 6) (= ?num 9) (= ?num 11)) then
        (return 30)
      else
        (return 31)
      )
    )
  else
    (printout t "El valor introducido no es un mes valido." crlf)
  )
)


;6
(deffunction in (?num ?mult)
	;Devuelve True si ?num esta en ?mult, en caso contrario false.
	(bind ?i 1)
	(bind ?end FALSE)
	(while (and (<= ?i (length$ ?mult)) (not ?end))
		(if (eq ?num (nth$ ?i ?mult))
			then
				(bind ?end TRUE)
			else
				(bind ?i (+ ?i 1))
		)
	)
	(return ?end)
)

(deffunction diferencia (?mult1 ?mult2)
	;Recibiendo dos parámetros multicampo, devuelve los valores del primero que no estén en el segundo.
	(bind $?res (create$ ))
	(if (not(eq ?mult1 ?mult2))
		then
			(bind ?i 1)
			(while (<= ?i (length$ ?mult1))
				(bind ?cur (nth$ ?i ?mult1))
				(if (not(in ?cur ?mult2))
					then
						(bind ?res (insert$ ?res (+ (length$ mult2) 1) ?cur))
				)
				(bind ?i (+ ?i 1))
			)
	)
	(printout t "La diferencia entre ambos multicampos: " ?res crlf)
)

;7
(deffunction concatenacion (?mult1 ?mult2)
	;Recibiendo dos parámetros multicampo, devuelve la concatenación de estos.

	(bind ?res (insert$ ?mult1 (+ (length$ ?mult1) 1) ?mult2))
	(printout t "Resultado: " ?res crlf)
)

;8
(deffunction sustituir (?par1 ?par2 $?mult)
	;Recibiendo dos elementos simples y un elemento multicampo como parámetros,  sustituye las apariciones del primer elemento simple por el segundo.
	(bind ?i 1)
	(while (<= ?i (length$ ?mult))
		(if (eq ?par1 (nth$ ?i ?mult))
			then
				(bind ?mult (replace$ ?mult ?i ?i ?par2))
		)
		(bind ?i (+ ?i 1))
	)
	(printout t "El resultado es: " ?mult crlf)
)

;9
(deffunction cartesiano (?mult1 ?mult2)
;Dados dos elementos multicampo como parámetro, devuelve el producto cartesiano de estos.

)

;10
(deffunction escalar (?mult1 ?mult2)
	;Dados dos elementos multicampo como parámetro, devuelve el producto escalar de estos.

)

;11
(deffunction unico (?mult)
	;Dado un elemento multicampo como parámetro, devuelve TRUE si ningún elemento se repite, FALSE en caso contrario.
  (bind ?norep TRUE)
  (while (and (not (eq (first$ ?mult) (create$))) ?norep)
    (bind ?first (first$ ?mult))
    (bind ?mult (delete$ ?mult 1 1))
    (bind ?norep (not (member$ ?first ?mult)))
  )
  (return ?norep)
)

;12
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

;13
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

;14
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
