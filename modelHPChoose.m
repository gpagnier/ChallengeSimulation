function choice = modelHPChoose(choiceProbs,nOptions)

rChoice = rand;
choiceProbs = [0 choiceProbs];
choice = NaN; 

for i = 1:nOptions
    if rChoice<(sum(choiceProbs(1:i+1)))
        choice = i;
        break;
    end
end