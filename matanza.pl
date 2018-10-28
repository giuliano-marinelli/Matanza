%flechas
% http://xahlee.info/comp/unicode_arrows.html
% â†‘ â†“ â†’ â†? â†— â†– â†˜ â†™
% â¬† â¬‡ â®• â¬… â¬ˆ â¬‰ â¬Š â¬‹
% ? ? ? ? ? ? ? ?
% â­¡ â­£ â­¢ â­  â­¦ â­§ â­¨ â­©
% ? ? ? ? ? ? ? ?
% ? ? ? ? ? ? ? ?

% â¬† â¬‡ â®• â¬… â¬‰ â¬ˆ â¬Š â¬‹
% â‡§ â‡© â‡¨ â‡¦ â¬? â¬€ â¬‚ â¬ƒ

% â†– â†‘ â†—
% â†? â—‹ â†’
% â†™ â†“ â†˜

% â¬‰ â¬† â¬ˆ
% â¬… â—‹ â®•
% â¬‹ â¬‡ â¬Š

% â­¦ â­¡ â­§
% â­  â—‹ â­¢
% â­© â­£ â­¨

% ? ? ?
% ? â—‹ ?
% ? ? ?

% â¬? â‡§ â¬€
% â‡¦ â—‹ â‡¨
% â¬ƒ â‡© â¬‚

main :- 
  inicio,
  juego.

%roles x o y
role(x).
role(y).

:- include('tablero_original').
%:- include('tablero_original_grande').
%:- include('tablero_colision').
%:- include('tablero_rebote_diagonal').
%:- include('tablero_rebote').

init(control(x)).

%posibles valores que pueden tener las relaciones
base(cell(X,Y,b)) :- 
  index(X),
  index(Y).

base(cell(X,Y,p)) :- 
  index(X),
  index(Y).

base(cell(X,Y,rol(R))) :- 
  role(R),
  index(X),
  index(Y).

base(cell(X,Y,pelota(R,P,XV,YV))) :- 
  role(R),
  pelota(P),
  index(X),
  index(Y),
  velocidad(XV),
  velocidad(YV).

base(cell(X,Y,golpeado(R))) :- 
  role(R),
  index(X),
  index(Y).

base(pelotas(R,C)) :-
  role(R),
  count_pelota(C).

base(control(R)) :- 
  role(R).

velocidad(0).
velocidad(1).
velocidad(-1).

%posibles valores que pueden tener las entradas
input(R,lanzar(X,Y)) :- 
  role(R),
  index(X),
  index(Y).

input(R,mover(X,Y)) :- 
  role(R),
  index(X),
  index(Y).

input(R,nada) :- 
  role(R).

%movimientos legales
legal(R,lanzar(X,Y)) :- 
  t(control(R)),
  (t(cell(X,Y,b));t(cell(X,Y,rol(_R1)))),
  \+(posicion_futura(_R,_P,X,Y)),
  t(cell(X1,Y1,rol(R))),
  adyacente(X,Y,X1,Y1),
  t(pelotas(R,C)),
  C > 0.

legal(R,mover(X,Y)) :- 
  t(control(R)),
  t(cell(X,Y,pelota(_R1,_P,_XV,_YV))),
  t(cell(X1,Y1,rol(R))),
  adyacente(X,Y,X1,Y1).

legal(R,mover(X,Y)) :- 
  t(control(R)),
  t(cell(X,Y,b)),
  t(cell(X1,Y1,rol(R))),
  adyacente(X,Y,X1,Y1).

legal(_R,nada).

adyacente(X1,Y1,X2,Y2) :-
  ((X1 is X2+1; X1 is X2-1),(Y1 is Y2+1; Y1 is Y2-1));
  ((X1 is X2),(Y1 is Y2+1; Y1 is Y2-1));
  ((X1 is X2+1; X1 is X2-1),(Y1 is Y2)).

