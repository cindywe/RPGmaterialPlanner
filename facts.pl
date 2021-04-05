% Stages and Careers aviable in our make-up RPG

% upgrade(C, M) is true if M are materials for upgrading to career C
upgrade(career(knight), [material(type(magic),4), material(type(shield),8), material(type(attack),8)]).
upgrade(career(fighter), [material(type(magic),4), material(type(shield),4), material(type(attack),12)]).
upgrade(career(mage), [material(type(magic),14), material(type(shield),2), material(type(attack),4)]).


% stage(N, M) is true if M are materials earned from stage N
stage(1, [material(type(magic),1), material(type(shield),1), material(type(attack),1)]).
stage(2, [material(type(magic),0), material(type(shield),1), material(type(attack),2)]).
stage(3, [material(type(magic),1), material(type(shield),0), material(type(attack),1)]).
stage(4, [material(type(magic),1), material(type(shield),1), material(type(attack),2)]).
stage(5, [material(type(magic),2), material(type(shield),2), material(type(attack),0)]).
stage(6, [material(type(magic),3), material(type(shield),0), material(type(attack),1)]).


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





% todo
myconstraint(time).
myconstraint(difficulties).
