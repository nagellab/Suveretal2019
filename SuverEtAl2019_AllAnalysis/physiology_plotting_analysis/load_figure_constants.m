%%
% Load figure variables: font sizes, colors, etc.
%
% for base plotting functions for subfigures in Suver et al. 2019
%%
imageLocation = 'C:\Users\nagellab\Documents\Data\SuverEtAlImages';
DOWNSAMPLE = 1;
PATCH = 0; %if 1, plots std dev patch around the mean; if 1, files take an incredibly long time to save though
TITLES = 1;
YAXIS_SPIKERATE = 1; %if 1, plots y-axis with any spike rate traces (0 and just a scale bar)
RAW_ZOOM = 1;
SUB_MLA = 1;
CHRIMSON_INDV_AVGS = 0; %if 1, will plot individual averages (instead of line for std dev)
CHRIMSON_ONSET_PEAK = 1; %if 1, selects peak of onset; 0, average first 2 s of light stim
INDV_BEHAV = 0; %if 0, plots standard deviation around mean; if 1, plots individual responses


dPrimePairs_Screen = [2 3; 3 4;]; %pairs to compute d' for in wind neuron screen
pairLabels = {'-45°,0°'; ' 0°,+45°';};
%%
directionNames = {'-90°', '-45°', '   0°', '+45°', '+90°'};

%% Raw data examples
expt_wPN = '2016_10_07_E1';
filename_wPNRawExample = '../SuverEtAl2019_DATA/2016_10_07_E1';
trialNum_wPN_ipsi = 2;
trialNum_wPN_contra = 1;

expt_aPN2 = '2017_01_05_E1'; 
trialNum_aPN2 = 1;
filename_aPN2 = '../SuverEtAl2019_DATA/2017_01_05_E1';

expt_aPN3 = '2017_04_28_E7'; 
trialNum_aPN3 = 1; %
raw_aPN3_dir = '+45°'; %left CB, hard-coding this for simplicity
filename_aPN3 = '../SuverEtAl2019_DATA/2017_04_28_E7';

samplerate = 10000;
preStim = 1; stim = 4; postStim = 5;
chrimsonOnset = 0.5; %average from first second of light stim for onset response


%% Figure location and sizes
% Time-traces (neural wind responses over time):
left_traceFig = 10; bottom_traceFig = 550; width_traceFig = 350*1.4; height_traceFig = 175*1.4; %v2 (increase width and height by 30%!)
tracesPosition1 = [left_traceFig bottom_traceFig width_traceFig height_traceFig];
tracesPosition2 = [left_traceFig bottom_traceFig-450 width_traceFig height_traceFig];
tracesPosition3 = [left_traceFig+950 bottom_traceFig width_traceFig height_traceFig];
tracesPosition4 = [left_traceFig+950 bottom_traceFig-300 width_traceFig height_traceFig];
tracesPosition_ane = [left_traceFig+950 bottom_traceFig-500 width_traceFig height_traceFig/2];

left_traceFigTNT = 10; bottom_traceFigTNT = 550; width_traceFigTNT = 350*1.2; height_traceFigTNT = 175*1.2; %v1
tracesPos_TNT1 = [left_traceFigTNT bottom_traceFigTNT width_traceFigTNT height_traceFigTNT];
tracesPos_TNT2 = [left_traceFigTNT bottom_traceFigTNT-450 width_traceFigTNT height_traceFigTNT];
tracesPos_TNT3 = [left_traceFigTNT+950 bottom_traceFigTNT width_traceFigTNT height_traceFigTNT];
tracesPos_TNT4 = [left_traceFigTNT+950 bottom_traceFigTNT-300 width_traceFigTNT height_traceFigTNT];

tracesPositionActivation = [left_traceFig bottom_traceFig-450 width_traceFig/1.4 height_traceFig*1.5/1.4];

left_traceFig = left_traceFig+950; bottom_traceFig = bottom_traceFig; width_traceFig = width_traceFig; height_traceFig = 225;
tracesPositionAnt = [left_traceFig bottom_traceFig-300 width_traceFig height_traceFig];