%prÃ³ximo estado
%celdas con paredes
next(cell(X,Y,p)) :- 
  t(cell(X,Y,p)).

%celdas con jugador golpeado
%si se mueve hacia una pelota enemiga
next(cell(X,Y,golpeado(R))) :-
  role(R),
  does(R,mover(X,Y)),
  posicion_futura(E,_P,X,Y),
  E \== R,
  \+colision(X,Y).

%si se mueve hacia una pelota que viene directo hacia Ã©l.
next(cell(X1,Y1,golpeado(R))) :-
  role(R),
  does(R,mover(X,Y)),
  t(cell(X1,Y1,rol(R))),
  t(cell(X,Y,pelota(E,P,_XV,_YV))),
  E \== R,
  posicion_futura(E,P,X1,Y1),
  \+colision(X,Y).

%si el enemigo le lanza una pelota
next(cell(X,Y,golpeado(R))) :-
  role(E),
  role(R),
  E \== R,
  does(E,lanzar(X,Y)),
  t(cell(X,Y,rol(R))).

%si no hace nada y una pelota enemiga lo golpea
next(cell(X,Y,golpeado(R))) :-
  role(R),
  does(R,nada),
  t(cell(X,Y,rol(R))),
  posicion_futura(E,_P,X,Y),
  E \== R,
  \+colision(X,Y).

%celdas con jugadores
% caso de ser golpeado se maneja 
% antes y no hay q contemplarlo aca

%si hizo nada o lanzo y no cae pelota entonces la celda tiene al jugador.
next(cell(X,Y,rol(R))) :-
  role(R),
  (does(R,nada);does(R,lanzar(_X1,_Y1))),
  t(cell(X,Y,rol(R))),
  \+posicion_futura(_E,_P,X,Y).

%si hizo nada o lanzo y no cae pelota por colision, entonces la celda tiene al jugador.
next(cell(X,Y,rol(R))) :-
  role(R),
  (does(R,nada);does(R,lanzar(_X1,_Y1))),
  t(cell(X,Y,rol(R))),
  posicion_futura(_E,_P,X,Y),
  colision(X,Y).

%si hizo nada o lanzo, y cae una pelota que es del role, entonces la celda tiene al rol.
next(cell(X,Y,rol(R))) :-
  role(R),
  (does(R,nada);does(R,lanzar(_X1,_Y1))),
  t(cell(X,Y,rol(R))),
  posicion_futura(R,_P,X,Y),
  \+colision(X,Y).

%si se mueve y cae pelota del role, entonces la celda  tiene al role.
next(cell(X,Y,rol(R))) :-
  role(R),
  does(R,mover(X,Y)),
  posicion_futura(R,_P,X,Y),
  \+colision(X,Y).

%si se mueve y no cae pelota, entonces la celda tiene al jugador
next(cell(X,Y,rol(R))) :-
  role(R),
  does(R,mover(X,Y)),
  \+posicion_futura(_E,_P,X,Y).


%celdas con pelotas
%una pelota es lanzada
next(cell(X,Y,pelota(R,P,XV,YV))) :- 
  role(R),
  does(R,lanzar(X,Y)),
  t(cell(XR,YR,rol(R))),
  XV is X - XR,
  YV is Y - YR,
  init(pelotas(R,CantP)),
  buscar_pelota_no_usada(R,CantP,P),
  P\==e.

%esta quieta en una casilla
next(cell(X,Y,pelota(R,P,0,0))) :- 
  t(cell(X,Y,pelota(R,P,0,0))),
  \+(does(_R1,mover(X,Y))).

%choca contra una pered y tiene que regresar hacia la misma celda, entonces se invierte su velocidad
next(cell(X,Y,pelota(R,P,XV,YV))) :- 
  t(cell(X1,Y1,pelota(R,P,XV1,YV1))),
  posicion_futura(R,P,X,Y),
  \+(colision(X,Y)),
  \+(does(_R1,mover(X,Y))),
  X == X1, Y == Y1, %al preguntar si son iguales no es necesario ver que sea una casilla blanca
  XV is XV1 * (-1),
  YV is YV1 * (-1),
  \+posicion_futura(_R2,_P1,X,Y).

