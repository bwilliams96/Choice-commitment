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

activeKeys = KbName({'a','s','k','l'});

% Load stimuli
[triangle, ~, alphat] = imread('triangle.png');
triangle(:, :, 4) = alphat;
triangle = Screen('MakeTexture', window, triangle);

[square, ~, alphas] = imread('square.png');
square(:, :, 4) = alphas;
square = Screen('MakeTexture', window, square);

[diamond, ~, alphad] = imread('diamond.png');
diamond(:, :, 4) = alphad;
diamond = Screen('MakeTexture', window, diamond);

[circle, ~, alphac] = imread('circle.png');
circle(:, :, 4) = alphac;
circle = Screen('MakeTexture', window, circle);

%% Output file setup

%% Main

lt = l1 + l2;

[pre, post] = makeMatrix(l1,l2,prob,trueLength);
order = stimShuffle(lt, length(prob));

trial = 1;
while trial < l1
% Drawing shapes and flip to screen
    Screen('DrawTexture', window, square, [], stimpos{order(trial,1)}, 0);
    Screen('DrawTexture', window, triangle, [], stimpos{order(trial,2)}, 0);
    Screen('DrawTexture', window, circle, [], stimpos{order(trial,3)}, 0);
    Screen('DrawTexture', window, diamond, [], stimpos{order(trial,4)}, 0);
    start = Screen('Flip', window);


% Wait for a response (max 2sec) then display only the chosen stimuli on
% screen

    [responseTi, keyStateVec] = KbWait([], [], GetSecs()+2);

    RT = responseTi - start;
    response = find(keyStateVec(activeKeys))

    chosen = chosenStim(order(trial,1), order(trial,2), order(trial,3), order(trial,4), response);

    if chosen == 'squ'
        Screen('DrawTexture', window, square, [], stimpos{response}, 0);
    elseif chosen == 'tri'
        Screen('DrawTexture', window, triangle, [], stimpos{response}, 0);
    elseif chosen == 'cir'
        Screen('DrawTexture', window, circle, [], stimpos{response}, 0);
    elseif chosen == 'dia'
        Screen('DrawTexture', window, diamond, [], stimpos{response}, 0);
    end

    Screen('Flip', window);

    WaitSecs(2)
    
    trial = trial + 1

end