function A2B_encoder(FLU, FRD, BLD, BRU, filename, fs, ordering)
% function A2B_encoder(FLU, FRD, BLD, BRU, filename, fs, ordering)
%
% This function will encode 4 audio files from a fist order ambisonic
% recording to B format. A single 4 B-Format .wav file will be created. The
% audio will be normalized.
%
% FLU - front left up
% FRD - front right down
% BLD - back left down
% BRU - back right up
% filename - used for audiowrite (.wav)
% fs - sampling rate of the resulting audio
% ordering - string, either 'acn' or 'fuma'
%
% The main formula: (for type I arrays - Angelo Farina)
%
% W = FLU+FRD+BLD+BRU [omni]
% X = FLU+FRD-BLD-BRU [back/front]
% Y = FLU-FRD+BLD-BRU [left/right]
% Z = FLU-FRD-BLD+BRU [down/up]
%
% todo:
% HOA
% encoding filters?
%
% ref
% http://pcfarina.eng.unipr.it/Public/B-format/A2B-conversion/A2B.htm

%% some error checking stuff

if length(filename) < 4
    error('Please use a filename that is four or more characters long')
end

%if last four charcters are not .wav then add .wav
if ~strcmpi('.wav', filename(end-3:end))
    error('Please use .wav as your extension.');
end

% Measure the length of the files
l_FLU = length(FLU);
l_FRD = length(FRD);
l_BLD = length(BLD);
l_BRU = length(BRU);

%check that the lengths are the same
if (l_FLU ~= l_FRD || l_FLU ~= l_BLD || l_FLU ~= l_BRU)
    error('Length of audio files do not match.');
    %Could select the smallest one and assume they line up.
end

%% Normalize raw audio based on global max

%store local max values first
local_max = zeros(4, 1);

local_max(1, 1) = max(abs(FLU));
local_max(2, 1) = max(abs(FRD));
local_max(3, 1) = max(abs(BLD));
local_max(4, 1) = max(abs(BRU));

%find global max, the max amplitude accross 4 channels
global_max = max(local_max);

%normalize proportionally
FLU = 0.99 * FLU/global_max;
FRD = 0.99 * FRD/global_max;
BLD = 0.99 * BLD/global_max;
BRU = 0.99 * BRU/global_max;

%% Encoding
W = FLU + FRD + BLD + BRU; %omnidirectional
X = FLU + FRD - BLD - BRU; %front/back
Y = FLU - FRD + BLD - BRU; %left/right
Z = FLU - FRD - BLD + BRU; %up/down

%% Normalize spherical harmonics [traditional norm. not spherical]

W = 0.99 * W/max(abs(W));
X = 0.99 * X/max(abs(X));
Y = 0.99 * Y/max(abs(Y));
Z = 0.99 * Z/max(abs(Z));

%% Select ordering

% ref: https://ccrma.stanford.edu/software/openmixer/manual/ambisonics_mode
if strcmpi(ordering, 'acn')

    W = W * sqrt(0.5);%SN3D 
    B_format_audio = [W Y Z X]; %acn

elseif strcmpi(ordering, 'fuma')

    W = W * sqrt(0.5);%MaxN (seems like for FOA norm is identical)
    B_format_audio = [W X Y Z]; %fuma
end

%% Directory stuff

%change folders
cd b_format;
%write the audio in that folder
audiowrite(filename, B_format_audio, fs);
%go back one folder
cd ..

%% todo
% would there a scenario when we want to interleave? (meaning have separate
% files?

% audiowrite('X.wav', X, fs);
% audiowrite('Y.wav', Y, fs);
% audiowrite('Z.wav', Z, fs);
% audiowrite('W.wav', W, fs);

end