%choca contra una pered y viene en diagonal, entonces se invierte su velocidad sobre el eje ignorado (X)
next(cell(X,Y,pelota(R,P,XV,YV))) :- 
  t(cell(X1,Y1,pelota(R,P,XV,YV1))),
  posicion_futura(R,P,X,Y),
  \+(colision(X,Y)),
  \+(does(_R1,mover(X,Y))),
  X \== X1, Y == Y1,
  t(cell(X,Y,b)),
  YV is YV1 * (-1).

%choca contra una pered y viene en diagonal, entonces se invierte su velocidad sobre el eje ignorado (Y)
next(cell(X,Y,pelota(R,P,XV,YV))) :- 
  t(cell(X1,Y1,pelota(R,P,XV1,YV))),
  posicion_futura(R,P,X,Y),
  \+(colision(X,Y)),
  \+(does(_R1,mover(X,Y))),
  X == X1, Y \== Y1,
  t(cell(X,Y,b)),
  XV is XV1 * (-1).

 %avanza normalmente
next(cell(X,Y,pelota(R,P,XV,YV))) :- 
  t(cell(X1,Y1,pelota(R,P,XV,YV))),
  posicion_futura(R,P,X,Y),
  \+(colision(X,Y)),
  t(cell(X,Y,b)),
  \+(does(_R1,mover(X,Y))),
  X is X1 + XV,
  Y is Y1 + YV.

%se recalcula la velocidad. En caso que no choque y siga hacia adelante la velocidad calculada queda igual.
%% next(cell(X,Y,pelota(R,P,XV,YV))) :- 
%%   t(cell(X1,Y1,pelota(R,P,_XV1,_YV1))),
%%   posicion_futura(R,P,X,Y),
%%   t(cell(X,Y,b)),
%%   \+(colision(X,Y)),
%%   \+(does(_R1,mover(X,Y))),
%%   X \== X1, Y \== Y1,
%%   XV is X-X1,
%%   YV is Y-Y1.


%detecta que choco contra otra pelota a uno de distancia, 
%o con una pelota quieta a cero distancia
next(cell(X,Y,pelota(R,P,0,0))) :- 
  t(cell(X,Y,pelota(R,P,_XV,_YV))),
  posicion_futura(R,P,X1,Y1),
  colision(X1,Y1),
  \+(does(_R1,mover(X,Y))).

%detecta que atravesÃ³ a otra pelota a cero distancia
 next(cell(X,Y,pelota(R,P,0,0))) :- 
   t(cell(X,Y,pelota(R,P,_XV,_YV))),
   posicion_futura(R,P,X1,Y1),
   t(cell(X1,Y1,pelota(R1,P1,_XV1,_YV1))),
   posicion_futura(R1,P1,X,Y),
   (R1 \== R;P1 \== P),
   \+(does(_R1,mover(X,Y))).

%se cruza con una pelota pero la otra no viene en sentido contrario 
next(cell(X1,Y1,pelota(R,P,XV,YV))) :- 
   t(cell(X,Y,pelota(R,P,XV,YV))),
   posicion_futura(R,P,X1,Y1),
   t(cell(X1,Y1,pelota(R1,P1,_XV1,_YV1))),
   (R1 \== R;P1 \== P),
   \+posicion_futura(R1,P1,X,Y),
   \+posicion_futura(R1,P1,X1,Y1),
   \+(does(_R1,mover(X1,Y1))).

