%% Noisy Channel Experiment for patients by Rachel Ryskin
%% Changed mouse clicks to key presses

clear all;
cd( '/Users/rachelryskin/Dropbox (MIT)/Noisy Channel Aphasia/')
commandwindow;

rand('twister',sum(100*clock)) %resets the random number generator.
srand=num2str(round(rand*100));

substring = 'Enter Subject Number only, e.g. "30", max 4 digits: ';
subject = inputnumber(substring, 1,9999);
%condition='none';
%while strcmp(condition,'none')
cond = inputnumber('What version are we running today?  (Enter 0 or 1):  ', 0,1);% cond: 1=noisy or 0=no error
if cond==1;
    condition='noise';
elseif cond ==0;
    condition='noError';
end
        
% language=['L',num2str(lang)];
% list = inputnumber('What list are we running today?  (Enter 1-2):  ', 1,2);%participants get same Xs during training even if they do multiple blocks
% block = inputnumber('What block number are we running today?  (1-6):  ');

outputDir = 'output/';
cols = repmat('%s,',1,11);
output = fopen([outputDir,'NCaph1_s',num2str(subject),'_',srand,'.csv'], 'a');
fprintf(output,[cols,'%s\n'],'subject', 'srand','order','condition','trialID','trialType','subcondition','item','question','correct_resp','response','accuracy');

TrialInfo=readtable('NCaph1_items_v7.csv');

%% create randomized lists of trials 
filler_trials=TrialInfo(strcmp(TrialInfo.typeoftrial,'filler'),:);
exp_trials=TrialInfo(strcmp(TrialInfo.subcondition,condition),:);
test_trials=TrialInfo(strcmp(TrialInfo.typeoftrial,'test'),:);

randfillers=randperm(height(filler_trials));
first3=filler_trials(randfillers(1:3),:);
otherFillers=filler_trials(randfillers(4:height(filler_trials)),:);

restOfTrials=vertcat(exp_trials,test_trials,otherFillers);
randomOrder=randperm(height(restOfTrials));
randomizedTrials=vertcat(first3,restOfTrials(randomOrder,:));


%% prepare display
Screen('Preference','VBLTimestampingMode',-1); %This setting can be turned on if you have video driver problems.
%Screen('Preference', 'SkipSyncTests', 1); % Comment this line for real subjects
Screen('Preference', 'VisualDebuglevel', 3); %get rid of graphics check on a mac

white = [255 255 255];
black = [0 0 0];
green = [34 139 34];
gray=[192 192 192];

textfont = 'Helvetica';
textsize = 40;

