function [disp1, disp2, matrix] = dynDisp(matrix)
%{

Created by: Brendan Williams

Function requires 1 input:
matrix = An (M,N) matrix where each stimulus has its own column. The first
row in this matrix needs to be the number of times a stimulus has been
displayed, the second row needs to be the number of times it has been
chosen. Additional rows in the matrix are optional and can be customised
depending on needs

The function has 3 outputs:
disp1 = The column index of the least chosen stimuli
disp2 = The column index of the second least chosen stimuli
matrix = The updated input matrix

%}

disp1 = 0;
disp2 = 0;

% Randomly chose stimuli for the first trial
if sum(matrix(2,:)) == 0
    while disp1 == disp2
        disp1 = randi(length(matrix));
        disp2 = randi(length(matrix));
    end
else
    % Find the proportion of trials that each stimuli has been chosen, minus
    % the proportion of chosen trials of the stimulus with the largest
    % proportion, squared
    prob = matrix(2,:)/sum(matrix(2,:));
    maximum = max(prob);
    prob = (prob-maximum).^2;
    
    % Find the two least displayed images (these will have the largest and 
    % second largest numbers)
    [~, disp1] = max(prob);
    prob(1, disp1) = 0;
    [~, disp2] = max(prob);
end

% Update count for the displayed images in the matrix
matrix(1, disp1) = matrix(1, disp1) + 1;
matrix(1, disp2) = matrix(1, disp2) + 1;