%se cruza con una pelota y la otra  no viene en sentido contrario  pero regresa a su casilla porque choca
next(cell(X,Y,pelota(R,P,0,0))) :- 
   t(cell(X,Y,pelota(R,P,_XV,_YV))),
   posicion_futura(R,P,X1,Y1),
   t(cell(X1,Y1,pelota(R1,P1,_XV1,_YV1))),
   (posicion_futura(R1,P1,X,Y);posicion_futura(R1,P1,X1,Y1)),
   (R1 \== R;P1 \== P),
   \+(does(_R1,mover(X,Y))).

%avanza a una casilla que tiene un jugador pero ese jugador la esquiva
next(cell(X,Y,pelota(R,P,XV,YV))) :- 
  t(cell(X1,Y1,pelota(R,P,XV,YV))),
  posicion_futura(R,P,X,Y),
  \+(colision(X,Y)),
  t(cell(X,Y,rol(R1))),
  (does(R1,mover(X2,Y2))),
  (X1\==X2; Y1\==Y2).


%celdas vacias
%si alguien se mueve desde ella
next(cell(X,Y,b)) :-
  t(cell(X,Y,rol(R))),
  does(R,mover(_X1,_Y1)),
  (\+posicion_futura(_R1,_P,X,Y);colision(X,Y)).

%si es blanca y alguien se mueve y no es sobre ella
next(cell(X,Y,b)) :-
  t(cell(X,Y,b)),
  does(_R,mover(X1,Y1)),
  (X\==X1;Y\==Y1),
  (\+posicion_futura(_R1,_P,X,Y);colision(X,Y)).

%si es blanca y alguien lanza una pelota y no es sobre ella
next(cell(X,Y,b)) :-
  t(cell(X,Y,b)),
  does(_R,lanzar(X1,Y1)),
  (X\==X1;Y\==Y1),
  (\+posicion_futura(_R1,_P,X,Y);colision(X,Y)).

%si tiene una pelota y la pelota puede moverse. 
% y nadie se mueve sobre ella
next(cell(X,Y,b)) :- 
  t(cell(X,Y,pelota(R,P,XV,YV))),
  S is X + XV,
  T is Y + YV,
  \+colision(S,T),
  \+(posicion_futura(R,P,X,Y)),
  \+(does(_R2,mover(X,Y))),
  (\+(posicion_futura(_R1,_P1,X,Y));colision(X,Y)),
  \+(does(_R3,lanzar(X,Y))).

%si es blanca y pasa nada
next(cell(X,Y,b)) :-
  t(cell(X,Y,b)),
  t(control(R)),
  does(R,nada),
  (\+posicion_futura(_R1,_P,X,Y);colision(X,Y)).

%si el jugador se mueve hacia una pelota de Ã©l, que viene directo hacia Ã©l.
next(cell(X,Y,b)) :-
  t(cell(X,Y,rol(R))),
  does(R,mover(X1,Y1)),
  t(cell(X1,Y1,pelota(R,P,_XV,_YV))),
  posicion_futura(R,P,X2,Y2),
  X2==X,Y2==Y.


%si lanza y le cae una pelota sigue teniendo la misma cantidad
next(pelotas(R,C2)) :-
  does(R,lanzar(_X,_Y)),
  t(cell(X,Y,rol(R))),
  cae_pelota(X,Y,R),
  t(pelotas(R,C2)).

%si lanza y no le cae pelota pierde una
next(pelotas(R,C1)) :-
  does(R,lanzar(_X,_Y)),
  t(cell(X,Y,rol(R))),
  \+cae_pelota(X,Y,R),
  t(pelotas(R,C2)),
  C1 is C2-1.


%si se mueve a donde va a estar una pelota gana una
next(pelotas(R,C1)) :-
  does(R,mover(X,Y)),
  cae_pelota(X,Y,R),
  t(pelotas(R,C2)),
  C1 is C2+1.

