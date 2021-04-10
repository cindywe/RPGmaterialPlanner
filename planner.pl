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


question(['How',long,does,stage,Y,take,?], Ans) :-
	stage_time(Y, T),
	string_concat(T, ' minute(s)', Ans).


question(['How',can,'I',upgrade,to,X,?], Ans) :-
    provide_suggestion(X).



% ------------ LOGICS ------------- %

% check_requires_for_upgrading(Career, Ans) is true if Ans are materials required for upgrading to Career.
check_requires_for_upgrading(Career, Ans) :-
	upgrade(career(Career), [material(type(magic), Magic), material(type(shield),Shield), material(type(attack),Attack)]),
	string_concat('magic = ', Magic, M),
	string_concat('shield = ', Shield, S),
	string_concat('attack = ', Attack, A),
	Ans = [M, S, A].


% check_can_upgrade(Career, Ans) is true if Ans is a message indicating whether it is possible to upgrade to Career.
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


% get_all_material_required(Career, MagicOwned, ShieldOwned, AttackOwned, Ans) is true if Ans is a message indicating 
% whether it is possible to upgrade to Career with MagicOwned, ShieldOwned and AttackOwned
get_all_material_required(Career, MagicOwned, ShieldOwned, AttackOwned, Ans) :-
	get_all_materials_diff(Career, MagicOwned, ShieldOwned, AttackOwned, MagicDiff, ShieldDiff, AttackDiff),
	(   (MagicDiff =< 0, ShieldDiff =< 0, AttackDiff =< 0) ->
	string_concat('Congrat!!! You have enough materials for upgrading to ', Career, Ans)
;
    write('Sorry!!! You cannot upgrade now. You still need: '),
    generate_required_material_string(MagicDiff, magic, M),
    generate_required_material_string(ShieldDiff, shield, S),
    generate_required_material_string(AttackDiff, attack, A),
	Ans = [M, S, A]
).


% check_single_material_required(MaterialType, Career, Ans) is true if Ans is a message indicating the number of MaterialType required for upgrading to Career 
check_single_material_required(MaterialType, Career, Ans) :-
	string_concat('How many ', MaterialType, Temp),
	string_concat(Temp, ' do you have?', Msg),
	write(Msg), flush_output(current_output),
	nl,
    readln(N),
    calculate_material_diff(Career, MaterialType, N, Diff),
	(   Diff > 0 ->
		string_concat('You still need: ', Diff, Ans)
	;
	    string_concat('You have enough ', MaterialType, Ans)
	).


% list_materials_earned_from_a_stage(N, Ans) is true if Ans is a list of materials can be earned from stage N
list_materials_earned_from_a_stage(N, Ans) :-
	stage(N, [material(type(magic),Magic), material(type(shield),Shield), material(type(attack),Attack)]),
	string_concat('magic = ', Magic, M),
	string_concat('shield = ', Shield, S),
	string_concat('attack = ', Attack, A),
	Ans = [M, S, A].


% check_num_of_times(N, Career, Ans) is true 
check_num_of_times(N, Career, Ans) :-
	write("How many magic do you have?"), flush_output(current_output),
    nl,
    readln(Magic),
    write("How many shield do you have?"), flush_output(current_output),
    nl,
    readln(Shield),
    write("How many attack do you have?"), flush_output(current_output),
    nl,
    readln(Attack),
    get_num_of_times(Career, N, Magic, Shield, Attack, Ans).



% get_num_of_times(Career, N, Magic, Shield, Attack, Ans) is true if Ans is a message indicating 
% the number of times user has to clear stage N to earn enough Magic, Shield, Attack
get_num_of_times(Career, N, MagicOwned, ShieldOwned, AttackOwned, Ans) :-
	get_all_materials_diff(Career, MagicOwned, ShieldOwned, AttackOwned, MagicDiff, ShieldDiff, AttackDiff),
(   (MagicDiff =< 0, ShieldDiff =< 0, AttackDiff =< 0) ->
	string_concat('Congrat!!! You already have enough materials for upgrading to ', Career, Ans)
;
	calculate_num_times(N, MagicDiff, ShieldDiff, AttackDiff, NumTimes),
	stage_time(N, TimeSpent),
	TotalTime is NumTimes * TimeSpent,
	string_concat('You have to clear it ', NumTimes, Temp),
	string_concat(Temp, ' time(s). It will takes you ', Msg1),
	string_concat(Msg1, TotalTime, Msg2),
	string_concat(Msg2, ' min ', Ans)
).

provide_suggestion(C) :-
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
    suggest_stage_and_time(C, Stage, Magic, Shield, Attack).


