:- include("facts.pl").
:- include("info.pl").

start :-
    write('Welcome to RPG Material Planner!!!'),
    nl,
    write('- To ask questions: ask(Ans).'),
    nl,
    write('- To view info: info. '),
    nl.

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


question(['How',can,'I',upgrade,to,X,?], _) :-
    provide_suggestion(X).


question(['What',is,the,best,way,for,me,to,upgrade,to,X,?], _) :-
    provide_best_option(X).



% ------------ LOGICS ------------- %

% check_requires_for_upgrading(Career, Ans) is true if Ans are materials required for upgrading to Career.
check_requires_for_upgrading(Career, Ans) :-
	upgrade(career(Career), [material(type(magic), Magic), material(type(shield),Shield), material(type(attack),Attack)]),
	string_concat('magic = ', Magic, M),
	string_concat('shield = ', Shield, S),
	string_concat('attack = ', Attack, A),
	Ans = [M, S, A].


% check_can_upgrade(Career, Ans) is true if Ans is a message indicating whether
% user have enough materials to upgrade to Career
check_can_upgrade(Career, Ans) :-
    ask_num_materials_owned(Magic, Shield, Attack),
    get_all_material_required(Career, Magic, Shield, Attack, Ans).


% get_all_material_required(Career, MagicOwned, ShieldOwned, AttackOwned, Ans) is true if Ans is a message indicating
% whether user can upgrade to Career with MagicOwned, ShieldOwned and AttackOwned
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


% check_num_of_times(N, Career, Ans) is true if Ans indicates number of times
% user has to clear stage N in order to upgrade to Career
check_num_of_times(N, Career, Ans) :-
	ask_num_materials_owned(Magic, Shield, Attack),
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

% provide_suggestion(Career) takes user input and provides all possible stages that
% users can complete in order to upgrading to Career
provide_suggestion(Career) :-
	write("What is the highest stage level you have cleared? "), flush_output(current_output),
    nl,
    readln(Stage),
	ask_num_materials_owned(Magic, Shield, Attack),
    get_all_options(Career, Stage, Magic, Shield, Attack).


% get_all_options(Career, CurrentStage, MagicOwned, ShieldOwned, AttackOwned)
% gets all options for the user to upgrade to Career
get_all_options(Career, CurrentStage, MagicOwned, ShieldOwned, AttackOwned) :-
	get_all_materials_diff(Career, MagicOwned, ShieldOwned, AttackOwned, MagicDiff, ShieldDiff, AttackDiff),
(   (MagicDiff =< 0, ShieldDiff =< 0, AttackDiff =< 0) ->
	string_concat('Congrat!!! You already have enough materials for upgrading to ', Career, Msg),
	write(Msg)
;
    write("You can upgrade by one of the following ways: "),
    nl,
    get_eligible_stages(CurrentStage, [1,2,3,4,5,6], StagesList),
    get_stages_and_times_tuples(Career, MagicDiff, ShieldDiff, AttackDiff, StagesList, Ans),
    print_all_options(Ans)
).

% print_all_options(L) is true if L is a list of triples containing
% (stage, number of times, total duration for the stage). It will print all elements in L in formatted strings.
print_all_options([]).
print_all_options([H|T]) :-
	generate_stage_time_duration_string(H, Msg),
	write(Msg),
	nl,
	print_all_options(T).

% provide_best_option(Career) takes user input and provide the stage that take minimum time
% for users to clear in order to upgrading to Career
provide_best_option(Career) :-
    write("What is the highest stage level you have cleared? "), flush_output(current_output),
    nl,
    readln(Stage),
    ask_num_materials_owned(Magic, Shield, Attack),
    get_best_option(Career, Stage, Magic, Shield, Attack).

% get_best_option(Career, CurrentStage, MagicOwned, ShieldOwned, AttackOwned)
% gets the best option (takes minimum duration) for the user to upgrade to Career
get_best_option(Career, CurrentStage, MagicOwned, ShieldOwned, AttackOwned) :-
    get_all_materials_diff(Career, MagicOwned, ShieldOwned, AttackOwned, MagicDiff, ShieldDiff, AttackDiff),
(   (MagicDiff =< 0, ShieldDiff =< 0, AttackDiff =< 0) ->
    string_concat('Congrat!!! You already have enough materials for upgrading to ', Career, Msg),
    write(Msg)
;
    get_eligible_stages(CurrentStage, [1,2,3,4,5,6], StagesList),
    get_stages_and_times_tuples(Career, MagicDiff, ShieldDiff, AttackDiff, StagesList, Triples),
    min_duration(Triples, Best),
    generate_stage_time_duration_string(Best, Msg),
    write("Here is the best option for you: "),
    nl,
    write(Msg)
).

% ----------- HELPER METHODS ---------- %

% generate_required_material_string(Num, Material, Ans) is true if Ans is a formatted string indicating number of material
generate_required_material_string(Num, Material, Ans) :-
(   Num > 0 ->
	string_concat(Material, ' = ', Temp),
	string_concat(Temp, Num, Ans)
;
    string_concat(Material, ' = - ', Ans)
).

% generate_stage_time_duration_string(X, Ans) is true if X is a triple of (Stage, Times, Duration)
% and Ans is a formatted string containing Times and Duration for the Stage
generate_stage_time_duration_string((Stage, Times, Duration), Ans) :-
    string_concat('Clear stage: ', Stage, Temp1),
    string_concat(' => ', Times, Temp2),
    string_concat(Temp1, Temp2, Temp3),
    string_concat(' times; total ', Duration, Temp4),
    string_concat(Temp4, ' min', Temp5),
    string_concat(Temp3, Temp5, Ans).

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


% get_stages_and_times_tuples(Career, MagicDiff, ShieldDiff, AttackDiff, StagesList, Ans) is true if Ans is a list of
% triples (Stage, NumTimes, Duration) that can provide number of materials (stated in MagicDiff, ShieldDiff, AttackDiff)
% for upgrading to Career
get_stages_and_times_tuples(_, _, _, _, [],[]).
get_stages_and_times_tuples(Career, MagicDiff, ShieldDiff, AttackDiff, [H|T], [(H,NumTimes,Duration)|Ans]) :-
	calculate_num_times(H, MagicDiff, ShieldDiff, AttackDiff, NumTimes),
	stage_time(H, TimeSpent),
	Duration is NumTimes * TimeSpent,
	get_stages_and_times_tuples(Career, MagicDiff, ShieldDiff, AttackDiff, T, Ans).


% ask_num_materials_owned(Magic, Shield, Attack) asks for number of Magic, Shield, Attack the user owns
ask_num_materials_owned(Magic, Shield, Attack) :-
	write("How many magic do you have?"), flush_output(current_output),
    nl,
    readln(Magic),
    write("How many shield do you have?"), flush_output(current_output),
    nl,
    readln(Shield),
    write("How many attack do you have?"), flush_output(current_output),
    nl,
    readln(Attack).


% Reference: https://stackoverflow.com/questions/25838827/prolog-max-in-a-list
% max(L, M) is true if M is the maximum in the list L
max([Max], Max).
max([Head | List], Max) :-
  max(List, MaxList),
  (Head > MaxList -> Max = Head ; Max = MaxList ).


% min_duration(Triples, Min) is true if Triples is a list of (Stage, Times, Duration) and
% Min is the triple with minimum Duration
min_duration([Min], Min).
min_duration([(Stage1,Times1,Duration1) | List], Min) :-
  min_duration(List, (Stage2,Times2,Duration2)),
  (Duration1 =< Duration2 -> Min = (Stage1,Times1,Duration1) ; Min = (Stage2,Times2,Duration2) ).