% Tuning curves (neural and antenna wind direction responses):
left_tuningFig = 650; bottom_tuningFig = 550; width_tuningFig = 150; height_tuningFig = 200;
tuningPosition1 = [left_tuningFig bottom_tuningFig width_tuningFig height_tuningFig];
tuningPosition2 = [left_tuningFig bottom_tuningFig-450 width_tuningFig height_tuningFig];
tuningPosition3 = [left_tuningFig+850+100 bottom_tuningFig width_tuningFig height_tuningFig];
tuningPosition_antTuning = [650 550 175 180];

% Ipsi-contra scatter plots:
left_diffFig = 10; bottom_diffFig = 750; width_diffFig = 200; height_diffFig = 300;
diffFigPosition1 = [left_diffFig bottom_diffFig width_diffFig height_diffFig];
diffFigPosition_narrow = [left_diffFig bottom_diffFig 100 height_diffFig];
diffFigPosition2 = [left_diffFig+300 bottom_diffFig width_diffFig height_diffFig];
diffFigPositionTest = [left_diffFig+700 50 width_diffFig height_diffFig+500];
% raw zoom plots
left_traceFig = 10; bottom_traceFig = 550; width_traceFig = 150; height_traceFig = 80;
rawTraceZoomPosition1 = [left_traceFig+375 bottom_traceFig width_traceFig height_traceFig];
rawTraceZoomPosition2 = [left_traceFig+375 bottom_traceFig-450 width_traceFig height_traceFig];
rawTraceZoomPosition3 = [left_traceFig+1350 bottom_traceFig width_traceFig height_traceFig];
rawTraceZoomPosition4 = [left_traceFig+1350 bottom_traceFig-250 width_traceFig height_traceFig];

positionDualCurrInj = [200, 200, 400, 400];
positionDualCurrInj_quant = [1400, 200, 170, 170];

positionChrimsonQuant = [1200, 100, 250, 170];

behaviorFigPosition1 = [50, 100, 150, 250];
behaviorFigPosition2 = [350, 100, 80, 250];
behaviorFigPosition3 = [550, 100, 150, 250];
behaviorFigPosition4 = [850, 100, 80, 150];

dPrimePositions(1,:) = [40, 850, 200, 200];
dPrimePositions(2,:) = [40, 450, 200, 200];
dPrimePositions(3,:) = [40, 50, 200, 200];

position_screen1 = [50, 100, 450, 175];
position_screen2 = [50, 300, 450, 175];
position_screen3 = [50, 500, 450, 175];
position_screen4 = [50, 700, 450, 175];

position_windNeuronScreen1 = [50, 100, 150, 550];
position_windNeuronScreen2 = [220, 100, 150, 550];
position_windNeuronScreen3 = [390, 100, 150, 550];
position_windNeuronScreen4 = [560, 100, 150, 550];

%region of trace to zoom into for raw traces
msToPlot = 50;
raw_start_stim = (preStim+3.4)*samplerate; %plot msToPlot-ms of trace, 3 seconds into stimulus
raw_len_stim = msToPlot*100;
ht_stim = 5;
boxShiftY = -0.5; %amount to shift zoom box down, relative to minimum of trace (roughly centers it around data)

%% Colors

black = [0 0 0];
gray = [0.6 0.6 0.6];
lightGray = [0.9 0.9 0.9];

red_pure = [255 0 0]./255;
tomato = [255 99 71]./255;
lightGreen = [144 238 144]./255;
blue_pure = [0 0 255]./255;
blueViolet = [138 43 226]./255;

softOrange = [255 102 51]./255;
robinsEggBlue = [0 204 255]./255;

% old wind colors:
%colors_fiveDirections = [red_pure; tomato; lightGreen; blue_pure; blueViolet];

%5 wind colors
% kind of muted, very distinct:
purple = [140 78 153]./255;
blue = [78 121 197]./255;
green = [140 188 104]./255;
orange = [230 121 50]./255;
red = [218 34 34]./255;

