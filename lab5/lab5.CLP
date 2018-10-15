;LABORATORIO 4 INTELIGENCIA ARTIFICIAL

;Estado inicial
(defglobal ?*estadoI* = "FALSE FALSE FALSE FALSE")
;Estado final
(defglobal ?*estadoF* = "TRUE TRUE TRUE TRUE")
;Estados visitados
(defglobal ?*estadosV* = (create$))
;Camino recorrido (A=aspirar, I=moverse izquierda, D=moverse derecha)
(defglobal ?*camino* = (create$ ""))
;Estados prohibidos
(defglobal ?*estadosP* = (create$ "TRUE FALSE FALSE TRUE" "FALSE TRUE TRUE FALSE" "TRUE TRUE FALSE FALSE" "FALSE FALSE TRUE TRUE" "TRUE FALSE FALSE FALSE" "FALSE TRUE TRUE TRUE"))


(deffunction moverG (?estado)
  ;El granjero cambia de posición.
  (switch (getGranjero ?estado)
    (case FALSE then
      (return (implode$ (replace$ (explode$ ?estado) 1 1 TRUE)))
    )
    (case TRUE then
      (return (implode$ (replace$ (explode$ ?estado) 1 1 FALSE)))
    )
  )
)

(deffunction moverL (?estado)
  ;En caso de ser posible, el granjero cambia de posición la lechuga.
  (if (eq (getGranjero ?estado) (getLechuga ?estado)) then
    (switch (getGranjero ?estado)
      (case FALSE then
        (return (implode$ (replace$ (explode$ (moverG ?estado)) 2 2 TRUE)))
      )
      (case TRUE then
        (return (implode$ (replace$ (explode$ (moverG ?estado)) 2 2 FALSE)))
      )
    )
  else
    (return FALSE)
  )
)

(deffunction moverC (?estado)
  ;En caso de ser posible, el granjero cambia de posición la cabra.
  (if (eq (getGranjero ?estado) (getCabra ?estado)) then
    (switch (getGranjero ?estado)
      (case FALSE then
        (return (implode$ (replace$ (explode$ (moverG ?estado)) 3 3 TRUE)))
      )
      (case TRUE then
        (return (implode$ (replace$ (explode$ (moverG ?estado)) 3 3 FALSE)))
      )
    )
  else
    (return FALSE)
  )
)

(deffunction moverP (?estado)
  ;En caso de ser posible, el granjero cambia de posición el puma.
  (if (eq (getGranjero ?estado) (getPuma ?estado)) then
    (switch (getGranjero ?estado)
      (case FALSE then
        (return (implode$ (replace$ (explode$ (moverG ?estado)) 4 4 TRUE)))
      )
      (case TRUE then
        (return (implode$ (replace$ (explode$ (moverG ?estado)) 4 4 FALSE)))
      )
    )
  else
    (return FALSE)
  )
)

(deffunction getGranjero (?estado)
  ;Devuelve la posición del granjero.
  (return (nth$ 1 (explode$ ?estado)))
)

(deffunction getLechuga (?estado)
  ;Devuelve la posición de la lechuga.
  (return (nth$ 2 (explode$ ?estado)))
)

(deffunction getCabra (?estado)
  ;Devuelve la posición de la cabra.
  (return (nth$ 3 (explode$ ?estado)))
)

(deffunction getPuma (?estado)
  ;Devuelve la posición del puma.
  (return (nth$ 4 (explode$ ?estado)))
)

(deffunction finalizado (?estado)
  ;Checkea si el estado recibido como parámetro es un estado final.
  (if (eq ?estado ?*estadoF*) then
    (return TRUE)
  else
    (return FALSE)
  )
)

