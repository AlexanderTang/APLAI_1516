:- lib(viewable).
:- lib(ic).

:- compile("lib/sudex_toledo").

% run the puzzle with the given difficulty and a certain search heuristic;
% the amount of backtracks, propagation time and search time are returned
solve_traditional(Difficulty,Selection,Choice,Back,Tprop,Tsearch):-
  statistics(runtime, _),
  trad_domain(Sudoku),  % initialize domain
  puzzles(P,Difficulty), % select a puzzle from the given difficulty
  convertVectorsToArray(Sudoku,P,1),
  %viewable_create(sudoku_board, Sudoku),
  trad_constraints(Sudoku),  % initialize constraints
  statistics(runtime,[_|Tprop]), % calculate propagation time
  term_variables(Sudoku, Vars),
  search(Vars,0,Selection,Choice,complete,[backtrack(Back)]),  % set search heuristic parameters
  statistics(runtime,[_|Tsearch]). % calculate search time
  %print_board(Sudoku).
  
trad_demo:-
  trad_solve_demo(Sudoku,verydifficult),
  print_board(Sudoku).
  
% demo: give a difficulty and the solution gets returned as Sudoku
trad_solve_demo(Sudoku,Difficulty):-
  trad_domain(Sudoku),  % initialize domain
  puzzles(P,Difficulty), % select a puzzle from the given difficulty
  convertVectorsToArray(Sudoku,P,1),
  %viewable_create(sudoku_board, Sudoku),
  trad_constraints(Sudoku),  % initialize constraints
  term_variables(Sudoku, Vars),
  labeling(Vars).
    
% the domain
trad_domain(P):-
  dim(P,[9,9]),
  P[1..9,1..9] :: 1..9.

% the constraints
trad_constraints(P):-
  % alldifferent_matrix(P)    % Not using this method since the API indicates it may contain bugs.
  ( for(I,1,9),
      param(P)
    do
      Row is P[I,1..9],
	  Col is P[1..9,I],
      ic_global:alldifferent(Row), % constraints for different values in rows
      ic_global:alldifferent(Col)  % constraints for different values in columns
  ),
  
  % constraints for different values in blocks
  ( multifor([I,J],1,9,3),
      param(P) 
    do
	  ( multifor([K,L],0,2), 
          param(P,I,J), foreach(X,SubSquare) 
        do
	      X is P[I+K,J+L]
	  ),
	  ic_global:alldifferent(SubSquare)
  ).
  
% convert the vectors in the puzzle to arrays
convertVectorsToArray(_,[],_).
convertVectorsToArray(Sudoku,[Y|Rest],Count):-
    X is Sudoku[Count],
    array_list(X, Y),
    NewCount is Count + 1,
    convertVectorsToArray(Sudoku,Rest,NewCount).
 
% print the elements of each list under each other (sudoku in grid format)
printlist([]).
printlist([X|List]) :-
  write(X),nl,
  printlist(List).
 
% print the elements of the array matrix (sudoku in grid format)
print_board(Board) :-
	dim(Board, [N,N]),
	( for(I,1,N), param(Board,N) do
	    ( for(J,1,N), param(Board,I) do
	    	X is Board[I,J],
		( var(X) -> write("  _") ; printf(" %2d", [X]) )
	    ), nl
	), nl.

    
    
    
    
    
/**
    OTHER APPROACH BELOW (from http://eclipseclp.org/examples/sudoku.ecl.txt)
    The solution below is not used, but was largely the inspiration to the solution for the traditional viewpoint.
*/
    
solve_other(ProblemName) :-
	problem(ProblemName, Board),
	print_board(Board),
	sudoku(3, Board),
	print_board(Board).


sudoku(N, Board) :-
	N2 is N*N,
	dim(Board, [N2,N2]),
	Board[1..N2,1..N2] :: 1..N2,
	( for(I,1,N2), param(Board,N2) do
	    Row is Board[I,1..N2],
	    alldifferent(Row),
	    Col is Board[1..N2,I],
	    alldifferent(Col)
	),
	( multifor([I,J],1,N2,N), param(Board,N) do
	    ( multifor([K,L],0,N-1), param(Board,I,J), foreach(X,SubSquare) do
		X is Board[I+K,J+L]
	    ),
	    alldifferent(SubSquare)
	),
	term_variables(Board, Vars),
	labeling(Vars).
    
problem(1, [](
    [](_, _, 2, _, _, 5, _, 7, 9),
    [](1, _, 5, _, _, 3, _, _, _),
    [](_, _, _, _, _, _, 6, _, _),
    [](_, 1, _, 4, _, _, 9, _, _),
    [](_, 9, _, _, _, _, _, 8, _),
    [](_, _, 4, _, _, 9, _, 1, _),
    [](_, _, 9, _, _, _, _, _, _),
    [](_, _, _, 1, _, _, 3, _, 6),
    [](6, 8, _, 3, _, _, 4, _, _))).