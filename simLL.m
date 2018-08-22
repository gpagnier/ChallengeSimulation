clear all;
% first we need all the relevant vars from the data that will go into the
% model
load('simHAData.mat')

Parms.Chosen  = simHPData(:,2);
Parms.Reward  = simHPData(:,3);
Parms.nTrials = size(simHPData,1);
Parms.initVal = 1*ones(1,4);

for sim = 1%:100
    i = 0;
    for alpha = 0.01:0.01:1
        i = i+1; j = 0;
        for beta = 0.01:0.1:20
            j = j+1;
            LL(i,j,sim) = loglikeHA(Parms,alpha,beta);
            
        end
    end
end
%%
mLL = -nanmean(LL,3);
close all
colormap('hot')
imagesc(mLL);
colorbar