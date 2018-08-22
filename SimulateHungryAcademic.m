
clear all; close all;

% we'll look at our HA model over a month; each trial is a day
nTrials = 300;

% initilizing all option values to be equal, and sit between our two
% possible reward values (e.g. in this case, 0 or 1)
V = 1/2*ones(nTrials,4);
% 
% pick some parms; our simple model has two (assuming V_init fixed):
% learning rate and softmax temperature
learnRate = 0.5;
betaParm  = 5; % more on what these mean tomorrow. 

% lets assign some reward probabilities to the options (i.e. how likely is
% HP to have a good meal and no food poisoning at each place)

% we'll do this using a vector, rProbs, with one row and four columns,
% where each element is the probability of reward for one restaurant

rProbs = [0.5 0.2 0.65 0.9]; % we'll use these to calculate reward


% time to let modelHA play

% iterate across trials
for t = 1:nTrials
    
    % get choice probabilities for each of the four options based on values
    % this is the softmax equation from the slides! 
    % (you can experiment w/ this and make HA be a hard maximizer, instead,
    % or use epsilon-greedy, or some mix)
    choiceProb(t,:) = exp(V(t,:)*betaParm)/sum(exp(V(t,:)*betaParm)); 
    
    % decide what modelHA chooses by flipping a coin
   Chosen(t) = modelHPChoose(choiceProb(t,:),4); 
    
   % decide what reward modelHA got based on choice
   % i.e., flip another coin, with reward probability of whatever
   % restaurant HA chose, and see if it turns up heads (1) or tails (0)
   Reward(t) = rand<rProbs(Chosen(t)); 
   
   % update values based on reward, using Rescorla-Wagner update rule
   V(t+1,:)  = V(t,:);
   V(t+1,Chosen(t)) = V(t,Chosen(t)) + learnRate*(Reward(t)-V(t,Chosen(t)));
   
   
    
end

% make a new matrix for your simulated HAData: for instance, each row can
% be one trial, and each column a different variable: trial number, choice,
% reward
simHADataMoreTrials(:,1) = 1:nTrials;
simHADataMoreTrials(:,2) = Chosen;
simHADataMoreTrials(:,3) = Reward;

 save('simHADataMoreTrials','simHADataMoreTrials')

%
% plot some stuff to see what modelHA is really doing here
% to start, try making a bar plot for how often HA chose each of the four
% options (hint: you can use a FOR loop to get % choices for each)

for option = 1:4
   
    avgOptChoice(option) = length(find(Chosen==option))/nTrials; 
    
end
close all
bar(avgOptChoice)
xlabel('Options')
ylabel('Choice frequency')
set(gca,'fontsize',18,'xticklabel',{'BGood','Chipotle','Falafel','Bagels'})
ylim([0 1])

% do the model choices makes sense, given the reward probabilities for each
% option? If no, why? If yes, great!

%%

% you can also look in more detail at this, for instance by plotting which
% option HA chose on each day (e.g. each trial); you can do this with a bar
% plot, a line plot, anything you want
close all
bar(Chosen)
set(gca,'fontsize',20)
xlabel('Trial')
ylabel('Choice')
xlim([0 31])

%%

