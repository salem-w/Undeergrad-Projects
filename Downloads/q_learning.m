global N north east south west goal
global qValue val nextState
global learning discount
global Actions

iter_trace = 50000;
north = 0;
east = 1;
south = 2;
west = 3;

currentIter = -1;
iterMax = 10000;
exploration = 0.7;
amortization = 0.9;
reward = 500;%recompense
penalty = 100;
learning = input('Input the learnin rate between 0 and 1');
N = input('Input the size of the grid');
Actions = 4;
BestAction = 0;
Q_S = 0;
hits = 0;
d_learn = false;
learn_step = 0.0;
initialState = input('What is the initial state?');
goal = input('What is the goal?');
qValue = zeros(N*N, 4);

% Initialize learning factor, discount factor (0-1)
policy = zeros(N*N, 2);

% Function name: learning
% Purpose: Find the optimal policy (optimal mapping from state to action)
% Store: mapping of state to action (matrix)
% Print out the path from starting state to target state
BestAction = function giveBestAction(StateI, StateJ)
	theBest = -1;
	theBestVAl = -100000.0;
	for(i = 0; i < Actions; i++)
		if(qValue(stateI, stateJ, i) > theBestVal)
			theBestVAl = qValue(stateI,stateJ, i)
			theBest = i
        end
    end
end
% function policy = learning(state)

%number of iterations

state = initialState;
while(state~=target)
    a = takeAction(state);
    R = getReward(state, a);
    s_new = nestState(state, a);
    %update Q and V values
    %update policy if needed
    state = s_next;
    learning(state)
% end
% Function name: getReward
% Purpose: To get reward given state state and action a
% Return: R

% Function name: getState
% Purpose: To get next state given state and action a
% Return: s_new
nextState = function getState(StateI, StateJ, Action)
result = zeros(2,1);
switch(Action)
    case north:
        if(StateI == 0)
            result

% Function name: takeAction
% Purpose: To take action in current state state
% Return: a