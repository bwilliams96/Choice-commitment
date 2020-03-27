function main()

%% Refresh Matlab

sca;
close all;
clearvars;
RandStream.setGlobalStream(RandStream('mt19937ar','seed',sum(100*clock)));

%% Task parameters --------------------------------------------------------

l1 = 50;
l2 = 50;
prob = [50,50,50, 50];
trueLength = 10;


%% ------------------------------------------------------------------------

%% Participant info input
%subjectID = input('Enter participant number: ', 's');

%ListenChar(2); Commented out for testing
%% Psychtoolbox setup

PsychDefaultSetup(2);
KbName('UnifyKeyNames');
screens = Screen('Screens');
screenNumber = max(screens);
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 1.5;
inc = white - grey;
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey, [0 0 400 400]);
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
ifi = Screen('GetFlipInterval', window);
[xCenter, yCenter] = RectCenter(windowRect);
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

%Defining stimuli positions on screen
stimpos{1} = [(screenXpixels./16) (screenYpixels./4) (3.*(screenXpixels./16)) (screenYpixels./(4./3))];
stimpos{2} = [(screenXpixels./(16/5)) (screenYpixels./4) (screenXpixels./(16/7)) (screenYpixels./(4./3))];
stimpos{3} = [(9.*(screenXpixels./16)) (screenYpixels./4) (11.*(screenXpixels./16)) (screenYpixels./(4./3))];
stimpos{4} = [(13.*(screenXpixels./16)) (screenYpixels./4) (15.*(screenXpixels./16)) (screenYpixels./(4./3))];

% Load stimuli
triangle1 = imread('triangle.jpg');
triangle = Screen('MakeTexture', window, triangle1);
square1 = imread('square.jpg');
square = Screen('MakeTexture', window, square1);
diamond1 = imread('diamond.jpg');
diamond = Screen('MakeTexture', window, diamond1);
circle1 = imread('circle.jpg');
circle = Screen('MakeTexture', window, circle1);


%% Output file setup

%% Main

lt = l1 + l2;

[pre, post] = makeMatrix(l1,l2,prob,trueLength);
order = stimShuffle(lt, length(prob));

trial = 1;

%Drawing shapes and flipping to screen
Screen('DrawTexture', window, square, [], stimpos{order(trial,1)}, 0);
Screen('DrawTexture', window, triangle, [], stimpos{order(trial,2)}, 0);
Screen('DrawTexture', window, circle, [], stimpos{order(trial,3)}, 0);
Screen('DrawTexture', window, diamond, [], stimpos{order(trial,4)}, 0);
Screen('Flip', window);

end