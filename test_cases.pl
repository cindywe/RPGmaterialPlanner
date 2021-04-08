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
% You cannot upgrade now. Here are the numbers of materials you still require: 
% Ans = ["magic = 9", "shield = - ", "attack = - "].


% ?- ask(Ans).
% Ask your question: 
% |: How many attack I still need for upgrading to knight?
% How many attack do you have?
% |: 8
% You still need: 
% Ans = "attack = - ".


% ?- ask(Ans).
% Ask your question: 
% |: What materials can be earned from stage 6?
% Ans = ["magic = 3", "shield = 0", "attack = 1"].



% ?- ask(Ans).
% Ask your question: 
% |: How many attack can be earned from stage 3?
% Ans = 1.