screenNumber=max(Screen('Screens'));
[window, rect]=Screen('OpenWindow', screenNumber, 0,[],32,2);
Screen(window,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
Screen('TextSize',window,textsize); % specify text size
Screen('TextFont',window,textfont);
Screen('TextStyle',window,0); % change default font to non-bold (necessary for windows computers)

Xleft=rect(RectLeft);
Xright=rect(RectRight);
Ytop=rect(RectTop);
Ybottom=rect(RectBottom);
Xcenter=round(Xright/2);
Ycenter=round(Ybottom/2);
Xqtr=round(Xright/4);
X3qtr=Xright-Xqtr;
Yqtr=round(Ybottom/4);
Y3qtr=Ybottom-Yqtr;

% warning off MATLAB:DeprecatedLogicalAPI
% warning('off','MATLAB:dispatcher:InexactMatch')
%% instructions
Screen('FillRect',window,white, rect)
WriteCentered(window, 'Welcome to the experiment. Press the spacebar to begin.', Xcenter, Ycenter, black);
Screen('Flip', window);
KbWait();

KbReleaseWait();
Screen('FillRect',window,white, rect)
instructions1=('-  In this task, you will read sentences and answer YES or NO questions.');
WriteLine(window,instructions1, black, 100, 100, Ycenter*.25, 1.25);
%Screen('Flip', window,[],1);


instructions2=('-  Take as long as you need to read each sentence.');
WriteLine(window,instructions2, black, 100, 100, Ycenter*.50, 1.25);
%Screen('Flip', window,[],1);
%KbWait;

instructions3=('-  Then, read the question and press on YES or NO to answer.');
WriteLine(window,instructions3, black, 100, 100, Ycenter*.75, 1.25);
%Screen('Flip', window,[],1);
%KbWait;

instructions4=('-  Any questions before we get started? If not, press space to start.');
WriteLine(window,instructions4, black, 100, 100, Ycenter, 1.25);
Screen('Flip', window,[],1);
KbWait;

Screen('FillRect',window,white, rect);
Screen('Flip', window);

YesBoxCoords=[X3qtr-200 Y3qtr-100 X3qtr+250 Y3qtr+150];
NoBoxCoords=[Xqtr-200 Y3qtr-100 Xqtr+250 Y3qtr+150];
a_code = KbName('a')
l_code = KbName('l')

%% Trial Loop
for trialnum = 1:height(randomizedTrials);% 119
%for trialnum = 1:5; %for testing/demo    
   KbReleaseWait();
    sentence=char(randomizedTrials.item(trialnum));
    question=char(randomizedTrials.question(trialnum));
    
    WriteCentered(window,sentence,Xcenter, Ycenter*.25, black,1.25);
    WriteCentered(window,question,Xcenter, Ycenter*1, black, 1.25);    
    WriteLine(window,'Yes', black, 100, X3qtr, Y3qtr, 1.25);
    WriteLine(window,'No', black, 100, Xqtr, Y3qtr, 1.25);
    Screen('FrameRect',window,black, YesBoxCoords);
    Screen('FrameRect',window,black, NoBoxCoords);
    Screen('Flip', window);
    
 %   selected=0;
    answercoordinates=[0 0 0 0];
 %   while selected==0;
    [~, keyCode,~] = KbWait();
    kc = find(keyCode)
        %[clicks,z,w,buttons]=GetClicks(window,0);            
        %if z>=YesBoxCoords(1) && w>=YesBoxCoords(2)&& z<=YesBoxCoords(3)&& w<=YesBoxCoords(4);
    if find(keyCode) == l_code
        response = 'Yes'
        answercoordinates=YesBoxCoords;
      %  selected = 1;
    %elseif z>=NoBoxCoords(1) && w>=NoBoxCoords(2)&& z<=NoBoxCoords(3)&& w<=NoBoxCoords(4);
    elseif find(keyCode) == a_code
        response = 'No'
        answercoordinates=NoBoxCoords;
%           selected = 1;
    end; 
%    end;
    correct_answer = char(randomizedTrials.answer(trialnum))
    
    WriteCentered(window,sentence,Xcenter, Ycenter*.25, black, 1.25);
    WriteCentered(window,question,Xcenter, Ycenter*1, black, 1.25);  
    Screen('FillRect', window ,gray,answercoordinates);
    Screen('FrameRect',window,black, YesBoxCoords);
    Screen('FrameRect',window,black,NoBoxCoords);
    WriteLine(window,'Yes', black, 100, X3qtr, Y3qtr, 1.25);
    WriteLine(window,'No', black, 100, Xqtr, Y3qtr, 1.25);
    Screen('Flip', window);

    accuracy= strcmpi(response,correct_answer);
   
    fprintf(output, [cols,'%s\n'],...
        num2str(subject),srand,num2str(trialnum),condition,num2str(randomizedTrials.number(trialnum)), ...
        char(randomizedTrials.typeoftrial(trialnum)), char(randomizedTrials.subcondition(trialnum)), sentence,...
        question,char(randomizedTrials.answer(trialnum)),response,num2str(accuracy));
    WaitSecs(0.25);
    
end;
    
Screen('FillRect',window,white, rect)
Screen('TextSize',window,textsize);
WriteCentered(window, 'You have completed the experiment. Thank you!', Xcenter, Ycenter, black, 25);
Screen('Flip', window);
WaitSecs(4);

sca;
    
    
    
    
    
    
    
    
    
    