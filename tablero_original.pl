cell_size(x,6).
cell_size(y,6).

index(0).
index(1).
index(2).
index(3).
index(4).
index(5).
%% index(6).
%% index(7).
%% index(8).
%% index(9).

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
%% init(cell(0,6,p)).
%% init(cell(0,7,p)).
%% init(cell(0,8,p)).
%% init(cell(0,9,p)).

init(cell(1,0,p)).
init(cell(1,1,b)).
init(cell(1,2,b)).
init(cell(1,3,b)).
init(cell(1,4,y)).
init(cell(1,5,p)).
%% init(cell(1,6,b)).
%% init(cell(1,7,b)).
%% init(cell(1,8,b)).
%% init(cell(1,9,p)).

init(cell(2,0,p)).
init(cell(2,1,b)).
init(cell(2,2,b)).
init(cell(2,3,b)).
init(cell(2,4,b)).
init(cell(2,5,p)).
%% init(cell(2,6,b)).
%% init(cell(2,7,b)).
%% init(cell(2,8,b)).
%% init(cell(2,9,p)).

init(cell(3,0,p)).
init(cell(3,1,b)).
init(cell(3,2,b)).
init(cell(3,3,b)).
init(cell(3,4,b)).
init(cell(3,5,p)).
%% init(cell(3,6,b)).
%% init(cell(3,7,b)).
%% init(cell(3,8,b)).
%% init(cell(3,9,p)).

init(cell(4,0,p)).
init(cell(4,1,x)).
init(cell(4,2,b)).
init(cell(4,3,b)).
init(cell(4,4,b)).
init(cell(4,5,p)).
%% init(cell(4,6,b)).
%% init(cell(4,7,b)).
%% init(cell(4,8,b)).
%% init(cell(4,9,p)).

init(cell(5,0,p)).
init(cell(5,1,p)).
init(cell(5,2,p)).
init(cell(5,3,p)).
init(cell(5,4,p)).
init(cell(5,5,p)).
%% init(cell(5,6,b)).
%% init(cell(5,7,b)).
%% init(cell(5,8,b)).
%% init(cell(5,9,p)).

%% init(cell(6,0,p)).
%% init(cell(6,1,b)).
%% init(cell(6,2,b)).
%% init(cell(6,3,b)).
%% init(cell(6,4,x)).
%% init(cell(6,5,b)).
%% init(cell(6,6,p)).
%% init(cell(6,7,p)).
%% init(cell(6,8,b)).
%% init(cell(6,9,p)).

%% init(cell(7,0,p)).
%% init(cell(7,1,b)).
%% init(cell(7,2,b)).
%% init(cell(7,3,b)).
%% init(cell(7,4,b)).
%% init(cell(7,5,b)).
%% init(cell(7,6,p)).
%% init(cell(7,7,b)).
%% init(cell(7,8,b)).
%% init(cell(7,9,p)).

%% init(cell(8,0,p)).
%% init(cell(8,1,y)).
%% init(cell(8,2,b)).
%% init(cell(8,3,b)).
%% init(cell(8,4,b)).
%% init(cell(8,5,b)).
%% init(cell(8,6,b)).
%% init(cell(8,7,b)).
%% init(cell(8,8,b)).
%% init(cell(8,9,p)).

%% init(cell(9,0,p)).
%% init(cell(9,1,p)).
%% init(cell(9,2,p)).
%% init(cell(9,3,p)).
%% init(cell(9,4,p)).
%% init(cell(9,5,p)).
%% init(cell(9,6,p)).
%% init(cell(9,7,p)).
%% init(cell(9,8,p)).
%% init(cell(9,9,p)).

init(pelotas(x,2)).
init(pelotas(y,2)).