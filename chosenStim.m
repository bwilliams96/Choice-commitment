function chosen = chosenStim(squPos, triPos, cirPos, diaPos, pos)
%{

Created by: Brendan Williams

Function requires 5 inputs:
squPos = The numerical position of the square
triPos = The numerical position of the triangle
cirPos = The numerical position of the circle
diaPos = The numerical position of the diamond
pos = The position of response key pressed

The function has 1 output:
chosen = The identity of the chosen stimuli

%}

if pos == squPos
    chosen = 'squ';
elseif pos == triPos
    chosen = 'tri';
elseif pos == cirPos
    chosen = 'cir';
elseif pos == diaPos
    chosen = 'dia';
end
    