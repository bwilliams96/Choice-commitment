function main()

%% Refresh Matlab

sca;
close all;
clearvars;
RandStream.setGlobalStream(RandStream('mt19937ar','seed',sum(100*clock)));

%% Task parameters --------------------------------------------------------


%% ------------------------------------------------------------------------

%% Participant info input
subjectID = input('Enter participant number: ', 's');

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
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey, [0 0 200 200]);
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
ifi = Screen('GetFlipInterval', window);
[xCenter, yCenter] = RectCenter(windowRect);
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

%% Output file setup

test = 1

end