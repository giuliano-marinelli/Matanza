%Agente generico, funciona en cualquier juego basandose en el valor retornado por 'goal'
agent(MejorAccion) :-
            getAccionesLegales([],LAcciones),
            salvarEstadoActual([],Estado),
            simularEstados(LAcciones,Estado,LAccionesPuntajes),
            getMejorAccion(LAccionesPuntajes,_,-1,MejorAccion,_).


%Obtener aciones legales para el jugador actual
getAccionesLegales(L0,L1) :-
      t(control(J)),
      legal(J,A),
      \+member(A,L0),
      distinct(A,nada),
      getAccionesLegales([A|L0],L1).

getAccionesLegales(L,L).

salvarEstadoActual(Lin,Lout) :-
      t(X),
      \+member(X,Lin),
      salvarEstadoActual([X|Lin],Lout).

salvarEstadoActual(Lout,Lout).


%Simula los estados resultantes de aplicar las acciones en la lista recibida como 1er argumento
simularEstados([A|R1],EstadoAnterior,[ParAccionPuntaje|R2]):-
      simularEstado(A,ParAccionPuntaje),
      retractall(t(_)),
      restaurarEstado(EstadoAnterior),
      simularEstados(R1,EstadoAnterior,R2).

simularEstados([],_,[]).


simularEstado(A,ParAccionPuntaje):-
      t(control(X)),
      assert(does(X,A)),
      role(O), distinct(X,O),
      assert(does(O,nada)),
      proximo_estado_simulado,
      retract(does(X,A)),
      retract(does(O,nada)),
      retractall(t(_Y)),
      crea_estado_simulado,
      goal(X,ValorGoal),
      ParAccionPuntaje = (A,ValorGoal).

restaurarEstado([X|Xs]) :-
      assert(t(X)),
      restaurarEstado(Xs).
restaurarEstado([]).


proximo_estado_simulado:-
  estado(E),
  next(Y),
  \+(h(E,Y)),
  assert(h(E,Y)),
  proximo_estado_simulado.

proximo_estado_simulado.


crea_estado_simulado:-
  estado(E),
  h(E,Y),
  \+(t(Y)),
  assert(t(Y)),
  %display(Y),nl,
  crea_estado_simulado.

crea_estado_simulado:-retractall(h(_,_)).


%Obtiene de una lista, la mejor acción.
getMejorAccion([(Accion,Puntaje)|R],_,MejorPuntajeParcial,MejorAccion,MejorPuntaje):-
	Puntaje>=MejorPuntajeParcial,
    getMejorAccion(R,Accion,Puntaje,MejorAccion,MejorPuntaje).

getMejorAccion([(_,_)|R],MejorAccionParcial,MejorPuntajeParcial,MejorAccion,MejorPuntaje):-
	 getMejorAccion(R,MejorAccionParcial,MejorPuntajeParcial,MejorAccion,MejorPuntaje).

getMejorAccion([],MejorAccion,MejorPuntaje,MejorAccion,MejorPuntaje).