%si se mueve a hacia una pelota que viene directo hacia Ã©l gana una.
next(pelotas(R,C1)) :-
  does(R,mover(X,Y)),
  t(cell(X1,Y1,rol(R))),
  t(cell(X,Y,pelota(R,P,_XV,_YV))),
  posicion_futura(R,P,X2,Y2),
  X2==X1,Y2==Y1,
  t(pelotas(R,C2)),
  C1 is C2+1.

%si se mueve y no hay pelota sigue igual
next(pelotas(R,C2)) :-
  does(R,mover(X,Y)),
  \+cae_pelota(X,Y,R),
  t(pelotas(R,C2)).

%si hace nada y le cae pelota gana una
next(pelotas(R,C1)) :-
  does(R,nada),
  t(cell(X,Y,rol(R))),
  cae_pelota(X,Y,R),
  t(pelotas(R,C2)),
  C1 is C2+1.

%si hace nada y no le cae pelota sigue igual
next(pelotas(R,C2)) :-
  does(R,nada),
  t(cell(X,Y,rol(R))),
  \+cae_pelota(X,Y,R),
  t(pelotas(R,C2)).


%control de jugadores
next(control(x)) :-
  t(control(y)).

next(control(y)) :-
  t(control(x)).

%llega pelota porque no hay colision.
cae_pelota(X,Y,R):-
  posicion_futura(R,_P,X,Y),
  \+colision(X,Y).

%se queda en el lugar porque tiene velocidad 0,0
posicion_futura(R,P,X,Y) :-
  t(cell(X,Y,pelota(R,P,0,0))).

%avanza segun su velocidad
posicion_futura(R,P,XF,YF) :- 
  t(cell(X,Y,pelota(R,P,XV,YV))),
  XF is X + XV,
  YF is Y + YV,
  \+(t(cell(XF,YF,p))).
  %adyacente(XF,YF,XO,YO),
  %% \+(posicion_futura(_R,_P,XF,YF)).

%choca en direccion arriba/abajo o izquierda/derecha y se queda en el lugar
posicion_futura(R,P,X,Y) :-
  t(cell(X,Y,pelota(R,P,XV,YV))),
  XF is X + XV,
  YF is Y + YV,
  t(cell(XF,YF,p)),
  %abajo o arriba
  (((XV == 1;XV == -1),YV == 0);
  %derecha o izquierda
  (XV == 0,(YV == 1;YV == -1))).

%choca en direccion diagonal y se queda en el lugar
posicion_futura(R,P,X,Y) :-
  t(cell(X,Y,pelota(R,P,XV,YV))),
  XF is X + XV,
  YF is Y + YV,
  t(cell(XF,YF,p)),   %celda futura
  ((t(cell(X,YF,p)),t(cell(XF,Y,p)));   %celda 1
  ((\+(t(cell(X,YF,p))),\+(t(cell(XF,Y,p)))))),   %celda 2
  %diagonales
  ((XV == 1;XV == -1),(YV == 1;YV == -1)).

%choca en diagonal y avanza en x
posicion_futura(R,P,XF,Y) :-
  t(cell(X,Y,pelota(R,P,XV,YV))),
  XF is X + XV,
  YF is Y + YV,
  t(cell(XF,YF,p)),   %celda futura
  t(cell(X,YF,p)),  %celda 1
  \+t(cell(XF,Y,p)),  %celda 2
  %diagonales
  ((XV == 1;XV == -1),(YV == 1;YV == -1)).

%choca en diagonal y avanza en y
posicion_futura(R,P,X,YF) :-
  t(cell(X,Y,pelota(R,P,XV,YV))),
  XF is X + XV,
  YF is Y + YV,
  t(cell(XF,YF,p)),   %celda futura
  \+t(cell(X,YF,p)),  %celda 1
  t(cell(XF,Y,p)),  %celda 2
  %diagonales
  ((XV == 1;XV == -1),(YV == 1;YV == -1)).

colision(X,Y) :-
  posicion_futura(R1,P1,X,Y),
  posicion_futura(R2,P2,X,Y),
  (R1 \== R2;P1 \== P2).

