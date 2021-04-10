:- include("facts.pl").


ask(Ans) :-
    write("Ask your question: "), flush_output(current_output),
    nl,
    readln(Q),
    question(Q, Ans).

    

% ------------ QUESTIONS ------------- %
question(['What',materials,required,for,upgrading,to,X,?], Ans) :-
	check_requires_for_upgrading(X, Ans).
	

question(['How',many,Y,required,for,upgrading,to,X,?], Ans) :-
	material_for_upgrade(career(X), material(type(Y), Ans)).


question(['Can','I',upgrade,to,X,?], Ans) :-
	check_can_upgrade(X, Ans).


question(['How',many,Y,'I',still,need,for,upgrading,to,X,?], Ans) :-
	check_single_material_required(Y, X, Ans).


question(['What',materials,can,be,earned,from,stage,X,?], Ans) :-
	list_materials_earned_from_a_stage(X, Ans).


question(['How',many,Y,can,be,earned,from,stage,X,?], Ans) :-
	material_from_Stage(X, material(type(Y), Ans)).


question(['How',many,times,do,'I',have,to,clear,stage,Y,for,upgrading,to,X,?], Ans) :-
	check_num_of_times(Y, X, Ans).

% IN PROGRESS
question(['How',can,'I',upgrade,to,X,?], Ans) :-
	provide_suggestion(X, Ans).


% ------------ LOGICS ------------- %

% check_requires_for_upgrading(C, Ans) is true if materials M, S, A are required for upgrading to career C.
check_requires_for_upgrading(C, Ans) :-
	upgrade(career(C), [material(type(magic), Magic), material(type(shield),Shield), material(type(attack),Attack)]),
	string_concat('magic = ', Magic, M),
	string_concat('shield = ', Shield, S),
	string_concat('attack = ', Attack, A),
	Ans = [M, S, A].


check_can_upgrade(Career, Ans) :-
    write("How many magic do you have?"), flush_output(current_output),
    nl,
    readln(M),
    write("How many shield do you have?"), flush_output(current_output),
    nl,
    readln(S),
    write("How many attack do you have?"), flush_output(current_output),
    nl,
    readln(A),
    get_all_material_required(Career, M, S, A, Ans).


get_all_material_required(Career, MagicOwned, ShieldOwned, AttackOwned, Ans) :-
	get_all_materials_diff(Career, MagicOwned, ShieldOwned, AttackOwned, MagicDiff, ShieldDiff, AttackDiff),
	generate_upgrade_check_msg(Career, MagicDiff, ShieldDiff, AttackDiff, Ans).	


generate_upgrade_check_msg(Career, MagicDiff, ShieldDiff, AttackDiff, Ans) :- 
(   (MagicDiff =< 0, ShieldDiff =< 0, AttackDiff =< 0) ->
	string_concat('Congrat!!! You have enough materials for upgrading to ', Career, Ans)
;
    write('Sorry!!! You cannot upgrade now. You still need: '),
    generate_required_material_string(MagicDiff, magic, M),
    generate_required_material_string(ShieldDiff, shield, S),
    generate_required_material_string(AttackDiff, attack, A),
	Ans = [M, S, A]
).


check_single_material_required(Y, X, Ans) :-
	string_concat('How many ', Y, Temp),
	string_concat(Temp, ' do you have?', Msg),
	write(Msg), flush_output(current_output),
	nl,
    readln(N),
    get_single_material_diff(X, Y, [N], Ans).


get_single_material_diff(C, MaterialType, [MaterialOwned], Ans) :-
	calculate_material_diff(C, MaterialType, MaterialOwned, Diff),
	(   Diff > 0 ->
		string_concat('You still need: ', Diff, Ans)
	;
	    string_concat('You have enough ', MaterialType, Ans)
	).


list_materials_earned_from_a_stage(Stage, Ans) :-
	stage(Stage, [material(type(magic),Magic), material(type(shield),Shield), material(type(attack),Attack)]),
	string_concat('magic = ', Magic, M),
	string_concat('shield = ', Shield, S),
	string_concat('attack = ', Attack, A),
	Ans = [M, S, A].