magenta = [238 51 119]./255; %magenta

%sharper:
purple = [140 78 153]./255;
blue = [0 153 204]./255; %soft of a teal-blue
green = [0 153 102]./255; %kelly-like green
orange = [255 153 51]./255; %carrot orange
red = [255 51 51]./255; %poppy red
colors_fiveDirections = [red; orange; green; blue; purple];

% %for testing: wind circuit colors
circuit_purple = [170 68 153]./255;
circuit_cyan = [136 204 238]./255;
circuit_teal = [68 170 153]./255;
circuit_green = [102 204 51]./255;
circuit_pink = [204 102 119]./255;
WPN_color = circuit_purple;
APN2_color = circuit_cyan;
APN3_color = circuit_teal;
B1_color = circuit_green;
JON_color = circuit_pink;
% colors_fiveDirections = [circuit_purple; circuit_cyan; circuit_teal; circuit_green; circuit_pink; ];
% 

%%%%%% %convert colors to green-colorblind interpretation, for testing!
%%%%%%  
% colorblindness = 'red';
% red = Colorblind_Convert(colors_fiveDirections(1,:), colorblindness);
% blue = Colorblind_Convert(colors_fiveDirections(2,:), colorblindness);
% green = Colorblind_Convert(colors_fiveDirections(3,:), colorblindness);
% orange = Colorblind_Convert(colors_fiveDirections(4,:), colorblindness);
% red = Colorblind_Convert(colors_fiveDirections(5,:), colorblindness);
% colors_fiveDirections = [red; orange; green; blue; purple];

% %convert colors to red-colorblind interpretation, for testing!
% colorblindness = 'red';
% red = Colorblind_Convert(colors_fiveDirections(1,:), colorblindness);
% blue = Colorblind_Convert(colors_fiveDirections(2,:), colorblindness);
% green = Colorblind_Convert(colors_fiveDirections(3,:), colorblindness);
% orange = Colorblind_Convert(colors_fiveDirections(4,:), colorblindness);
% red = Colorblind_Convert(colors_fiveDirections(5,:), colorblindness);
% colors_fiveDirections = [red; orange; green; blue; purple];


%4 behavior (antenna gluing) colors
light_blue = [119 170 221]./255;
mint = [68 187 153]./255;
pink = [255 170 187]./255;
medium_grey = [153 153 153]./255;

light_cyan = [153 221 255]./255;
red_strong = [255 51 51]./255;

preOdor = black;
duringOdor = red_strong;
postOdor = light_cyan;

colorAntFree = light_blue;
colorAntRightGlue = mint;
colorAntLeftGlue = pink;
colorAntBothGlue = medium_grey;
%colors for single-antenna-combined data
colorAntFree = light_blue;
colorAntSingle = pink; %yellow
colorAntBothGlue = mint;
colorAntNoWind = black;

color_behaviorIndv = lightGray;
color_behaviorMean = black;

%3 antenna tuning
color_leftAntenna = [255 0 204]./255;%magenta!
color_rightAntenna = [0 204 153]./255;%cyan/teal
%color_leftAntenna = [238 102 119]./255;%tomato/salmon red
%color_rightAntenna = [0 204 153]./255;%cyan/teal
%color_leftAntenna = Colorblind_Convert(color_leftAntenna, 'green');
%color_rightAntenna = Colorblind_Convert(color_rightAntenna, 'green');

% %% for testing colorblindness:
% colorblindness = 'red';
% color_leftAntenna = Colorblind_Convert(color_leftAntenna, colorblindness);
% color_rightAntenna = Colorblind_Convert(color_rightAntenna, colorblindness);

color_rawTrace = black;

tintSingleFly = 0.75;
tintSingleFly_tuning = tintSingleFly;
errorTransparency = 0.5;

color_RMINL = black;
color_RMINL_patch = lightGray;

color_APN2 = [0 204 51]./255;%grassy green
color_APN3 = [153 153 255]./255;%light urple

