function [pre, post] = makeMatrix(l1,l2,prob,trueLength)
%{

Created by: Brendan Williams

PLEASE NOTE!!!
OBSERVED PROBABILITIES WILL NOT RELIABLY MATCH WITH EXPECTED PROBABILITIES
IF prob*trueLength OR prob*(1-trueLength) ARE NOT INTEGERS DUE TO ROUNDING.

Function requires 4 inputs:
l1 = number of trials before choice commitment question
l2 = number of trials after choice commitment
prob = probability of winning for each option after choice commitment
trueLength = number of trials over which expected probabilities are observed.

The function has 2 outputs:
pre = binary matrix of outcomes before choice commitment with 
(l1,length(prob)) dimensions. 0 represents a loss and 1 represents a win.

post = binary matrix of outcomes after choice commitment with 
(l1,length(prob)) dimensions. 0 represents a loss and 1 represents a win.

%}

l1tL = ceil(l1 / trueLength);
l2tL = ceil(l2 / trueLength);

pre = double.empty(0,length(prob));

for i = 1:l1tL
    temp = zeros(ceil(trueLength / 2) * 2, length(prob));
    for ii = 1:length(prob)
        z = zeros(ceil(trueLength / 2), 1);
        o = ones(ceil(trueLength /2), 1);
        zo = [z; o];
        zo = zo(randperm(length(zo)));
        temp(:,ii) = zo;
    end
    pre = [pre; temp];
end

post = double.empty(0,length(prob));

for i = 1:l2tL
    temp = zeros(trueLength,length(prob));
    for ii = 1:length(prob)
        probability = prob(ii) / 100;
        z = zeros(floor(trueLength * (1-probability)), 1);
        o = ones(ceil(trueLength * probability), 1);
        zo = [z; o];
        zo = zo(randperm(length(zo)));
        temp(:,ii) = zo;
    end
    post = [post; temp];
end

end