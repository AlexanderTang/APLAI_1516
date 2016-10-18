:- lib(viewable).
:- lib(ic).
%:- lib(suspend).

:- compile("lib/sudex_toledo").
:- compile("traditional_solution").

% For the alternative solution, the dual viewpoint has been chosen:
% The variables are the values 1 to 9 and the values become the row and column numbers

% list of banned heuristics/puzzles due to too large computation times:
solve_alternative(_,anti_first_fail,_,'NA','NA','NA').
solve_alternative(veryeasy,smallest,_,'NA','NA','NA').
solve_alternative(veryeasy,largest,_,'NA','NA','NA').
solve_alternative(veryeasy,occurrence,_,'NA','NA','NA').

% run the puzzle with the given difficulty and a certain search heuristic;
% the amount of backtracks, propagation time and search time are returned
solve_alternative(Difficulty,Selection,Choice,Back,Tprop,Tsearch):-
  statistics(runtime, _),
  alt_domain(Dom), % initialize domain
  puzzles(P,Difficulty), % select a puzzle from the given difficulty
  dim(Sudoku,[9,9]),
  convertVectorsToArray(Sudoku,P,1),
  %viewable_create(sudoku_board, Sudoku),
  init_board_domain(Dom,Sudoku),
  alt_constraints(Dom),  % initialize constraints
  statistics(runtime,[_|Tprop]), % calculate propagation time
  term_variables(Dom, Vars),
  search(Vars,0,Selection,Choice,complete,[backtrack(Back)]),  % set search heuristic parameters
  statistics(runtime,[_|Tsearch]). % calculate search time
  
 % purpose of connect_board_domain: display Dom to Sudoku grid format to more easily interpret 
 % the solution. This is only done in the demo version to not interfere with the calculation 
 % time of the alternative view.
alt_demo:-
  alt_solve_demo(Dom,Sudoku,verydifficult),nl,
  print_array(Dom),nl,
  connect_board_domain(Dom,Sudoku),
  print_board(Sudoku).

% demo: give a difficulty and the solution gets returned as Dom
alt_solve_demo(Dom,Sudoku,Difficulty):-
  alt_domain(Dom), % initialize domain
  puzzles(P,Difficulty), % select a puzzle from the given difficulty
  dim(Sudoku,[9,9]),
  convertVectorsToArray(Sudoku,P,1),
  print_board(Sudoku),
  %viewable_create(sudoku_board, Sudoku),
  init_board_domain(Dom,Sudoku),
  alt_constraints(Dom),  % initialize constraints
  write('propagation is done'),nl,
  term_variables(Dom, Vars),
  labeling(Vars).
    
% the domain: 3d array of which:
%               the first element represents the number in the grid,
%               the second element is one of the 9 possible X,Y tuples (but are set in place by the block 
%                 number: 1 for the second element means the X,Y tuple is within the topleft subsquare) and 
%               the third argument are the elements of the tuple: 1 for X and 2 for Y;
%             I chose for a 3d array over a list of 9 values with each value having another
%             sublist of 9 tuples because selecting elements in arrays is faster than the (linked) lists
alt_domain(D):-
  dim(D,[9,9,2]),
  D[1..9,1..9,1..2] :: 1..9.
  
% collect the filled in numbers from the board and integrate it with the domain
init_board_domain(Dom,Sudoku):-
  ( for(I,1,9), param(Dom,Sudoku)
    do
      ( for(J,1,9), param(I,Dom,Sudoku)
        do
          X #= Sudoku[I,J],
          get_domain_size(X,Size),
          ( Size == 1 ->
            block_number(I,J,B),
            Dom[X,B,1] #= I,
            Dom[X,B,2] #= J
            ;
            true
          )
      )
  ).
  
% return the block number based on coordinates
block_number(I,J,B):-
  X is I-1,
  Y is J-1,
  B #= (X // 3)*3 + (Y // 3) + 1.

% connect the board with the domain variables for display purposes
connect_board_domain(Dom,Sudoku):-
  ( for(I,1,9), param(Dom,Sudoku)
    do
      ( for(J,1,9), param(I,Dom,Sudoku)
        do
          X #= Dom[I,J,1],
          Y #= Dom[I,J,2],
          Sudoku[X,Y] #= I
      )
  ).
  
% the constraints
alt_constraints(D):-
  ( for(I,1,9),
      param(D)%, foreach(E,L)
    do
      Row is D[I,1..9,1], 
      Col is D[I,1..9,2], 
      ic_global:alldifferent(Row), % constraints for different rows per value
      ic_global:alldifferent(Col) % constraints for different columns per value
  ),

  % constraints to prevent different values from getting the same tuples
  ( for(I,1,9), param(D), foreach(TL,L)
    do
      ( for(J,1,9), param(D,I), foreach(E,TL)
        do
          X is D[I,J,1],
          Y is D[I,J,2],
          E #= X * 10 + Y
      )
  ),
  flatten(L,NL),
  ic_global:alldifferent(NL),
  
  % constraints that binds the possible coordinate values to the correct block and this
  % entails that every value is assigned exactly once for each block (so it's the block constraint)
  ( multifor([V,B],1,9),param(D)
    do
      X is D[V,B,1],
      Y is D[V,B,2],
      
      Xmin is (((B-1) // 3)*3)+1, Xmax is Xmin + 2,
      Ymin is (mod(B-1,3)*3)+1, Ymax is Ymin + 2,
      
      Xmin #=< X, Xmax #>= X, Ymin #=< Y, Ymax #>= Y
      
      % This code is replaced by the more 'clean' code above, but still shows the reasoning;
      % there appears to be a small increase in computation time with the above code,
      % but unimportant in the overall picture
      /**  
      ( B == 1 ->
        X #=< 3, Y #=< 3
        ;
        ( B == 2->
          X #=< 3, Y #>= 4, Y #=< 6
          ;
          ( B == 3 ->
            X #=< 3, Y #>= 7
            ;
            ( B == 4 ->
              X #>= 4, X #=< 6, Y #=< 3
              ;
              ( B == 5 ->
                X #>= 4, X #=< 6, Y #>= 4, Y #=< 6
                ;
                ( B == 6 ->
                  X #>= 4, X #=< 6, Y #>= 7
                  ;
                  ( B == 7 ->
                    X #>= 7, Y #=< 3
                    ;
                    ( B == 8 ->
                      X #>= 7, Y #>= 4, Y #=< 6
                      ;
                      ( B == 9 ->
                        X #>= 7, Y #>= 7
                      )
                    )
                  )
                )
              )
            )
          )
        )
      )*/
  ).
  
% print domain array
print_array(A):-
  ( for(I,1,9), param(A)
    do
      write('value '),write(I),write(': '),
      ( for(J,1,9), param(A,I)
        do
          X is A[I,J,1], Y is A[I,J,2],
          write('t('),write(X),write(','),write(Y),write(') ')
      ),
      nl
  ).