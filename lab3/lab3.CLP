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

(deffunction mcd (?num1 ?num2)
	;Calcula el máximo común divisor de los dos parámetros recibidos.

)

(deffunction mcm (?num1 ?num2)
	;Calcula el mínimo común múltiplo de los dos números recibidos.

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

)

(deffunction capicua (?num)
	;Devuelve TRUE en caso de que el número introducido sea capicúa, FALSE en caso contrario.

)

(deffunction num_primos_y_capicua (?num)
	;Devuelve TRUE en caso de que el número introducido sea primo y capicúa, FALSE en caso contrario.

)

(deffunction num_magico (?num1 ?num2)
	;Dado un número como parámetro, sumará todas sus cifras hasta que el resultado final sea de una sola cifra.

)

(deffunction esMedio (?num)
	;Dado un número como parámetro, devuelve TRUE si este es medio, FALSE en caso contrario.

)
