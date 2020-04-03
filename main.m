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
[stim{1}, ~, alphas] = imread('square.png');
stim{1}(:, :, 4) = alphas;
stim{1} = Screen('MakeTexture', window, stim{1});

[stim{2}, ~, alphat] = imread('triangle.png');
stim{2}(:, :, 4) = alphat;
stim{2} = Screen('MakeTexture', window, stim{2});

[stim{3}, ~, alphac] = imread('circle.png');
stim{3}(:, :, 4) = alphac;
stim{3} = Screen('MakeTexture', window, stim{3});

[stim{4}, ~, alphad] = imread('diamond.png');
stim{4}(:, :, 4) = alphad;
stim{4} = Screen('MakeTexture', window, stim{4});


%% Output file setup

%% Main

lt = l1 + l2;

[pre, post] = makeMatrix(l1,l2,prob,trueLength);
order = stimShuffle(lt, length(prob));

trial = 1;

dispMat = zeros(4,4);

while trial <= l1
    
    % Reset outcome and response for each trials
    outcome = '0';
    response = [];
    
    [disp{1}, disp{2}, dispMat] = dynDisp(dispMat);
    
    %Randomise left-right positioning of stimuli
    left = 0;
    right = 0;
    while left == right
        left = randi(2);
        right = randi(2);
    end
    
    
    % Drawing shapes and flip to screen
    %Screen('DrawTexture', window, stim{1}, [], stimpos{order(trial,1)}, 0);
    Screen('DrawTexture', window, stim{disp{left}}, [], stimpos{2}, 0);
    Screen('DrawTexture', window, stim{disp{right}}, [], stimpos{3}, 0);
    %Screen('DrawTexture', window, stim{4}, [], stimpos{order(trial,4)}, 0);
    start = Screen('Flip', window);


    % Wait for a response (max 2sec) then display only the chosen stimuli on
    % screen

    [responseTi, keyStateVec] = KbWait([], [], GetSecs()+2);

    RT = responseTi - start;
    response = find(keyStateVec(activeKeys));

    %chosen = chosenStim(order(trial,1), order(trial,2), order(trial,3), order(trial,4), response);

    if response == 2
        % Draw chosen image to screen
        Screen('DrawTexture', window, stim{disp{left}}, [], stimpos{2}, 0);
        % Increase count for chosen image
        dispMat(2, disp{left}) = dispMat(2, disp{left}) + 1;
        % Determine outcome
        outcome = num2str(pre(dispMat(2, disp{left}), disp{left}));
        % Increment number of wins/non-wins for chosen image
        if pre(dispMat(2, disp{left}), disp{left}) ~= 0
            dispMat(3, disp{left}) = dispMat(3, disp{left}) + 1;
        else 
            dispMat(4, disp{left}) = dispMat(4, disp{left}) + 1;
        end
        
    elseif response == 3
        Screen('DrawTexture', window, stim{disp{right}}, [], stimpos{3}, 0);
        dispMat(2, disp{right}) = dispMat(2, disp{right}) + 1;
        outcome = num2str(pre(dispMat(2, disp{right}), disp{right}));
        if pre(dispMat(2, disp{right}), disp{right}) ~= 0
            dispMat(3, disp{right}) = dispMat(3, disp{right}) + 1;
        else 
            dispMat(4, disp{right}) = dispMat(4, disp{right}) + 1;
        end
    else
        DrawFormattedText(window, 'No image chosen', 'center','center', [0 0 0]);
    end

    Screen('Flip', window);
    WaitSecs(0.3);
    
    % Display outcome
    DrawFormattedText(window, outcome, 'center','center', [0 0 0]);    
    Screen('Flip', window);    
    WaitSecs(0.3);
    
    trial = trial + 1;
    
end

c1 = 0;
c2 = -1;

while c1 ~= c2
    select = 'Choose prefered shape';
    DrawFormattedText(window, select, 'center',screenYpixels/5, [0 0 0]);   
    Screen('DrawTexture', window, stim{1}, [], stimpos{1}, 0);
    Screen('DrawTexture', window, stim{2}, [], stimpos{2}, 0);
    Screen('DrawTexture', window, stim{3}, [], stimpos{3}, 0);
    Screen('DrawTexture', window, stim{4}, [], stimpos{4}, 0);
    Screen('Flip', window);
    
    [~, keyStateVec] = KbWait([], 3, []);
    c1 = find(keyStateVec(activeKeys));
        
    confirm = 'Confirm prefered shape, press any other key to return to previous screen';
    DrawFormattedText(window, confirm, 'center',screenYpixels/5, [0 0 0]);   
    Screen('DrawTexture', window, stim{1}, [], stimpos{1}, 0);
    Screen('DrawTexture', window, stim{2}, [], stimpos{2}, 0);
    Screen('DrawTexture', window, stim{3}, [], stimpos{3}, 0);
    Screen('DrawTexture', window, stim{4}, [], stimpos{4}, 0);
    Screen('Flip', window);  
    
    [~, keyStateVec] = KbWait([], 3, []);
    c2 = find(keyStateVec(activeKeys));  
end

sca;
end