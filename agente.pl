%desarrollo jugador Y
agente(R,A) :-
  estado(E),
  E1 is E-1,
  mejor_accion(A),
  restaurar(E1).

mejor_accion(A) :- 
  t(control(R)),
  findall(A1,legal(R,A1),Ac),
  simular_acciones(R,Ac).
  %conseguir accion de mayor utilidad y devolverla en A.

simular_acciones(_,[]).

simular_acciones(R,[A|Ac]) :-
  estado(E),
  E1 is E-1,
  simular_accion(R,A),
  restaurar(E1),
  simular_acciones(R,Ac).

simular_accion(R,A) :-
  assert(does(R,A)),
  R1 \== R,
  assert(does(R1,nada)),
  proximo_estado,
  crea_estado,
  goal(R,G),
  assert(utilidad(A,G)).

%restaura el estado del juego del agente con su mejor accion
restaurar(E1) :- 
  h(E,_),
  E1 < E,
  retractall(h(E,_)),
  restaurar(E1).

restaurar(E1) :- 
  retract(estado(_)),
  assert(estado(E1)).
  retractall(t(_)),
  crea_estado.
