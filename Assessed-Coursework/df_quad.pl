%Devin Nanayakkara (dvn14)
%CO474 - Argumentation and Multi-Agent Systems
%Assessed Coursework
%Part 3 (DF-QuAD)

supporters(I,S) :- findall(X,supports(X,I),S).
attackers(I,A) 	:- findall(X,attacks(X,I),A).
    
base_function(V1,V2,BFV) :-
	BFV is V1+V2-V1*V2.

combination_function(Vo,Vs,Va,C) :-
	Va >= Vs,
	C is Vo-Vo*abs(Vs-Va).
	
combination_function(Vo,Vs,Va,C) :-
	Va < Vs,
	C is Vo+(1-Vo)*abs(Vs-Va).

strength_function([],V,K) :- !,
	K is V.

strength_function([H|T],0,K) :- !,
	calc_strength(H,Val),
	base_function(0,Val,BFV),
	strength_function(T,BFV,K).
	
strength_function([H|T],V,K) :-
	calc_strength(H,Val),
	base_function(V,Val,BFV),
	strength_function(T,BFV,K).

calc_strength(I,Val) :-
	\+ attacks(_,I),
	\+ supports(_,I), !,
	base(I,B),
	Val is B.
	
calc_strength(I,Val) :-
	\+ attacks(_,I),
	supporters(I,S), !,
	strength_function(S,0,Vs),
	base(I,B),
	combination_function(B,Vs,0,C),
	Val is C.
	
calc_strength(I,Val) :-
	\+ supports(_,I),
	attackers(I,A), !,
	strength_function(A,0,Va),
	base(I,B),
	combination_function(B,0,Va,C),
	Val is C.
	
calc_strength(I,Val) :-
	supporters(I,S),
    attackers(I,A), !,
	strength_function(A,0,Va),
	strength_function(S,0,Vs),
	base(I,B),
	combination_function(B,Vs,Va,C),
	Val is C.

strength(I,X) :-
	var(X),
	calc_strength(I,Y),
	X is Y.

strength(I,X) :-
	argument(I),
	calc_strength(I,Y),
	X == Y.