check_num_of_times(Stage, Career, Ans) :-
	write("How many magic do you have?"), flush_output(current_output),
    nl,
    readln(Magic),
    write("How many shield do you have?"), flush_output(current_output),
    nl,
    readln(Shield),
    write("How many attack do you have?"), flush_output(current_output),
    nl,
    readln(Attack),
    get_num_of_times(Career, Stage, Magic, Shield, Attack, Ans).


% get_num_of_times(Career, Stage, Magic, Shield, Attack, Ans) is true if Ans is the number of times user has to clear stage S to earn enough Magic, Shield, Attack
get_num_of_times(Career, Stage, MagicOwned, ShieldOwned, AttackOwned, Ans) :-
	stage(Stage, [material(type(magic), MagicEarned), material(type(shield), ShieldEarned), material(type(attack), AttackEarned)]),
	get_all_materials_diff(Career, MagicOwned, ShieldOwned, AttackOwned, MagicDiff, ShieldDiff, AttackDiff),
(   (MagicDiff =< 0, ShieldDiff =< 0, AttackDiff =< 0) ->
	string_concat('You already have enough materials for upgrading to ', Career, Ans)
;
    X is ceiling(MagicDiff/MagicEarned),
	Y is ceiling(ShieldDiff/ShieldEarned),
	Z is ceiling(AttackDiff/AttackEarned),
	string_concat('Number of times you have to clear stage ', Stage, Msg),
	write(Msg),
	max([X, Y, Z], Ans)
).

% IN PROGRESS
provide_suggestion(C, Ans) :-
	write("What is the highest stage level you have cleared"), flush_output(current_output),
    nl,
    readln(Stage),
	write("How many magic do you have?"), flush_output(current_output),
    nl,
    readln(Magic),
    write("How many shield do you have?"), flush_output(current_output),
    nl,
    readln(Shield),
    write("How many attack do you have?"), flush_output(current_output),
    nl,
    readln(Attack),
    suggest_stage_and_time(C, Stage, Magic, Shield, Attack, Ans).


% IN PROGRESS
suggest_stage_and_time(Career, CurrentStage, MagicOwned, ShieldOwned, AttackOwned, Ans) :-
	get_all_materials_diff(Career, MagicOwned, ShieldOwned, AttackOwned, MagicDiff, ShieldDiff, AttackDiff),
(   (MagicDiff =< 0, ShieldDiff =< 0, AttackDiff =< 0) ->
	string_concat('Congrat!!! You already have enough materials for upgrading to ', Career, Ans)
;
    write("Here are ways for you to upgrade: "),
    get_eligible_stages(CurrentStage, [1,2,3,4,5,6], Ans)
).



% ----------- HELPER METHODS ---------- %

generate_required_material_string(Num, Material, Ans) :-
(   Num > 0 ->
	string_concat(Material, ' = ', Temp),
	string_concat(Temp, Num, Ans)
;
    string_concat(Material, ' = - ', Ans)
).


get_all_materials_diff(Career, MagicOwned, ShieldOwned, AttackOwned, MagicDiff, ShieldDiff, AttackDiff) :-
	calculate_material_diff(Career, magic, MagicOwned, MagicDiff),
	calculate_material_diff(Career, shield, ShieldOwned, ShieldDiff),
	calculate_material_diff(Career, attack, AttackOwned, AttackDiff).


calculate_material_diff(Career, MaterialType, MaterialOwned, Diff) :-
	material_for_upgrade(career(Career), material(type(MaterialType), MagicRequired)),
	Diff is MagicRequired - MaterialOwned.



% get_eligible_stages(Y, L, R) is true if R contains the stages from the L, such stage is less than or equal to Y or equal to Y + 1
get_eligible_stages(_, [],[]).

get_eligible_stages(Y, [X|T], [X|Result]) :- 
	X =:= (Y + 1),
	get_eligible_stages(Y, T, Result).

get_eligible_stages(Y, [X|T], [X|Result]) :- 
	X =< Y,
	get_eligible_stages(Y, T, Result).

get_eligible_stages(Y, [H|T], Result) :-  
	get_eligible_stages(Y, T, Result).

	

% Reference: https://stackoverflow.com/questions/25838827/prolog-max-in-a-list
max([Max], Max).
max([Head | List], Max) :-
  max(List, MaxList),
  (Head > MaxList -> Max = Head ; Max = MaxList ).



