function varargout = A2B(varargin)
% A2B MATLAB code for A2B.fig
%      A2B, by itself, creates a new A2B or raises the existing
%      singleton*.
%
%      H = A2B returns the handle to a new A2B or the handle to
%      the existing singleton*.
%
%      A2B('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in A2B.M with the given input arguments.
%
%      A2B('Property','Value',...) creates a new A2B or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before A2B_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to A2B_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help A2B

% Last Modified by GUIDE v2.5 09-Feb-2018 14:07:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @A2B_OpeningFcn, ...
                   'gui_OutputFcn',  @A2B_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before A2B is made visible.
function A2B_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to A2B (see VARARGIN)

% Choose default command line output for A2B
handles.output = hObject;

% Set default values here (G Zalles)
handles.encode = 'acn';

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes A2B wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = A2B_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in encode.
function encode_Callback(hObject, eventdata, handles)
% hObject    handle to encode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%check that all the audio files have been uploaded prior to encoding by
%evaluating the state of the toggle buttons

%% error here, have not yet resolved this...
% if handles.FLU_state == 0 || handles.FRD_state == 0 || ...
%         handles.BLD_state == 0 || handles.BRU_state == 0
%     error('All audio files must be uploaded prior to encoding.');
% end

%check that sample rate is the same accross files
if handles.FLU_fs ~= handles.FRD_fs || ...
        handles.FLU_fs ~= handles.BLD_fs ...
        || handles.FLU_fs ~= handles.BRU_fs
    error('All sample rates should match.');
    %maybe do something different
    %if the sample rates don't match ask the user what sample rate he
    %wishes to use. (unlikely case).
end

%store data in temp var
FLU = handles.FLU_data;
FRD = handles.FRD_data;
BLD = handles.BLD_data;
BRU = handles.BRU_data;
filename = handles.filename; 

%disp error if filename string not found
if isempty(filename);
    error('Please provide a filename.')
end

%sample rate passed to encoder same as front left up (aka mic 1)
fs = handles.FLU_fs;
encoding = handles.encode;

A2B_encoder(FLU, FRD, BLD, BRU, filename, fs, encoding );

% --- Executes on button press in loadFLU.
function loadFLU_Callback(hObject, eventdata, handles)
%get file
[filename, pathname] = uigetfile('*.wav');
%concat strings creating path
FILENAME_PATH = strcat(pathname, filename);
%read
[handles.FLU_data, handles.FLU_fs] = audioread(FILENAME_PATH);
%update handles structure
guidata(hObject, handles);
%call radio button
FLUloaded_Callback(hObject, eventdata, handles);

%Executes on button press in FLUloaded.
function FLUloaded_Callback(hObject, eventdata, handles)

%check that audio is there, if so update button.
%if there is more than 0 columns there is audio
if size(handles.FLU_data, 2) > 0
    handles.FLUloaded.Value = 1;
    %disp('foo'); %enters
end

%get state of button
handles.FLU_state = get(hObject, 'Value'); 

%update handles
guidata(hObject, handles);

% --- Executes on button press in loadBLD.
function loadBLD_Callback(hObject, eventdata, handles)
%get file
[filename, pathname] = uigetfile('*.wav');
%concat strings creating path
FILENAME_PATH = strcat(pathname, filename);
%read
[handles.BLD_data, handles.BLD_fs] = audioread(FILENAME_PATH);
%update handles structure
guidata(hObject, handles);
%call radio button
BLDloaded_Callback(hObject, eventdata, handles);

% --- Executes on button press in BLDloaded.
function BLDloaded_Callback(hObject, eventdata, handles)
%check that audio is there, if so update button.
if size(handles.BLD_data, 2) > 0
    handles.BLDloaded.Value = 1;
end

%get state of button
handles.BLD_state = get(hObject, 'Value'); 
guidata(hObject, handles);

% --- Executes on button press in loadFRD.
function loadFRD_Callback(hObject, eventdata, handles)
%get file
[filename, pathname] = uigetfile('*.wav');
%concat strings creating path
FILENAME_PATH = strcat(pathname, filename);
%read
[handles.FRD_data, handles.FRD_fs] = audioread(FILENAME_PATH);
%update handles structure
guidata(hObject, handles);
%call radio button
FRDloaded_Callback(hObject, eventdata, handles);

% --- Executes on button press in FRDloaded.
function FRDloaded_Callback(hObject, eventdata, handles)
%check that audio is there, if so update button.
if size(handles.FRD_data, 2) > 0
    handles.FRDloaded.Value = 1;
end

%get state of button
handles.FRD_state = get(hObject, 'Value'); 
guidata(hObject, handles);

% --- Executes on button press in loadBRU.
function loadBRU_Callback(hObject, eventdata, handles)
%get file
[filename, pathname] = uigetfile('*.wav');
%concat strings creating path
FILENAME_PATH = strcat(pathname, filename);
%read
[handles.BRU_data, handles.BRU_fs] = audioread(FILENAME_PATH);
%update handles structure
guidata(hObject, handles);
%call radio button
BRUloaded_Callback(hObject, eventdata, handles);

% --- Executes on button press in BRUloaded.
function BRUloaded_Callback(hObject, eventdata, handles)
%check that audio is there, if so update button.
if size(handles.BRU_data, 2) > 0
    handles.BRUloaded.Value = 1;
end

%get state of button
handles.BRU_state = get(hObject, 'Value'); 
guidata(hObject, handles);

function filename_edit_Callback(hObject, eventdata, handles)
% hObject    handle to filename_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.filename = get(hObject,'String');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function filename_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filename_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in clear_all.
function clear_all_Callback(hObject, eventdata, handles)
% hObject    handle to clear_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.filename_edit, 'String',  '');
set(handles.FLUloaded, 'Value', 0);
set(handles.BLDloaded, 'Value', 0);
set(handles.FRDloaded, 'Value', 0);
set(handles.BRUloaded, 'Value', 0);
clear;
clc;
%set(handles.

function ordering_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ordering_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ordering_edit as text
%        str2double(get(hObject,'String')) returns contents of ordering_edit as a double

% --- Executes during object creation, after setting all properties.
function ordering_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ordering_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in acn_button.
function acn_button_Callback(hObject, eventdata, handles)
% hObject    handle to acn_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of acn_button

%if value is one choose acn
if get(hObject,'Value')
    handles.encode = 'acn';
end

%update handles structure
guidata(hObject, handles);

% --- Executes on button press in fuma_button.
function fuma_button_Callback(hObject, eventdata, handles)
% hObject    handle to fuma_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fuma_button

%if value is one choose fuma
if get(hObject,'Value')
    handles.encode = 'fuma';
end

%update handles structure
guidata(hObject, handles);

% --- Executes on button press in load_4_channel.
function load_4_channel_Callback(hObject, eventdata, handles)
% hObject    handle to load_4_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%get file

[filename, pathname] = uigetfile('*.wav');
%concat strings creating path
FILENAME_PATH = strcat(pathname, filename);
%read the file
[four_channel_data, four_channel_fs] = ...
    audioread(FILENAME_PATH);

%FLU, FRD, BLD, BRU handles
handles.FLU_data = four_channel_data(:, 1);
handles.FRD_data = four_channel_data(:, 2);
handles.BLD_data = four_channel_data(:, 3);
handles.BRU_data = four_channel_data(:, 4);

%fs handles
handles.FLU_fs = four_channel_fs;
handles.FRD_fs = four_channel_fs;
handles.BLD_fs = four_channel_fs;
handles.BRU_fs = four_channel_fs;

%update handles structure (makes sure loaded recognizes new data)
guidata(hObject, handles);

%call all radio buttons (FLU, FRD, BLD, BRU)
FLUloaded_Callback(hObject, eventdata, handles);
FRDloaded_Callback(hObject, eventdata, handles);
BLDloaded_Callback(hObject, eventdata, handles);
BRUloaded_Callback(hObject, eventdata, handles);

%update handles structure (update to allow encoding failsafe)
guidata(hObject, handles);
