function chosen = chosenStim(s1Pos, s2Pos, s3Pos, s4Pos, pos)
%{

Created by: Brendan Williams

Function requires 5 inputs:
s1Pos = The numerical position of stimulus 1 (square)
s2Pos = The numerical position of stimulus 2 (triangle)
s3Pos = The numerical position of stimulus 3 (circle)
s4Pos = The numerical position of stimulus 4 (diamond)
pos = The position of response key pressed

The function has 1 output:
chosen = The identity of the chosen stimuli

%}

if pos == s1Pos
    chosen = 's1';
elseif pos == s2Pos
    chosen = 's2';
elseif pos == s3Pos
    chosen = 's3';
elseif pos == s4Pos
    chosen = 's4';
end
    