color_tuningAvg_steady = black;
color_tuningAvg_steady_indv = gray;
color_tuningAvg_onset = red_pure;
color_tuningAvg_onset_indv = color_tuningAvg_onset + tintSingleFly_tuning*(1-color_tuningAvg_onset);

color_ipsiContra_mean = black;
color_ipsiContra_indv = gray;

axisColor = black;
lineColor_zeroDashed = gray;

color_zoom = gray;

color_dualCell1 = black;
color_dualCell2 = black;
%
base = 14;
colors_currInj = flipud([[0:255/base:255-255/base*5];[0:255/base:255-255/base*5];[0:255/base:255-255/base*5]]'./255);

% chrimson colors
colors_chrimson = [gray; robinsEggBlue; softOrange; blue_pure; blueViolet];
color_chrimson_onset = black;%;[0 204 51]./255; %sharp medium green

color_odor_avg = blue; 
color_odor_indv = light_blue;
color_odor_avg = magenta;
lightMagenta = magenta + tintSingleFly*(1-magenta);
color_odor_indv = lightMagenta;

%% Labels
directionNames = {'-90°', '-45°', '0°', '+45°', '+90°'};

%% Fonts
figureFont = 'arial';
fontSize_axis = 6.5;
fontSize_titles = 7;

rotateIpsiContraText = 45;

%% Line widths
htWindBar = 0.25; %height of wind stimulus bar (below all time traces)

width_scale = 1; %scale bar
width_rawTrace = 0.75; %raw time traces
width_avgTrace = 0.75; %average time traces

lineWid_tuning_avg = 2;
lineWid_tuning_indv = 0.5;

lineWid_axis = 1;

ipsiContraIndvSize = 5;
ipsiContraMeanSize = 12;

behaviorIndvSize = 5;
behaviorMeanSize = 10;
jitterAmtBehavior = 0.05;
behaviorLineSizeIndv = 0.5;
behaviorLineSizeMean = 1;
behaviorMarker = 'none'; %don't plot dot at ends of lines
markerSize_spikes = 3;

chrimsonQuantMeanSize = 10;
jitterAmt = 0.2; %degree to which we jitter ipsi-contra individual means in x for clarity
jitterAmtDual = 2; 
ipsiContraMeanLineSize = 1;
ipsiContraMeanErrorLineSize = 0.5;

%% Data scales
traces_scale = 22;
traces_scale_anemometer = 70;
traces_scale_anemometerWithOdor = 100;
traces_scale_PID = 5;
tuning_scale_antenna = 24;
tuning_scale_neural = 23;
tuning_scale_spikerate = 50;
tuning_scale_normalized = 3;

tuning_scale_APN3 = 17;
tuning_scale_WPN = [13];

scale_ipsiContra = 35;
yAxis_ipsiContra_aPN = [-5 0 5 10]; %HARD-CODE
yAxis_ipsiContra_aPN2 = [-5 0 5 10]; %HARD-CODE
yAxis_ipsiContra_aPN3 = [-10 -5 0 5]; %HARD-CODE
yAxis_ipsiContra_wPN = [0 5 10]; %HARD-CODE
yAxis_ipsiContra_TNT = [-5 0 5 10 15]; %HARD-CODE
yAxis_quant_Chrimson = [-4 0 4];
yAxis_quant_Behavior = [-5 0 5 10];
yAxis_quant_BehaviorIndv = [-10 0 10];
ylimBehavior = [-20 15];
yAxis_quant_Behavior2Indv = [-20 0 20 40 60 80 100 120];
yAxis_quant_BehaviorAngvBase = [0 100 200];
yAxis_quant_BehaviorAngvPairs = [0 40 80];

yAxis_quant_WindOdor1 = [-10 0 10];
yAxis_quant_WindOdor2 = [-6 0 6];

yAxis_SR_aPN3 = [30 35 40]; %HARD-CODE
yAxis_SR_wPN = [5 10 15 20 25]; %HARD-CODE



