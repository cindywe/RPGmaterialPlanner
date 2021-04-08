:- include("facts.pl").


ask(Ans) :-
    write("Ask your question: "), flush_output(current_output),
    nl,
    readln(Q),
    question(Q, Ans).

    

% ------------ QUESTIONS ------------- %
question(['What',materials,required,for,upgrading,to,X,?], Ans) :-
	requires_for_upgrading(X, Ans).
	

question(['How',many,Y,required,for,upgrading,to,X,?], Ans) :-
	material_for_upgrade(career(X), material(type(Y), Ans)).


question(['Can','I',upgrade,to,X,?], Ans) :-
	check_can_upgrade(X, Ans).


question(['How',many,Y,'I',still,need,for,upgrading,to,X,?], Ans) :-
	check_material_diff(Y, X, Ans).


question(['What',materials,can,be,earned,from,stage,X,?], Ans) :-
	list_materials_earned_from_a_stage(X, Ans).


question(['How',many,Y,can,be,earned,from,stage,X,?], Ans) :-
	material_from_Stage(X, material(type(Y), Ans)).


% ------------ LOGICS ------------- %

% requires_for_upgrading(C, Ans) is true if materials M, S, A are required for upgrading to career C.
requires_for_upgrading(C, Ans) :-
	upgrade(career(C), [material(type(magic), Magic), material(type(shield),Shield), material(type(attack),Attack)]),
	string_concat('magic = ', Magic, M),
	string_concat('shield = ', Shield, S),
	string_concat('attack = ', Attack, A),
	Ans = [M, S, A].


check_can_upgrade(X, Ans) :-
    write("How many magic do you have?"), flush_output(current_output),
    nl,
    readln(M),
    write("How many shield do you have?"), flush_output(current_output),
    nl,
    readln(S),
    write("How many attack do you have?"), flush_output(current_output),
    nl,
    readln(A),
    compute_all_materials_diff(X, M, S, A, Ans).


compute_all_materials_diff(C, [MagicOwned], [ShieldOwned], [AttackOwned], Ans) :-
	upgrade(career(C), [material(type(magic), MagicRequired), material(type(shield), ShieldRequired), material(type(attack), AttackRequired)]),
	MagicDiff is MagicRequired - MagicOwned,
	ShieldDiff is ShieldRequired - ShieldOwned,
	AttackDiff is AttackRequired - AttackOwned,
	generate_upgrade_check_msg(C, MagicDiff, ShieldDiff, AttackDiff, Ans).


generate_upgrade_check_msg(Career, MagicDiff, ShieldDiff, AttackDiff, Ans) :- 
(   (MagicDiff =< 0, ShieldDiff =< 0, AttackDiff =< 0) ->
	string_concat('You have enough materials!!! You can now upgrade to ', Career, Msg),
    write(Msg)
;
    write('You cannot upgrade now. Here are the numbers of materials you still require: '),
    getNumRequiredMaterial(MagicDiff, magic, M),
    getNumRequiredMaterial(ShieldDiff, shield, S),
    getNumRequiredMaterial(AttackDiff, attack, A),
	Ans = [M, S, A]
).


check_material_diff(Y, X, Ans) :-
	string_concat('How many ', Y, Temp),
	string_concat(Temp, ' do you have?', Msg),
	write(Msg), flush_output(current_output),
	nl,
    readln(N),
    compute_single_material_diff(X, Y, [N], Ans).


compute_single_material_diff(C, MaterialType, [MaterialOwned], Ans) :-
	material_for_upgrade(career(C), material(type(MaterialType), MagicRequired)),
	write('You still need: '),
	Diff is MagicRequired - MaterialOwned,
	getNumRequiredMaterial(Diff, MaterialType, Ans).


list_materials_earned_from_a_stage(Stage, Ans) :-
	stage(Stage, [material(type(magic),Magic), material(type(shield),Shield), material(type(attack),Attack)]),
	string_concat('magic = ', Magic, M),
	string_concat('shield = ', Shield, S),
	string_concat('attack = ', Attack, A),
	Ans = [M, S, A].


% ----------- HELPER METHODS ---------- %

getNumRequiredMaterial(Num, Material, Ans) :-
(   Num > 0 ->
	string_concat(Material, ' = ', Temp),
	string_concat(Temp, Num, Ans)
;
    string_concat(Material, ' = - ', Ans)
).




