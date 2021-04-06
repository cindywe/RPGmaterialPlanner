:- include("facts.pl").


ask :-
    write("What is the career you want to upgrade to? "), flush_output(current_output),
    nl,
    readln(Q),
    question(Q, Ans),
    write("You need: "),
	write(Ans).


% ----- Test cases -----
% ?- ask.
% What is the career you want to upgrade to? 
% |: mage
% You need: [Magic = 14,Shield = 2,Attack = 4]


ask(Ans) :-
    write("Ask your question below: "), flush_output(current_output),
    nl,
    readln(Q),
    question(Q, Ans).


% ----- Test cases -----
% ?- ask(Ans).
% Ask your question below: 
% |: What materials required for upgrading to fighter?
% Ans = ["Magic = 4", "Shield = 4", "Attack = 12"].


% ?- ask(Ans).
% Ask your question below: 
% |: How many attack required for upgrading to fighter?
% Ans = 12.


% ------------ QUESTIONS ------------- %
question([X], Ans) :-
	requires_for_upgrading(X, Ans).

question(['What',materials,required,for,upgrading,to,X,?], Ans) :-
	requires_for_upgrading(X, Ans).
	

question(['How',many,Y,required,for,upgrading,to,X,?], Ans) :-
	material_for_upgrade(career(X), material(type(Y), Ans)).


% ------------ LOGICS ------------- %

% requires_for_upgrading(C, MList) is true if materials M, S, A are required for upgrading to career C.
requires_for_upgrading(C, MList) :-
	upgrade(career(C), [material(type(magic), Magic), material(type(shield),Shield), material(type(attack),Attack)]),
	string_concat('Magic = ', Magic, M),
	string_concat('Shield = ', Shield, S),
	string_concat('Attack = ', Attack, A),
	MList = [M, S, A].
