cell_size(x,7).
cell_size(y,7).

index(0).
index(1).
index(2).
index(3).
index(4).
index(5).
index(6).

pelota(1).
pelota(2).
pelota(3).
pelota(4).

max_pelota(4).

count_pelota(0).
count_pelota(1).
count_pelota(2).
count_pelota(3).
count_pelota(4).

%estado inicial
init(cell(0,0,p)).
init(cell(0,1,b)).
init(cell(0,2,b)).
init(cell(0,3,p)).
init(cell(0,4,b)).
init(cell(0,5,rol(y))).
init(cell(0,6,p)).

init(cell(1,0,b)).
init(cell(1,1,b)).
init(cell(1,2,b)).
init(cell(1,3,b)).
init(cell(1,4,b)).
init(cell(1,5,b)).
init(cell(1,6,b)).

init(cell(2,0,b)).
init(cell(2,1,b)).
init(cell(2,2,pelota(x,1,1,1))).
init(cell(2,3,pelota(x,2,1,0))).
init(cell(2,4,pelota(x,3,1,-1))).
init(cell(2,5,b)).
init(cell(2,6,b)).

init(cell(3,0,p)).
init(cell(3,1,b)).
init(cell(3,2,pelota(x,4,0,1))).
init(cell(3,3,p)).
init(cell(3,4,pelota(y,4,0,-1))).
init(cell(3,5,b)).
init(cell(3,6,p)).

init(cell(4,0,b)).
init(cell(4,1,b)).
init(cell(4,2,pelota(y,1,-1,1))).
init(cell(4,3,pelota(y,2,-1,0))).
init(cell(4,4,pelota(y,3,-1,-1))).
init(cell(4,5,b)).
init(cell(4,6,b)).

init(cell(5,0,b)).
init(cell(5,1,b)).
init(cell(5,2,b)).
init(cell(5,3,b)).
init(cell(5,4,b)).
init(cell(5,5,b)).
init(cell(5,6,b)).

init(cell(6,0,p)).
init(cell(6,1,rol(x))).
init(cell(6,2,b)).
init(cell(6,3,p)).
init(cell(6,4,b)).
init(cell(6,5,b)).
init(cell(6,6,p)).

init(pelotas(x,0)).
init(pelotas(y,0)).