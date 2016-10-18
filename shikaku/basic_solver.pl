:- lib(ic).

:- compile("puzzles").
:- compile("print").

% runs the demo to solve two easy puzzles
basic_demo:-
  solve_basic_demo(tiny),
  solve_basic_demo(helmut).
  
% list of banned heuristics/puzzles due to too large computation times:
solve_basic(p(3,3),input_order,_,'NA','NA','NA').
solve_basic(p(4,1),input_order,_,'NA','NA','NA').
solve_basic(p(4,2),input_order,_,'NA','NA','NA').
solve_basic(p(4,3),input_order,_,'NA','NA','NA').
solve_basic(p(4,4),input_order,_,'NA','NA','NA').
solve_basic(p(4,5),input_order,_,'NA','NA','NA').
solve_basic(p(5,1),input_order,_,'NA','NA','NA').
solve_basic(p(5,2),input_order,_,'NA','NA','NA').
solve_basic(p(5,3),input_order,_,'NA','NA','NA').
solve_basic(p(5,4),input_order,_,'NA','NA','NA').
solve_basic(p(5,5),input_order,_,'NA','NA','NA').
solve_basic(p(6,1),input_order,_,'NA','NA','NA').
solve_basic(p(3,1),first_fail,_,'NA','NA','NA').
solve_basic(p(3,2),first_fail,_,'NA','NA','NA').
solve_basic(p(3,3),first_fail,_,'NA','NA','NA').
solve_basic(p(3,4),first_fail,_,'NA','NA','NA').
solve_basic(p(3,5),first_fail,_,'NA','NA','NA').
solve_basic(p(4,1),first_fail,_,'NA','NA','NA').
solve_basic(p(4,2),first_fail,_,'NA','NA','NA').
solve_basic(p(4,3),first_fail,_,'NA','NA','NA').
solve_basic(p(4,4),first_fail,_,'NA','NA','NA').
solve_basic(p(4,5),first_fail,_,'NA','NA','NA').
solve_basic(p(5,1),first_fail,_,'NA','NA','NA').
solve_basic(p(5,2),first_fail,_,'NA','NA','NA').
solve_basic(p(5,3),first_fail,_,'NA','NA','NA').
solve_basic(p(5,4),first_fail,_,'NA','NA','NA').
solve_basic(p(5,5),first_fail,_,'NA','NA','NA').
solve_basic(p(6,1),first_fail,_,'NA','NA','NA').
solve_basic(p(3,3),smallest,_,'NA','NA','NA').
solve_basic(p(4,1),smallest,_,'NA','NA','NA').
solve_basic(p(4,2),smallest,_,'NA','NA','NA').
solve_basic(p(4,3),smallest,_,'NA','NA','NA').
solve_basic(p(4,4),smallest,_,'NA','NA','NA').
solve_basic(p(4,5),smallest,_,'NA','NA','NA').
solve_basic(p(5,1),smallest,_,'NA','NA','NA').
solve_basic(p(5,2),smallest,_,'NA','NA','NA').
solve_basic(p(5,3),smallest,_,'NA','NA','NA').
solve_basic(p(5,4),smallest,_,'NA','NA','NA').
solve_basic(p(5,5),smallest,_,'NA','NA','NA').
solve_basic(p(6,1),smallest,_,'NA','NA','NA').
solve_basic(p(4,1),largest,_,'NA','NA','NA').
solve_basic(p(4,2),largest,_,'NA','NA','NA').
solve_basic(p(4,3),largest,_,'NA','NA','NA').
solve_basic(p(4,4),largest,_,'NA','NA','NA').
solve_basic(p(4,5),largest,_,'NA','NA','NA').
solve_basic(p(5,1),largest,_,'NA','NA','NA').
solve_basic(p(5,2),largest,_,'NA','NA','NA').
solve_basic(p(5,3),largest,_,'NA','NA','NA').
solve_basic(p(5,4),largest,_,'NA','NA','NA').
solve_basic(p(5,5),largest,_,'NA','NA','NA').
solve_basic(p(6,1),largest,_,'NA','NA','NA').
solve_basic(p(5,1),occurrence,_,'NA','NA','NA').
solve_basic(p(5,2),occurrence,_,'NA','NA','NA').
solve_basic(p(5,3),occurrence,_,'NA','NA','NA').
solve_basic(p(5,4),occurrence,_,'NA','NA','NA').
solve_basic(p(5,5),occurrence,_,'NA','NA','NA').
solve_basic(p(6,1),occurrence,_,'NA','NA','NA').
solve_basic(p(2,4),most_constrained,_,'NA','NA','NA').
solve_basic(p(3,1),most_constrained,_,'NA','NA','NA').
solve_basic(p(3,2),most_constrained,_,'NA','NA','NA').
solve_basic(p(3,3),most_constrained,_,'NA','NA','NA').
solve_basic(p(3,4),most_constrained,_,'NA','NA','NA').
solve_basic(p(3,5),most_constrained,_,'NA','NA','NA').
solve_basic(p(4,1),most_constrained,_,'NA','NA','NA').
solve_basic(p(4,2),most_constrained,_,'NA','NA','NA').
solve_basic(p(4,3),most_constrained,_,'NA','NA','NA').
solve_basic(p(4,4),most_constrained,_,'NA','NA','NA').
solve_basic(p(4,5),most_constrained,_,'NA','NA','NA').
solve_basic(p(5,1),most_constrained,_,'NA','NA','NA').
solve_basic(p(5,2),most_constrained,_,'NA','NA','NA').
solve_basic(p(5,3),most_constrained,_,'NA','NA','NA').
solve_basic(p(5,4),most_constrained,_,'NA','NA','NA').
solve_basic(p(5,5),most_constrained,_,'NA','NA','NA').
solve_basic(p(6,1),most_constrained,_,'NA','NA','NA').

