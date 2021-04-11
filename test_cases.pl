% ----- Test cases -----

% ?- ask(Ans).
% Ask your question below:
% |: What materials required for upgrading to fighter?
% Ans = ["magic = 4", "shield = 4", "attack = 12"].


% ?- ask(Ans).
% Ask your question below:
% |: How many attack required for upgrading to fighter?
% Ans = 12.


% ?- ask(Ans).
% Ask your question:
% |: Can I upgrade to mage?
% How many magic do you have?
% |: 5
% How many shield do you have?
% |: 3
% How many attack do you have?
% |: 6
% Sorry!!! You cannot upgrade now. You still need:
% Ans = ["magic = 9", "shield = - ", "attack = - "]


% ?- ask(Ans).
% Ask your question:
% |: Can I upgrade to mage?
% How many magic do you have?
% |: 15
% How many shield do you have?
% |: 6
% How many attack do you have?
% |: 7
% Ans = "Congrat!!! You have enough materials for upgrading to mage"


% ?- ask(Ans).
% Ask your question:
% |: How many attack I still need for upgrading to knight?
% How many attack do you have?
% |: 2
% Ans = "You still need: 6"


% ?- ask(Ans).
% Ask your question:
% |: How many attack I still need for upgrading to knight?
% How many attack do you have?
% |: 8
% Ans = "You have enough attack"


% ?- ask(Ans).
% Ask your question:
% |: What materials can be earned from stage 6?
% Ans = ["magic = 3", "shield = 0", "attack = 1"].


% ?- ask(Ans).
% Ask your question:
% |: How many attack can be earned from stage 3?
% Ans = 1.


% ?- ask(Ans).
% Ask your question:
% |: How many times do I have to clear stage 6 for upgrading to mage?
% How many magic do you have?
% |: 15
% How many shield do you have?
% |: 7
% How many attack do you have?
% |: 7
% Ans = "Congrat!!! You already have enough materials for upgrading to mage" .


% ?- ask(Ans).
% Ask your question:
% |: How many times do I have to clear stage 1 for upgrading to knight?
% How many magic do you have?
% |: 4
% How many shield do you have?
% |: 7
% How many attack do you have?
% |: 7
% Ans = "You have to clear it 1 time(s). It will takes you 1 min " ;


% ?- ask(Ans).
% Ask your question:
% |: How long does stage 6 take?
% Ans = "4 minute(s)".


% ?- ask(Ans).
% Ask your question:
% |: How can I upgrade to mage?
% What is the highest stage level you have cleared
% |: 4
% How many magic do you have?
% |: 10
% How many shield do you have?
% |: 10
% How many attack do you have?
|% : 10
% You can upgrade by one of the following ways:
% Clear stage: 1 => 4 times; total 4 min
% Clear stage: 2 => 4 times; total 4 min
% Clear stage: 3 => 4 times; total 8 min
% Clear stage: 4 => 2 times; total 4 min
% Clear stage: 5 => 2 times; total 6 min



% ?- ask(Ans).
% Ask your question:
% |: How can I upgrade to mage?
% What is the highest stage level you have cleared
% |: 5
% How many magic do you have?
% |: 20
% How many shield do you have?
% |: 20
% How many attack do you have?
% |: 20
% Congrat!!! You already have enough materials for upgrading to mage



% ?- ask(Ans).
% Ask your question: 
% |: What is the best way for me to upgrade to mage?
% What is the highest stage level you have cleared? 
% |: 4
% How many magic do you have?
% |: 10
% How many shield do you have?
% |: 10
% How many attack do you have?
% |: 10
% Here is the best option for you: 
% Clear stage: 1 => 4 times; total 4 min



