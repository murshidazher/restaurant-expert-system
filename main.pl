/* 
Copyright (C) 2020  Murshid Azher
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program.
If not, see 
<https://github.com/murshidazher/restaurant-expert-system/blob/master/LICENSE>
*/

% Module: main.pl
% --------
%
% This module contains the inference engine of the system. This constitute 
% the core of restaurant-expert-system

:- op(900,xfy, :).

/* start of the system */
go :- 
      main,
      !.

greeting :-
      write('\tWelcome to menu recommendation for x restaurant.'), nl,
      native_help.

/* how to ask questions */ 
ask(Question) :- 
        write(' > Do you love food with the following attribute: '), 
        write(Question), write('? \n'), 
        write(' > '),
         read(Response), nl, 
         ( (Response == yes ; Response == y) 
         -> assert(yes(Question)) ; 
         assert(no(Question)), fail). 
:- dynamic yes/1,no/1. 
/* How to verify something */ 
verify(S) :- (yes(S) -> true ; (no(S) -> fail ; ask(S))). 

/* undo all yes/no assertions */ 
undo :- retract(yes(_)),fail. 
undo :- retract(no(_)),fail. 
undo.

/* menu */
main :-
    greeting,
    repeat,
    write(' > '),
    read(X),
    do(X),
    X == 4.
  

native_help :-
    write('\n\tPlease Choose What to Do:\n\t[1.] - Load the Menu \n\t[2.] - Recommend\n\t[3.] - Help\n\t[4.] - Quit\n '), nl.
    % write('Type help. | load. | recommend. | quit.'), nl,
    % write('at the prompt.'), nl.

do(1) :-
    load_kb,
    !.

/* start the recommender */
do(2) :-
    write('\n\t[y.] - yes | [n.] - no \n'), nl,
    hypothesize(Food), 
    write('  We guess you would love - '), 
    write(Food), nl.

do(3) :-
    native_help,
    !.

do(4) :-
    write('\n\t\t\tThank you for using this system.'),
    halt.

/* not a correct command */
do(X) :-
    write('   '),
    write(X),
    write(' is not a legal command.'), nl,
    fail.

/* load the knowledge base */
load_kb :-
    write(' > Enter file name in single quotes (ex. ''example.nkb''.):'), nl,
    repeat,
    write(' > '),
    read(F),
    reconsult(F).
   