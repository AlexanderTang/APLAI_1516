:- lib(ic).

:- compile("basic_solver").
:- compile("puzzles").
:- compile("print").

% runs the demo to solve two easy puzzles
add_demo:-
  solve_add_demo(tiny),
  solve_add_demo(helmut).
  
% run the puzzle with the given puzzle and a certain search heuristic;
% the amount of backtracks is returned in Back
solve_additional(Puzzle,Selection,Choice,Back,Tprop,Tsearch):-
  statistics(runtime, _),
  problem(Puzzle,W,H,Hints),
  length(Hints,L),
  all_rectangles(W,H,Hints,L,PR), % PR stands for possible rectangles
  no_overlap(PR),
  statistics(runtime,[_|Tprop]), % calculate propagation time
  term_variables(PR, Vars),
  shave(Vars),
  search(Vars,0,Selection,Choice,complete,[backtrack(Back)]),  % set search heuristic parameters
  statistics(runtime,[_|Tsearch]). % calculate search time

% demo: give a difficulty and the solution gets printed
solve_add_demo(Puzzle):-
  problem(Puzzle,W,H,Hints),
  length(Hints,L),
  all_rectangles(W,H,Hints,L,PR), % PR stands for possible rectangles
  no_overlap(PR),
  term_variables(PR, Vars),
  shave(Vars),
  labeling(Vars),
  show(W,H,Hints,[],ascii),nl,nl,
  show(W,H,Hints,PR,ascii),nl.

% applies shaving to the problem variables
shave(Xs) :-
    ( foreach(X,Xs) do
        findall(X, indomain(X), Values),
        X :: Values
    ).