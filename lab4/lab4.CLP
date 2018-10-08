;LABORATORIO 4 INTELIGENCIA ARTIFICIAL

;Para iniciar el programa utilizar el comando: (start)

;El espacio de estados se definirá como un múlticampo con 3 campos, todos binarios:
; 1- posición de la aspiradora (0: izquierda/1: derecha)
; 2- estado de la habitación izquierda (0: limpia/1: sucia)
; 3- estado de la habitación derecha (0: limpia/1: sucia)

;Las instrucciones para el camino que lleva a una solución se representan mediante:
; A- Aspirar la habitación en la que se encuentra la aspiradora.
; I- La aspiradora se mueve hacia la izquierda.
; D- La aspiradora se mueve hacia la derecha.

;Estado inicial
(defglobal ?*estadoI* = "0 0 0")
;Estados finales
(defglobal ?*estadoF* = (create$ "0 0 0" "1 0 0"))
;Estados visitados
(defglobal ?*estadosV* = (create$))
;Camino recorrido (A=aspirar, I=moverse izquierda, D=moverse derecha)
(defglobal ?*camino* = (create$ ""))

(deffunction moverseI (?estado)
  ;La aspiradora se mueve hacia la derecha.
  (return (implode$ (replace$ (explode$ ?estado) 1 1 0)))
)

(deffunction moverseD (?estado)
  ;La aspiradora se mueve hacia la izquierda.
  (return (implode$ (replace$ (explode$ ?estado) 1 1 1)))
)

(deffunction getAspiradora (?estado)
  ;Devuelve la posición de la aspiradora.
  (return (nth$ 1 (explode$ ?estado)))
)

(deffunction aspirar (?estado)
  ;La aspiradora limpia la habitación en la que se encuentra.
  (switch (getAspiradora ?estado)
    (case 0 then
      (return (implode$ (replace$ (explode$ ?estado) 2 2 0)))
    )
    (case 1 then
      (return (implode$ (replace$ (explode$ ?estado) 3 3 0)))
    )
  )
)

(deffunction finalizado (?estado)
  ;Checkea si el estado recibido como parámetro es un estado final.
  (if (member$ ?estado ?*estadoF*) then
    (return TRUE)
  else
    (return FALSE)
  )
)

(deffunction visitado (?estado)
  ;Checkea si el estado recibido como parámetro ya ha sido visitado.
  (if (member$ ?estado ?*estadosV*) then
    (return TRUE)
  else
    (return FALSE)
  )
)

(deffunction append (?multicampo ?simple)
  ;Añade el parámetro simple al final del parámetro multicampo
  (return (insert$ ?multicampo (+ 1 (length$ ?multicampo)) ?simple))
)

(deffunction readBit ()
  ;Pide un valor de 0 o 1 hasta que lo recibe y lo devuelve.
  (bind ?fin FALSE)
  (while (not ?fin)
    (bind ?bit (read))
    (bind ?fin (or (eq 0 ?bit) (eq 1 ?bit)))
    (if (not ?fin) then
      (printout t "Introduce un valor correcto" crlf)
    )
  )
  (return ?bit)
)


(deffunction initialize ()
  ;Reseteamos valores por defecto.
  (bind ?*estadosV* (create$))
  (bind ?*camino* (create$ ""))
  ;Definimos el estado inicial.
  (printout t "¿En que habitacion se encuentra la aspiradora? 0:Izquierda / 1:Derecha" crlf)
  (bind ?aspiradora (readBit))
  (printout t "¿En que estado se encuentra la habitacion izquierda? 0:Limpia / 1:Sucia" crlf)
  (bind ?habitacionI (readBit))
  (printout t "¿En que estado se encuentra la habitacion derecha? 0:Limpia / 1:Sucia" crlf)
  (bind ?habitacionD (readBit))
  (bind ?*estadoI* (implode$ (create$ ?aspiradora ?habitacionI ?habitacionD)))
)

(deffunction start ()

  (initialize)

  ;MÉTODO PRINCIPAL
  ;Funcionamiento:
  ;Se crean dos multicampos que corresponden al arbol de estados y a un arbol paralelo que
  ;representa el camino que se ha recorrido para llegar a cada estado. Por ejemplo:
  ; Arbol:    (1 0 1) (1 1 1)
  ; Estados:  (AD)    (ID)
  ;Según lo anterior, para llegar al estado (1 0 1) hemos recorrido el camino Aspirar-derecha.
  ;Del mismo modo, para llegar al estado (1 1 1) hemos recorrido el camino Izquierda-derecha
  ;
  ;Siempre que se actue sobre un estado o se elimine, se actuará sobre su paralelo. Así mismo,
  ;cuando se añadan estados nuevos en base a un estado, se usara su camino para crear el camino
  ;que lleva al nuevo estado. Por ejemplo:
  ; (0 0 1)(IA) + D = (1 0 1)(IAD)
  ;
  ;El algoritmo utilizado es Breadth-First-Search (busqueda en anchura)

  (bind ?arbol (create$ ?*estadoI*))
  (bind ?*estadosV* (append ?*estadosV* ?*estadoI*))
  (while (not (finalizado (nth$ 1 ?arbol)))
    (printout t ?arbol crlf)
    (bind ?actual (nth$ 1 ?arbol))
    ;Probamos a aspirar.
    (bind ?aux (aspirar ?actual))
    (if (not (visitado ?aux)) then
      (bind ?arbol (append ?arbol ?aux))
      (bind ?*estadosV* (append ?*estadosV* ?aux))
      (bind ?*camino* (append ?*camino* (str-cat (nth$ 1 ?*camino*) A)))
    )
    ;Probamos a ir a la izquierda.
    (bind ?aux (moverseI ?actual))
    (if (not (visitado ?aux)) then
      (bind ?arbol (append ?arbol ?aux))
      (bind ?*estadosV* (append ?*estadosV* ?aux))
      (bind ?*estadosV* (append ?*estadosV* ?aux))
      (bind ?*camino* (append ?*camino* (str-cat (nth$ 1 ?*camino*) I)))
    )
    ;Probamos a ir a la derecha.
    (bind ?aux (moverseD ?actual))
    (if (not (visitado ?aux)) then
      (bind ?arbol (append ?arbol ?aux))
      (bind ?*estadosV* (append ?*estadosV* ?aux))
      (bind ?*camino* (append ?*camino* (str-cat (nth$ 1 ?*camino*) D)))
    )
    ;Eliminamos primera posición del arbol de estados y del de caminos.
    (bind ?arbol (delete$ ?arbol 1 1))
    (bind ?*camino* (delete$ ?*camino* 1 1))
  )

  (printout t "Se ha llegado desde el estado inicial (" ?*estadoI* ") al estado final (" (nth$ 1 ?arbol) ") por el camino " (nth$ 1 ?*camino*) "." crlf)
)