(deffunction prohibido (?estado)
  ;Checkea si el estado recibido como parámetro es un estado prohibido.
  (if (member$ ?estado ?*estadosP*) then
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
  ;Añade el parámetro simple al final del parámetro multicampo.
  (return (insert$ ?multicampo (+ 1 (length$ ?multicampo)) ?simple))
)

(deffunction append2 (?multicampo ?simple)
  ;Añade el parámetro simple en la segunda posición del parámetro multicampo.
  (return (insert$ ?multicampo 2 ?simple))
)

(deffunction start ()

  ;MÉTODO PRINCIPAL
  ;Funcionamiento:
  ;Se crean dos multicampos que corresponden al árbol de estados y a un árbol paralelo que
  ;representa el camino que se ha recorrido para llegar a cada estado. Por ejemplo:
  ; Árbol:    (FALSE FALSE TRUE FALSE)  (FALSE TRUE FALSE FALSE)
  ; Estados:  (CG)                      (LG)
  ;Según lo anterior, para llegar al estado (FALSE FALSE TRUE FALSE) hemos recorrido el camino cabra-granjero.
  ;Del mismo modo, para llegar al estado (FALSE TRUE FALSE FALSE) hemos recorrido el camino lechuga-granjero.
  ;
  ;Siempre que se actue sobre un estado o se elimine, se actuará sobre su paralelo. Así mismo,
  ;cuando se añadan estados nuevos en base a un estado, se usara su camino para crear el camino
  ;que lleva al nuevo estado. Por ejemplo:
  ; (FALSE FALSE TRUE FALSE)(CG) + L = (TRUE TRUE TRUE FALSE)(CGL)
  ;
  ;El algoritmo utilizado es Depth-First-Search (busqueda en profundidad)

  (bind ?arbol (create$ ?*estadoI*))
  (bind ?*estadosV* (append ?*estadosV* ?*estadoI*))
  (while (not (finalizado (nth$ 1 ?arbol)))
    (printout t ?arbol crlf)
    (bind ?actual (nth$ 1 ?arbol))
    ;Probamos a mover granjero.
    (bind ?aux (moverG ?actual))
    (if (not (or (eq FALSE ?aux) (visitado ?aux) (prohibido ?aux))) then
      (bind ?arbol (append2 ?arbol ?aux))
      (bind ?*estadosV* (append ?*estadosV* ?aux))
      (bind ?*camino* (append2 ?*camino* (str-cat (nth$ 1 ?*camino*) G)))
    )
    ;Probamos a mover lechuga.
    (bind ?aux (moverL ?actual))
    (if (not (or (eq FALSE ?aux) (visitado ?aux) (prohibido ?aux))) then
      (bind ?arbol (append2 ?arbol ?aux))
      (bind ?*estadosV* (append ?*estadosV* ?aux))
      (bind ?*camino* (append2 ?*camino* (str-cat (nth$ 1 ?*camino*) L)))
    )
    ;Probamos a mover cabra.
    (bind ?aux (moverC ?actual))
    (if (not (or (eq FALSE ?aux) (visitado ?aux) (prohibido ?aux))) then
      (bind ?arbol (append2 ?arbol ?aux))
      (bind ?*estadosV* (append ?*estadosV* ?aux))
      (bind ?*camino* (append2 ?*camino* (str-cat (nth$ 1 ?*camino*) C)))
    )
    ;Probamos a mover puma.
    (bind ?aux (moverP ?actual))
    (if (not (or (eq FALSE ?aux) (visitado ?aux) (prohibido ?aux))) then
      (bind ?arbol (append2 ?arbol ?aux))
      (bind ?*estadosV* (append ?*estadosV* ?aux))
      (bind ?*camino* (append2 ?*camino* (str-cat (nth$ 1 ?*camino*) P)))
    )
    ;Eliminamos primera posición del arbol de estados y del de caminos.
    (bind ?arbol (delete$ ?arbol 1 1))
    (bind ?*camino* (delete$ ?*camino* 1 1))
  )

  (printout t "Se ha llegado desde el estado inicial (" ?*estadoI* ") al estado final (" (nth$ 1 ?arbol) ") por el camino " (nth$ 1 ?*camino*) "." crlf)
)