% run the puzzle with the given puzzle and a certain search heuristic;
% the amount of backtracks is returned in Back
solve_basic(Puzzle,Selection,Choice,Back,Tprop,Tsearch):-
  statistics(runtime, _),
  problem(Puzzle,W,H,Hints),
  length(Hints,L),
  all_rectangles(W,H,Hints,L,PR), % PR stands for possible rectangles
  no_overlap(PR),
  statistics(runtime,[_|Tprop]), % calculate propagation time
  term_variables(PR, Vars),
  search(Vars,0,Selection,Choice,complete,[backtrack(Back)]),  % set search heuristic parameters
  statistics(runtime,[_|Tsearch]). % calculate search time

% demo: give a difficulty and the solution gets printed
solve_basic_demo(Puzzle):-
  problem(Puzzle,W,H,Hints),
  length(Hints,L),
  all_rectangles(W,H,Hints,L,PR), % PR stands for possible rectangles
  no_overlap(PR),
  term_variables(PR, Vars),
  labeling(Vars),
  show(W,H,Hints,[],ascii),nl,nl,
  show(W,H,Hints,PR,ascii),nl.

% finds all the possible rectangles
all_rectangles(W,H,Hints,L,PR):-
  build_rectangle_list([],W,H,Hints,L,0,PR).
  
% build up all the possible rectangles in the list PR
build_rectangle_list(PR,_,_,_,L,L,PR):- !.
build_rectangle_list(RL,W,H,Hints,L,I,PR):-
  J #= I+1,
  hint_rectangles(W,H,Hints,L,J,Rectangle),
  build_rectangle_list([Rectangle|RL],W,H,Hints,L,J,PR).

% finds all the rectangles for the i-th hint in Hints with the possible
% domain values
hint_rectangles(W,H,Hints,L,I,rect(c(HX,HY),c(X,Y),s(Width,Height))):-
  X::[1..W], % x-coordinate for the topleft corner of the rectangle
  Y::[1..H], % y-coordinate for the topleft corner of the rectangle
  tuple_from_list(I,Hints,HX,HY,S), % HX and HY are the hint coordinates with S the number (size)
  Width::[1..S], % possible width values of the rectangle
  Height::[1..S], % possible height values of the rectangle
  Width*Height #= S, % the area of the rectangle equals the hint number
  X+Width-1 #=< W, % the rectangle must be within the grid borders
  Y+Height-1 #=< H,
  ( for(J,1,L),
      param(HX,HY,X,Y,Width,Height,Hints,I)
    do
      ( I == J ->
        % make sure the hint is inside the rectangle
        HX #>= X, HY #>= Y,
		HX #< X+Width, HY #< Y+Height
        ;
        % make sure the hint is outside the rectangle
        tuple_from_list(J,Hints,OX,OY,_),
		OX #< X or OY #< Y or
		OX #>= X+Width or OY #>= Y+Height
      )
  ).
  
% get tuple from list in given index
tuple_from_list(1,[(X,Y,S)|_],X,Y,S).
tuple_from_list(_,[],_,_,_):- fail.
tuple_from_list(I,[_|R],X,Y,S):-
  J #= I-1,
  tuple_from_list(J,R,X,Y,S).
  
% constraints for non-overlapping rectangles
no_overlap([]):- !.
no_overlap([E|R]):-
  ( no_overlapping_rectangles(E,R) ->
    no_overlap(R)
    ;
    fail
  ).
  
% ok if no rectangles overlap and fail otherwise
no_overlapping_rectangles(_,[]).
no_overlapping_rectangles(Rect,[E|R]):-
  rect(_,c(RX,RY),s(RW,RH)) = Rect,
  rect(_,c(EX,EY),s(EW,EH)) = E,
  ( RX #>= EX+EW or EX #>= RX+RW or
    RY #>= EY+EH or EY #>= RY+RH ->
    no_overlapping_rectangles(Rect,R)
    ;
    fail
  ).
  