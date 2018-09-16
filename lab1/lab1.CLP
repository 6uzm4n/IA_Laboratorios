;LABORATORIO 1 INTELIGENCIA ARTIFICIAL

(deffunction suma (?sum1 ?sum2)
  ;Devuelve el resultado de la suma de dos números
  (bind ?var_suma (+ ?sum1 ?sum2))
  (printout t "La suma de " ?sum1 " y " ?sum2 " es " ?var_suma crlf)
)

(deffunction signo (?num)
  ;Devuelve 1 si el número introducido es positivo, -1 si es negativo y 0 si es 0.
  (if (> ?num 0)
    then (printout t 1 crlf)
    else (
      if (< ?num 0)
      then (printout t -1 crlf)
      else (printout t 0 crlf)
    )
  )
)

(deffunction minimoSimple (?num1 ?num2)
  ;Dados dos números como parámetros, devuelve el menor.
  (return (min ?a ?b))

)

(deffunction maximoSimple (?num1 ?num2)
  ;Dados dos números como parámetros, devuelve el mayor.
  (return (max ?a ?b))
)

(deffunction iguales (?num1 ?num2)
  ;Dados dos números como parámetros, devuelve TRUE si son iguales y FALSE si no.
  (if (= ?num1 ?num2)
    then (printout t "TRUE" crlf)
    else (printout t "FALSE" crlf)
  )
)

(deffunction colores (?color)
  ;Dado un color como parámetro, devuelve su significado en un semáforo.
  (switch ?color
    (case verde then (printout t "Puedes pasar" crlf))
    (case rojo then (printout t "No puedes pasar" crlf))
    (case amarillo then (printout t "Parate por seguridad" crlf))
  )
)

(deffunction cierto (?simbolo)
  ;Dado un símbolo como parámetro, devuelve TRUE si es "s" o "si" y FALSE si no.
  (if (or (eq si ?simbolo) (eq s ?simbolo))
    then (printout t "TRUE" crlf)
    else (printout t "FALSE" crlf)
  )
)

(deffunction ciertoTeclado ()
  ;Tras pedir un símbolo por pantalla, devuelve TRUE si es "s" o "si" y FALSE si no.
  (printout t "Introduce \"s\" o \"si\"" crlf)
  (bind ?simbolo (read))
  (if (or (eq si ?simbolo) (eq s ?simbolo))
    then (printout t "TRUE" crlf)
    else (printout t "FALSE" crlf)
  )
)
