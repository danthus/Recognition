function varargout = drawGUI(varargin)
%DRAWGUI MATLAB code file for drawGUI.fig
%      DRAWGUI, by itself, creates a new DRAWGUI or raises the existing
%      singleton*.
%
%      H = DRAWGUI returns the handle to a new DRAWGUI or the handle to
%      the existing singleton*.
%
%      DRAWGUI('Property','Value',...) creates a new DRAWGUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to drawGUI_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      DRAWGUI('CALLBACK') and DRAWGUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in DRAWGUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help drawGUI

% Last Modified by GUIDE v2.5 19-Nov-2018 23:06:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @drawGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @drawGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before drawGUI is made visible.
function drawGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for drawGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes drawGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

handles.output = hObject;

matrix = zeros(560,560);
showed = zeros(28,28);

axes(handles.axes1)
imshow(matrix);

axes(handles.axes2)
imshow(zeros(28,28));

while true
    axes(handles.axes1);
    paint = imfreehand('Closed',false);
    
    xy = round(paint.getPosition);
    x = xy(:,1);
    y = xy(:,2);
    for i = 1:size(x)
        matrix(y(i),x(i))= 255;
    end
    
    resized = imresize(matrix,[28,28]);
    resized = mat2gray(resized);

    enhanced = zeros(28,28);
    for r = 1:28
        for c = 1:28
            if(resized(r,c)>0.6 && resized(r,c)<0.8)
                enhanced(r,c) = resized(r,c)+0.2;
            elseif(resized(r,c)>0.4 && resized(r,c)<0.6)
                enhanced(r,c) = resized(r,c)+0.4;
            elseif(resized(r,c)>0.2 && resized(r,c)<0.4)
                enhanced(r,c) = resized(r,c)+0.55;
            end
        end
    end

    for row = 2:27
        for col = 2:27
            count = 0;
            if(enhanced(row,col)==0)
                if(enhanced(row-1,col)~=0)
                    count = count + 1;
                end
                if(enhanced(row,col-1)~=0)
                    count = count + 1;
                end
                if(enhanced(row+1,col)~=0)
                    count = count + 1;
                end
                if(enhanced(row,col+1)~=0)
                    count = count + 1;
                end
            end

            if(count >= 3)
                enhanced(row,col)=1;
            end

        end 
    end
    
    showed = enhanced + showed;
    axes(handles.axes2);
    imshow(showed);
    
    if get(handles.finishbutton,'userdata')
        set(handles.finishbutton,'userdata',[]);
         nnet = evalin('base','ssnet');
         cate = classify(nnet,enhanced);
         result = double(cate) - 1;
         set(handles.result,'String',result);         
    end
           
end


% --- Outputs from this function are returned to the command line.
function varargout = drawGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in finishbutton.
function finishbutton_Callback(hObject, eventdata, handles)
% hObject    handle to finishbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.finishbutton,'userdata',1);
