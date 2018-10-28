cell_size(x,6).
cell_size(y,6).

index(0).
index(1).
index(2).
index(3).
index(4).
index(5).

pelota(1).
pelota(2).

max_pelota(2).

count_pelota(0).
count_pelota(1).
count_pelota(2).

%estado inicial
init(cell(0,0,p)).
init(cell(0,1,p)).
init(cell(0,2,p)).
init(cell(0,3,p)).
init(cell(0,4,p)).
init(cell(0,5,p)).

init(cell(1,0,p)).
init(cell(1,1,b)).
init(cell(1,2,b)).
init(cell(1,3,pelota(y,2,-1,-1))).
init(cell(1,4,rol(y))).
init(cell(1,5,p)).

init(cell(2,0,p)).
init(cell(2,1,b)).
init(cell(2,2,b)).
init(cell(2,3,b)).
init(cell(2,4,b)).
init(cell(2,5,p)).

init(cell(3,0,p)).
init(cell(3,1,b)).
init(cell(3,2,b)).
init(cell(3,3,b)).
init(cell(3,4,b)).
init(cell(3,5,p)).

init(cell(4,0,p)).
init(cell(4,1,rol(x))).
init(cell(4,2,pelota(x,2,1,1))).
init(cell(4,3,b)).
init(cell(4,4,b)).
init(cell(4,5,p)).

init(cell(5,0,p)).
init(cell(5,1,p)).
init(cell(5,2,p)).
init(cell(5,3,p)).
init(cell(5,4,p)).
init(cell(5,5,p)).


init(pelotas(x,0)).
init(pelotas(y,0)).