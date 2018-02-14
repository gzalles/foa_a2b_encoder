function A2B_encoder(FLU, FRD, BLD, BRU, filename, fs, ordering)
% function A2B_encoder(FLU, FRD, BLD, BRU, filename, fs, ordering)
%
% This function will encode 4 audio files from a fist order ambisonic
% recording to B format. A single 4 track file will be created.
%
% FLU - front left up
% FRD - front right down
% BLD - back left down
% BRU - back right up
% filename - used for audiowrite (.wav)
% fs - sampling rate of the resulting audio
% ordering - string, either 'acn' or 'fuma'
%
% The main formula: (type I?)
%
% W = FLU+FRD+BLD+BRU
% X = FLU+FRD-BLD-BRU
% Y = FLU-FRD+BLD-BRU
% Z = FLU-FRD-BLD+BRU
%
% todo:
% the script can only be used for FOA at the moment.
% filters (see ref)
%
% ref
% http://pcfarina.eng.unipr.it/Public/B-format/A2B-conversion/A2B.htm

%% some error checking stuff

%if the length of the file string is less than or equal to 4
if length(filename) <= 4
    %add .wav extension
    filename = strcat(filename, '.wav');
    %else if extension is not .wav
elseif ~strcmpi('.wav', filename(end-3:end))
    error('Please use .wav as your extension.');
end

%% the main stuff

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

%Encoding
W = FLU + FRD + BLD + BRU; %all encompasing
X = FLU + FRD - BLD - BRU; %front to back
Y = FLU - FRD + BLD - BRU; %left to right
Z = FLU - FRD - BLD + BRU; %up and down

%W normalization factor used across spherical harmonics
W = 0.99 * W / max(abs(W));
X = 0.99 * X / max(abs(W));
Y = 0.99 * Y / max(abs(W));
Z = 0.99 * Z / max(abs(W));

%select ordering
% ref: https://ccrma.stanford.edu/software/openmixer/manual/ambisonics_mode
if strcmpi(ordering, 'acn')
    
    W = W * sqrt(0.5);%SN3D
    B_format_audio = [W Y Z X]; %acn
    
elseif strcmpi(ordering, 'fuma')
    
    W = W * sqrt(0.5);%MaxN (seems like for FOA norm is identical)
    B_format_audio = [W X Y Z]; %fuma
end

%% directory stuff

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