suggest_stage_and_time(Career, CurrentStage, MagicOwned, ShieldOwned, AttackOwned) :-
	get_all_materials_diff(Career, MagicOwned, ShieldOwned, AttackOwned, MagicDiff, ShieldDiff, AttackDiff),
(   (MagicDiff =< 0, ShieldDiff =< 0, AttackDiff =< 0) ->
	string_concat('Congrat!!! You already have enough materials for upgrading to ', Career, Msg),
	write(Msg)
;
    write("You can upgrade by one of the following ways: "),
    nl,
    get_eligible_stages(CurrentStage, [1,2,3,4,5,6], StagesList),
    get_stages_and_times_tuples(Career, MagicDiff, ShieldDiff, AttackDiff, StagesList, Ans),
    print_stages_and_times(Ans)
).


% print_stages_and_times(L) is true if L is a list of triples containing (stage, number of times, total duration for the stage)
print_stages_and_times([]).
print_stages_and_times([(S,N,D)|T]) :-
	string_concat('Clear stage: ', S, Temp1),
	string_concat(' => ', N, Temp2),
	string_concat(Temp1, Temp2, Temp3),
	string_concat(' times; total ', D, Temp4),
	string_concat(Temp4, ' min', Temp5),
	string_concat(Temp3, Temp5, Msg),
	write(Msg),
	nl,
	print_stages_and_times(T).



% ----------- HELPER METHODS ---------- %

% generate_required_material_string(Num, Material, Ans) is true if Ans is a formatted string indicating number of material
generate_required_material_string(Num, Material, Ans) :-
(   Num > 0 ->
	string_concat(Material, ' = ', Temp),
	string_concat(Temp, Num, Ans)
;
    string_concat(Material, ' = - ', Ans)
).


% get_all_materials_diff(Career, MagicOwned, ShieldOwned, AttackOwned, MagicDiff, ShieldDiff, AttackDiff) is true 
% if MagicDiff, ShieldDiff, AttackDiff are differences between material required for upgrading to Career and materials owned.
get_all_materials_diff(Career, MagicOwned, ShieldOwned, AttackOwned, MagicDiff, ShieldDiff, AttackDiff) :-
	calculate_material_diff(Career, magic, MagicOwned, MagicDiff),
	calculate_material_diff(Career, shield, ShieldOwned, ShieldDiff),
	calculate_material_diff(Career, attack, AttackOwned, AttackDiff).


% calculate_material_diff(Career, MaterialType, MaterialOwned, Diff) is true 
% if Diff is a difference between material required for upgrading to Career and material owned for specific MaterialType
calculate_material_diff(Career, MaterialType, MaterialOwned, Diff) :-
	material_for_upgrade(career(Career), material(type(MaterialType), MagicRequired)),
	Diff is MagicRequired - MaterialOwned.


% calculate_num_times(N, MagicDiff, ShieldDiff, AttackDiff, NumTimes) is true 
% if NumTimes is number of times to clear stage N in order to earn target number of materials (MagicDiff, ShieldDiff, AttackDiff) 
calculate_num_times(N, MagicDiff, ShieldDiff, AttackDiff, NumTimes) :-
	stage(N, [material(type(magic), MagicEarned), material(type(shield), ShieldEarned), material(type(attack), AttackEarned)]),
    X is ceiling(MagicDiff/MagicEarned),
	Y is ceiling(ShieldDiff/ShieldEarned),
	Z is ceiling(AttackDiff/AttackEarned),
	max([X, Y, Z], NumTimes).


% get_eligible_stages(Y, L, R) is true if R contains the stages from the L, such stage is less than or equal to Y or equal to Y + 1
get_eligible_stages(_, [],[]).

get_eligible_stages(Y, [H|T], [H|Result]) :- 
    (H =:= (Y + 1) ; (H =< Y)),
    get_eligible_stages(Y, T, Result).

get_eligible_stages(Y, [H|T], Result) :- 
	H > (Y + 1),
    get_eligible_stages(Y, T, Result).


get_stages_and_times_tuples(_, _, _, _, [],[]).
get_stages_and_times_tuples(Career, MagicDiff, ShieldDiff, AttackDiff, [H|T], [(H,NumTimes,Duration)|Ans]) :-
	calculate_num_times(H, MagicDiff, ShieldDiff, AttackDiff, NumTimes),
	stage_time(H, TimeSpent),
	Duration is NumTimes * TimeSpent,
	get_stages_and_times_tuples(Career, MagicDiff, ShieldDiff, AttackDiff, T, Ans).


% Reference: https://stackoverflow.com/questions/25838827/prolog-max-in-a-list
% max(L, M) is true if M is the maximum in the list L
max([Max], Max).
max([Head | List], Max) :-
  max(List, MaxList),
  (Head > MaxList -> Max = Head ; Max = MaxList ).









