%desarrollo jugador X
agente(R,A) :-
  %estado(E),
  %E1 is E-1,
  mejor_accion(R,A).
  %restaurar(E1).

mejor_accion(R,A) :- 
  retractall(utilidad(_,_)),
  findall(A1,legal(R,A1),Ac),
  write('Acciones legales: '),write(Ac),nl,
  simular_acciones(R,Ac),
  %conseguir accion de mayor utilidad y devolverla en A.
  findall(A2,utilidad(A2,_U),Ut),
  findall((AT,UT),utilidad(AT,UT),UTs),
  write('Acciones utilidad: '),write(UTs),nl,
  assert(max_utilidad(nada,-100)),
  mayor_utilidad(Ut),
  max_utilidad(A,_),
  write('Mejor accion: '),write(A),nl.

mayor_utilidad([]).

mayor_utilidad([A|Ac]) :-
  utilidad(A,U),
  max_utilidad(_A1,U1),
  U > U1,
  retract(max_utilidad(_,_)),
  assert(max_utilidad(A,U)),
  mayor_utilidad(Ac).

mayor_utilidad([_A|Ac]) :- 
  mayor_utilidad(Ac).

simular_acciones(_,[]).

simular_acciones(R,[A|Ac]) :-
  estado(E),
  E1 is E-1,
  simular_accion(R,A),
  restaurar(E1),
  simular_acciones(R,Ac).

simular_accion(R,A) :-
  retractall(does(_,_)),
  assert(does(R,A)),
  role(R1),
  distinct(R,R1),
  assert(does(R1,nada)),
  proximo_estado,
  retractall(t(_)),
  crea_estado.
  %goal(R,U),
  %assert(utilidad(A,U)).

%restaura el estado del juego al original
restaurar(E1) :- 
  h(E,_),
  E1 < E,
  write('ESTADO E: '),write(E),nl,
  retractall(h(E,_)),
  restaurar(E1).

restaurar(E1) :- 
  retract(estado(_)),
  assert(estado(E1)),
  retractall(t(_)),
  crea_estado.
