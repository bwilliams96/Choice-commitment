function main()

%% Refresh Matlab

sca;
close all;
clearvars;
RandStream.setGlobalStream(RandStream('mt19937ar','seed',sum(100*clock)));

if ismac
    addpath('./Functions');
    addpath('./Stimuli');
elseif ispc
    addpath('.\Functions');
    addpath('.\Stimuli');
else
    disp('Paths not added')
end

%% Task parameters --------------------------------------------------------

cond1 = [70,50,50,30];
cond2 = [50,50,70,30];
cond3 = [30,50,50,70];
l1 = 50;
l2 = 50;
prob = cond1;
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
[stim1, ~, alphas] = imread('square.png');
stim1(:, :, 4) = alphas;
stim1 = Screen('MakeTexture', window, stim1);

[stim2, ~, alphat] = imread('triangle.png');
stim2(:, :, 4) = alphat;
stim2 = Screen('MakeTexture', window, stim2);

[stim3, ~, alphac] = imread('circle.png');
stim3(:, :, 4) = alphac;
stim3 = Screen('MakeTexture', window, stim3);

[stim4, ~, alphad] = imread('diamond.png');
stim4(:, :, 4) = alphad;
stim4 = Screen('MakeTexture', window, stim4);


%% Output file setup

%% Main

lt = l1 + l2;

[pre, post] = makeMatrix(l1,l2,prob,trueLength);
order = stimShuffle(lt, length(prob));

trial = 1;

while trial <= l1
    % Drawing shapes and flip to screen
    Screen('DrawTexture', window, stim1, [], stimpos{order(trial,1)}, 0);
    Screen('DrawTexture', window, stim2, [], stimpos{order(trial,2)}, 0);
    Screen('DrawTexture', window, stim3, [], stimpos{order(trial,3)}, 0);
    Screen('DrawTexture', window, stim4, [], stimpos{order(trial,4)}, 0);
    start = Screen('Flip', window);


    % Wait for a response (max 2sec) then display only the chosen stimuli on
    % screen

    [responseTi, keyStateVec] = KbWait([], [], GetSecs()+2);

    RT = responseTi - start;
    response = find(keyStateVec(activeKeys))

    chosen = chosenStim(order(trial,1), order(trial,2), order(trial,3), order(trial,4), response);

    if chosen == 's1'
        Screen('DrawTexture', window, stim1, [], stimpos{response}, 0);
    elseif chosen == 's2'
        Screen('DrawTexture', window, stim2, [], stimpos{response}, 0);
    elseif chosen == 's3'
        Screen('DrawTexture', window, stim3, [], stimpos{response}, 0);
    elseif chosen == 's4'
        Screen('DrawTexture', window, stim4, [], stimpos{response}, 0);
    end

    Screen('Flip', window);

    WaitSecs(2);
    
    trial = trial + 1;
    
    
end
sca;
end