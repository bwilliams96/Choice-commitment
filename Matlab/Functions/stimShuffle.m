function out = stimShuffle(m, n)
%{

Created by: Brendan Williams

Function requires 2 inputs:
m = Total number trials in the task.
n = number of stimuli in the task.

The function has 1 output:
out = shuffled matrix with numbers 1-n representing one of each of the
stimuli in the task. Each row is a trial, each column is a position on the
screen.

%}

stimuli = 1:1:n;

out = double.empty(0,length(stimuli));

for i = 1:m
    stimuli = stimuli(randperm(length(stimuli)));
    out = [out; stimuli];
end

end