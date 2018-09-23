;LABORATORIO 1 INTELIGENCIA ARTIFICIAL

-----------------------------------------------------------
;Funciones auxiliares

(deffunction isNumber(?var)
  ;Devuelve TRUE en caso de que el parámetro sea un número.
  (return (or (integerp ?var) (floatp ?var)))
)
-----------------------------------------------------------


(deffunction suma (?sum1 ?sum2)
  ;Devuelve el resultado de la suma de dos números
  (if (and (isNumber ?sum1) (isNumber ?sum2)) then
    (bind ?var_suma (+ ?sum1 ?sum2))
    (printout t "La suma de " ?sum1 " y " ?sum2 " es " ?var_suma crlf)
  else
    (printout t "Los valores introducidos no son validos." crlf)
  )
)

(deffunction signo (?num)
  ;Devuelve 1 si el número introducido es positivo, -1 si es negativo y 0 si es 0.
  (if (isNumber ?num) then
    (if (> ?num 0)
      then (return 1)
    else
      (if (< ?num 0) then
        (return -1)
      else
        (return 0)
      )
    )
  else
    (printout t "Los valores introducidos no son validos." crlf)
  )
)

(deffunction minimoSimple (?num1 ?num2)
  ;Dados dos números como parámetros, devuelve el menor.
  (if (and (isNumber ?num1) (isNumber ?num2)) then
    (if (> ?num1 ?num2) then
      (return ?num2)
    else
      (return ?num1)
    )
  else
    (printout t "Los valores introducidos no son validos." crlf)
  )
)

(deffunction maximoSimple (?num1 ?num2)
  ;Dados dos números como parámetros, devuelve el mayor
  (if (and (isNumber ?num1) (isNumber ?num2)) then
    (if (> ?num1 ?num2) then
      (return ?num1)
    else
      (return ?num1)
    )
  else
    (printout t "Los valores introducidos no son validos." crlf)
  )
)

(deffunction iguales (?num1 ?num2)
  ;Dados dos números como parámetros, devuelve TRUE si son iguales y FALSE si no.
  (if (and (isNumber ?num1) (isNumber ?num2)) then
    (return (= ?num1 ?num2))
  else
    (printout t "Los valores introducidos no son validos." crlf)
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
  (return (or (eq si ?simbolo) (eq s ?simbolo)))
)

(deffunction ciertoTeclado ()
  ;Tras pedir un símbolo por pantalla, devuelve TRUE si es "s" o "si" y FALSE si no.
  (printout t "Introduce \"s\" o \"si\"" crlf)
  (bind ?simbolo (read))
  (cierto ?simbolo)
)