buscar_pelota_no_usada(_R,0,e).

buscar_pelota_no_usada(R,P,P):-
  \+(t(cell(_X,_Y,pelota(R,P,_XV,_YV)))).

buscar_pelota_no_usada(R,P,OP) :-
  t(cell(_X,_Y,pelota(R,P,_XV,_YV))),
  P1 is P-1,
  buscar_pelota_no_usada(R,P1,OP).

goal(x,0) :- 
  golpeado(x).
goal(x,50) :- 
  golpeado(x),
  golpeado(y).
goal(x,100) :- 
  golpeado(y).

goal(y,0) :- 
  golpeado(y).
goal(y,50) :- 
  golpeado(y),
  golpeado(x).
goal(y,100) :- 
  golpeado(x).

%si golpeado no esta assertado goal falla, por eso este ultimo para el agente
goal(_R,25) :-
  \+golpeado(x),
  \+golpeado(y).

terminal :- 
  (golpeado(x); golpeado(y)).

golpeado(R) :-
  t(cell(_X,_Y,golpeado(R))).

distinct(X,Y) :- 
  X\==Y.

%inicializa estado inicial y borra historial
inicio :- 
  retractall(t(_)),
  retractall(h(_,_)),
  retractall(estado(_)),
  crea_estado_inicial.

%crea estado inicial
crea_estado_inicial :- 
  init(X),
  \+(t(X)),
  assert(t(X)),
  assert(h(0,X)),
  crea_estado_inicial.

crea_estado_inicial :- 
  assert(estado(1)),
  imprime_tablero.

% gestor del juego
% borra acciones viejas
% busca nuevas acciones
% calcula prÃ³ximo estado
% crea proximo estado

juego :- 
  \+terminal,
  retractall(does(_X,_A)),
  inserta_acciones,
  %retractall(h(_,_)),
  proximo_estado,
  retractall(t(_Y)),
  crea_estado,
  %clear,
  imprime,
  juego.

juego :- 
  terminal,
  goal(x,Px),
  goal(y,Po),
  write('X gano '),
  write(Px),
  write(' puntos e Y gano '),
  write(Po),
  write(' puntos.').

% busca las nuevas acciones de los jugadores y las inserta
inserta_acciones:- 
  t(control(X)),
  jugador(X,A),
  legal(X,A),
  assert(does(X,A)),
  role(O),
  distinct(X,O),
  assert(does(O,nada)).

%calcula el prÃ³ximo estado
proximo_estado :- 
  estado(E),
  next(Y),
  \+(h(E,Y)),
  assert(h(E,Y)),
  proximo_estado.

proximo_estado.

%crea el estado actual
crea_estado :- 
  estado(E),
  h(E,Y),
  \+(t(Y)),
  assert(t(Y)),
  crea_estado.

crea_estado :- 
  retract(estado(N)),
  N2 is N+1,
  assert(estado(N2)).

%imprime estado actual del juego
imprime :-
  estado(E),
  write('Acciones elegidas: '),nl,
  does(x,A),write(['x: ',A]),nl,
  does(y,A1),write(['y: ',A1]),nl,
  findall(pelota(R,P,XV,YV),t(cell(_X1,_Y1,pelota(R,P,XV,YV))),True),
  write('Pelotas assertadas: '),write(True),nl,
  write('Estado: '),
  write(E),nl,
  t(control(X)),
  write('Control: '),
  write(X),nl,
  t(pelotas(x,CX)),
  t(pelotas(y,CY)),
  max_pelota(MP),
  write('Pelotas de X: '),
  write('('),write(CX),write(') '),
  imprime_pelotas(x,MP),nl,
  write('Pelotas de Y: '),
  write('('),write(CY),write(') '),
  imprime_pelotas(y,MP),nl,
  imprime_columna_index,
  cell_size(x,SX),
  imprime_filas(0,SX),
  write('*************'),nl.

