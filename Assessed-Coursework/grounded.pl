%Devin Nanayakkara (dvn14)
%CO474 - Argumentation and Multi-Agent Systems
%Assessed Coursework
%Part 1 (AA)

attackers(I,A) 	:- findall(X,attacks(X,I),A).

defence_from_attacks(_,[]) :- !.
defence_from_attacks(X,[H|T]) :-
	attacks(Y,H),
    \+ attacks(Y,X),
	grounded(Y),
    defence_from_attacks(X,T).

%checks_self_attacks
grounded(X) :-
	attacks(X,X),!,fail.

%checks_attacks_between_themselves
grounded(X) :-
	attacks(X,Y),
	attacks(Y,X),!,fail.

%checks_unattacked
grounded(X) :-
	argument(X),
	\+ attacks(_,X) ,!.

%checks_defence_against_attacks
grounded(X) :-
    argument(X),
	attackers(X,A),
	defence_from_attacks(X,A).
