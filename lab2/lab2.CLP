;LABORATORIO 2 INTELIGENCIA ARTIFICIAL

(deffunction cuentaAtras (?num)
  ;Devuelve una cuenta atrás desde el número que se pasa como parámetro.

)

(deffunction hasta (?num)
  ;Devuelve una secuencia de números hasta el que se pasa como parámetro.

)

(deffunction sumatorio (?num)
  ;Calcula el sumatorio de número que se pase como parámetro y todos sus anteriores.
  (if (= ?num 1) then
    (return 1)
  else
    (return (+ (sumatorio (- ?num 1)) ?num))
  )
)

(deffunction minimoMulti (?num)
  ;Devuelve el elemento más pequeño del multicampo pasado como parámetro.

)

(deffunction maximoMulti (?num)
;Devuelve el elemento más grande del multicampo pasado como parámetro.

)

(deffunction sumaMulti (?num)
  ;Calcula la suma de todos los elementos del multicampo pasado como parámetro.

)

(deffunction mediaMulti (?num)
;Calcula la media de todos los elementos del multicampo pasado como parámetro.

)

(deffunction switchin (?num)
  ;Si el primer parámetro es 1, calcula el máximo de todos los elementos del multicampo pasado como parámetro.
  ;Si el primer parámetro es 2, calcula el mínimo de todos los elementos del multicampo pasado como parámetro.


)

(deffunction multiplicarElemento (?num)
  ;Dado un número y un elemento multicampo como parámetro, devuelve el multicampo tras multiplicar cada valor por el número dado.

)

(deffunction factorial (?num)
  ;Devuelve el factorial del número pasado como parámetro.

)

(deffunction fibonacci (?num)
  ;Dado un número como parámetro, devuelve los primeros n números de la serie de Fibonacci.

)
