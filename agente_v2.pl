%desarrollo jugador X
agente(R,A) :-
	mejor_accion(R,A).

mejor_accion(R,A) :- 
  retractall(utilidad(_,_)),
  retractall(max_utilidad(_,_)),
  findall(A1,legal(R,A1),Ac),
  %write('Acciones legales: '),write(Ac),nl,
  simular_acciones(R,Ac),
  retractall(does(_,_)),
  %conseguir accion de mayor utilidad y devolverla en A.
  findall([AT,UT],utilidad(AT,UT),UTs),
  %write('Acciones utilidad: '),write(UTs),nl,
  assert(max_utilidad(nada,-100)),
  mayor_utilidad(UTs),
  max_utilidad(A,_).
  %write('Mejor accion: '),write(A),nl.
  %break.

simular_acciones(_,[]).

simular_acciones(R,[A|Ac]) :-
  estado(E),
  E1 is E-1,
  simular_accion(R,A),
  eliminar_simulacion(E1),
  restaurar_original(E1),
  simular_acciones(R,Ac).

simular_accion(R,A) :-
  retractall(does(_,_)),
  assert(does(R,A)),
  role(R1),
  distinct(R,R1),
  assert(does(R1,nada)),
  proximo_estado,
  retractall(t(_)),
  crea_estado,
  goal(R,U),
  assert(utilidad(A,U)).

  
mayor_utilidad([]).

mayor_utilidad([[A,U]|Ac]) :-
  max_utilidad(_A1,U1),
  U > U1,
  retract(max_utilidad(_,_)),
  assert(max_utilidad(A,U)),
  mayor_utilidad(Ac).

mayor_utilidad([_A|Ac]) :- 
  mayor_utilidad(Ac).

%restaura el estado del juego al original
eliminar_simulacion(E1):-
  E is E1+1,
  h(E,_),
  retractall(h(E,_)),
  eliminar_simulacion(E).

eliminar_simulacion(_E1).

restaurar_original(E):-
  retract(estado(_)),
  assert(estado(E)),
  retractall(t(_)),
  crea_estado.