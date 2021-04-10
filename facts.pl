
% upgrade(C, M) is true if M are materials for upgrading to career C
upgrade(career(knight), [material(type(magic),4), material(type(shield),8), material(type(attack),8)]).
upgrade(career(fighter), [material(type(magic),4), material(type(shield),4), material(type(attack),12)]).
upgrade(career(mage), [material(type(magic),14), material(type(shield),2), material(type(attack),4)]).


% material_for_upgrade(C, M) is true if M is a material of specific type for upgrading to career C
material_for_upgrade(career(knight), material(type(magic),4)).
material_for_upgrade(career(knight), material(type(shield),8)).
material_for_upgrade(career(knight), material(type(attack),8)).
material_for_upgrade(career(fighter), material(type(magic),4)).
material_for_upgrade(career(fighter), material(type(shield),4)).
material_for_upgrade(career(fighter), material(type(attack),12)).
material_for_upgrade(career(mage), material(type(magic),14)).
material_for_upgrade(career(mage), material(type(shield),2)).
material_for_upgrade(career(mage), material(type(attack),4)).


% material(T, N) is true if N >= 0 and T is a valid material type;
material(T, N) :-
	N >= 0,
	type(T).


% type(T) is true when T is a valid material type
type(magic).
type(shield).
type(attack).


% career(C) is true when C is a valid career
career(knight).
career(mage).
career(fighter).


% stage(N, M) is true if M are materials earned from stage N
stage(1, [material(type(magic),1), material(type(shield),1), material(type(attack),1)]).
stage(2, [material(type(magic),1), material(type(shield),1), material(type(attack),2)]).
stage(3, [material(type(magic),1), material(type(shield),2), material(type(attack),1)]).
stage(4, [material(type(magic),2), material(type(shield),1), material(type(attack),2)]).
stage(5, [material(type(magic),2), material(type(shield),2), material(type(attack),2)]).
stage(6, [material(type(magic),3), material(type(shield),2), material(type(attack),2)]).


% stage_time(N, T) is true if stage N takes T minutes to complete/clear
stage_time(1, 0.5).
stage_time(2, 1).
stage_time(3, 2).
stage_time(4, 2).
stage_time(5, 3).
stage_time(6, 4).


% material_from_Stage(N, M) is true if M is a material of specific type earned from stage N
material_from_Stage(1, material(type(magic),1)).
material_from_Stage(1, material(type(shield),1)).
material_from_Stage(1, material(type(attack),1)).

material_from_Stage(2, material(type(magic),1)).
material_from_Stage(2, material(type(shield),1)).
material_from_Stage(2, material(type(attack),2)).

material_from_Stage(3, material(type(magic),1)).
material_from_Stage(3, material(type(shield),2)).
material_from_Stage(3, material(type(attack),1)).

material_from_Stage(4, material(type(magic),2)).
material_from_Stage(4, material(type(shield),1)).
material_from_Stage(4, material(type(attack),2)).

material_from_Stage(5, material(type(magic),2)).
material_from_Stage(5, material(type(shield),2)).
material_from_Stage(5, material(type(attack),2)).

material_from_Stage(6, material(type(magic),3)).
material_from_Stage(6, material(type(shield),2)).
material_from_Stage(6, material(type(attack),2)).

