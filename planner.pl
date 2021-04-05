:- include("facts.pl").


% requires_for_upgrading(C, M) is true if materials M are required for upgrading to career C.
requires_for_upgrading(C, M) :-
	upgrade(career(C), M).


% test case
% required_materials_for_upgrading(knight, M).
% M = [material(type(magic), 4), material(type(shield), 8), material(type(attack), 8)].

% upgrade(career(mage), [material(type(magic),Magic), material(type(shield),Shield), material(type(attack),Atta
% Magic = 14,
% Shield = 2,
% Attack = 4.