imprime_tablero :-
  imprime_columna_index,
  cell_size(x,SX),
  imprime_filas(0,SX),
  write('*************'),nl.

imprime_pelotas(_R,0).
imprime_pelotas(R,P) :-
  t(cell(X1,Y1,pelota(R,P,X,Y))),
  write('\u25CF'),
  write(P),write(' v('),write(X),write(','),write(Y),write(') '),
  write('p('),write(X1),write(','),write(Y1),write(') '),
  P1 is P-1,
  imprime_pelotas(R,P1).

imprime_pelotas(R,P) :-
  write('\u25CB '),
  P1 is P-1,
  imprime_pelotas(R,P1).

imprime_columna_index :-
  write('  '),
  imprime_columna_index_aux(0),nl.

imprime_columna_index_aux(SX) :-
  cell_size(x,SX).

imprime_columna_index_aux(X) :-
  write(X),
  %write('\u3000'),
  write(' '),
  X1 is X+1,
  imprime_columna_index_aux(X1).

imprime_filas(SX,SX).

imprime_filas(I,SX) :-
  I < SX,
  imprime_fila(I),
  I1 is I+1,
  imprime_filas(I1,SX).

imprime_fila(X) :- 
  write(X),
  write(' '),
  cell_size(y,SY),
  imprime_celdas(X,0,SY),nl.

imprime_celdas(_,SY,SY).

imprime_celdas(X,I,SY) :-
  I < SY,
  imprime_celda(X,I),
  I1 is I+1,
  imprime_celdas(X,I1,SY).

imprime_celda(X,Y) :-
  t(cell(X,Y,b)),
  %write('\s').
  write('\u25A1 ').

imprime_celda(X,Y) :-
  t(cell(X,Y,p)),
  write('\u25A0 ').

imprime_celda(X,Y) :-
  t(cell(X,Y,rol(x))),
  write('\u24E7 ').
  %write('X ').

imprime_celda(X,Y) :-
  t(cell(X,Y,rol(y))),
  write('\u24E8 ').
  %write('Y ').

imprime_celda(X,Y) :-
  t(cell(X,Y,pelota(_R,_P,XV,YV))),
  imprime_direccion(XV,YV).
  %write('\u2190 ').
  %write(P),write(' ').

imprime_celda(X,Y) :-
  t(cell(X,Y,golpeado(_R))),
  write('\u25A3 ').

imprime_celda(X,Y) :-
  t(cell(X,Y,e)),
  write('\u25A3 ').

imprime_celda(X,Y) :-
  t(cell(X,Y,C)),
  write(C).

imprime_direccion(0,0) :- write('\u25CF ').
imprime_direccion(0,1) :- write('\u2192 ').
imprime_direccion(0,-1) :- write('\u2190 ').
imprime_direccion(1,1) :- write('\u2198 ').
imprime_direccion(1,0) :- write('\u2193 ').
imprime_direccion(1,-1) :- write('\u2199 ').
imprime_direccion(-1,1) :- write('\u2197 ').
imprime_direccion(-1,0) :- write('\u2191 ').
imprime_direccion(-1,-1) :- write('\u2196 ').
%imprime_direccion(e,e) :- write('\u25A3 ').

clear :- write('\33\[2J').

clear_all :- write('\33\[H\33\[2J').

:- include('agente_v2').

jugador(x,A) :-
  %nl,nl,write('ANTES'),nl,
  %imprime,
  %nl,nl,nl,
  %estado(E),
  %nl,nl,nl,
  agente(x,A).
   /*findall(A1,t(A1),H),
  write(H),nl.*/
    %nl,nl,write('DESPUES'),nl,
  %imprime,
  %nl,nl,nl,
  %estado(E),
  %write(E),
  %nl,nl,nl.

jugador(R,A) :-
  legal(R,A).
