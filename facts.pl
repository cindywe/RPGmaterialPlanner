% Stages and Careers aviable in our make-up RPG
% upgrade(material (M, S, A), career) is true if it represent the required material of each kinds X, Y, Z to upgrade this career.
upgrade(career(knight),material(type(magic),4),material(type(shield),8),material(type(attack),8)).
upgrade(career(fighter),material(type(magic),4),material(type(shield),4),material(type(attack),12)).
upgrade(career(mage),material(type(magic),14),material(type(shield),2),material(type(attack),4)).
% career(inputcareer) is true when the input career is a valid career

% stage(number, M, S, A) 
stage(1,1,1,1). % one-index
stage(2,material(type(magic),0),material(type(shield),1),material(type(attack),2)).
stage(3,1,0,1). %--todo
stage(4,1,1,2). %--todo
stage(5,2,2,0). %--todo
stage(6,3,0,1). %--todo
% material(num, type) is true if num >= 0 and type is valid

type(magic).
type(shield).
type(attack).
career(knight).
career(mage).
career(fighter).

myconstraint(time).
myconstraint(difficulties).




