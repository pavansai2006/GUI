function varargout = sample(varargin)
% SAMPLE MATLAB code for sample.fig
%      SAMPLE, by itself, creates a new SAMPLE or raises the existing singleton*.
%      H = SAMPLE returns the handle to a new SAMPLE or the handle to the existing singleton*.
%      SAMPLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAMPLE.M with the given input arguments.
%      SAMPLE('Property','Value',...) creates a new SAMPLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sample_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sample_OpeningFcn via varargin.

% Last Modified by GUIDE v2.5 12-May-2025 17:36:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sample_OpeningFcn, ...
                   'gui_OutputFcn',  @sample_OutputFcn, ...
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

function sample_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
handles.OriginalImage = [];
handles.CurrentImagePath = '';
guidata(hObject, handles);

function varargout = sample_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% Upload Image
function pushbutton5_Callback(hObject, eventdata, handles)
[file, path] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp', 'Image Files (*.jpg, *.jpeg, *.png, *.bmp)'});
if isequal(file, 0)
    return;
end
a = imread(fullfile(path, file));
axes(handles.axes1);
imshow(a);
handles.OriginalImage = a;
handles.CurrentImagePath = fullfile(path, file);
guidata(hObject, handles);

%Reset
function pushbutton4_Callback(hObject, eventdata, handles)
if ~isempty(handles.OriginalImage)
    axes(handles.axes1);
    imshow(handles.OriginalImage);
end

% Gray Image
function pushbutton1_Callback(hObject, eventdata, handles)
img = handles.OriginalImage;
if isempty(img)
    errordlg('No image loaded.', 'Error');
    return;
end
if size(img, 3) == 3
    grayImg = rgb2gray(img);
else
    grayImg = img;
end
axes(handles.axes1);
imshow(grayImg);

% Histogram
function pushbutton2_Callback(hObject, eventdata, handles)
img = handles.OriginalImage;
if isempty(img)
    errordlg('No image loaded.', 'Error');
    return;
end
if size(img, 3) == 3
    img = rgb2gray(img);
end
figure;
imhist(img);

%HSV
function pushbutton3_Callback(hObject, eventdata, handles)
img = handles.OriginalImage;
if isempty(img)
    errordlg('No image loaded.', 'Error');
    return;
end
hsvImg = rgb2hsv(img);
axes(handles.axes1);
imshow(hsvImg);

%Brightness
function pushbutton9_Callback(hObject, eventdata, handles)
img = handles.OriginalImage;
if isempty(img)
    errordlg('No image loaded.', 'Error');
    return;
end
brightImg = imadd(img, 50);
axes(handles.axes1);
imshow(brightImg);

% Image Info
function pushbutton8_Callback(hObject, eventdata, handles)
if isempty(handles.OriginalImage)
    errordlg('No image loaded.', 'Error');
    return;
end
try
    info = imfinfo(handles.CurrentImagePath);
catch
    errordlg('Image information not available.', 'Error');
    return;
end
img = handles.OriginalImage;
msg = sprintf('Dimensions: %d x %d x %d\nFormat: %s\nFile Size: %.2f KB', ...
    size(img, 1), size(img, 2), size(img, 3), info.Format, info.FileSize / 1024);
msgbox(msg, 'Image Info');

% Flip
function pushbutton7_Callback(hObject, eventdata, handles)
img = handles.OriginalImage;
if isempty(img)
    errordlg('No image loaded.', 'Error');
    return;
end
flipped = flip(img, 2);
axes(handles.axes1);
imshow(flipped);

% Add Noise
function pushbutton6_Callback(hObject, eventdata, handles)
img = handles.OriginalImage;
if isempty(img)
    errordlg('No image loaded.', 'Error');
    return;
end
noisy = imnoise(img, 'salt & pepper', 0.02);
axes(handles.axes1);
imshow(noisy);

% Remove Noise
function pushbutton10_Callback(hObject, eventdata, handles)
img = handles.OriginalImage;
if isempty(img)
    errordlg('No image loaded.', 'Error');
    return;
end
if size(img, 3) == 3
    denoisedR = medfilt2(img(:, :, 1), [3 3]);
    denoisedG = medfilt2(img(:, :, 2), [3 3]);
    denoisedB = medfilt2(img(:, :, 3), [3 3]);
    denoised = cat(3, denoisedR, denoisedG, denoisedB);
else
    denoised = medfilt2(img, [3 3]);
end
axes(handles.axes1);
imshow(denoised);

% Binary
function pushbutton11_Callback(hObject, eventdata, handles)
img = handles.OriginalImage;
if isempty(img)
    errordlg('No image loaded.', 'Error');
    return;
end
if size(img, 3) == 3
    img = rgb2gray(img);
end
threshold = 128;
binaryImage = img > threshold;
axes(handles.axes1);
imshow(binaryImage);
