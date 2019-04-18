function varargout = quickPlotter(varargin)
% QUICKPLOTTER M-file for quickPlotter.fig
%      QUICKPLOTTER, by itself, creates a new QUICKPLOTTER or raises the existing
%      singleton*.
%
%      H = QUICKPLOTTER returns the handle to a new QUICKPLOTTER or the handle to
%      the existing singleton*.
%
%      QUICKPLOTTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in QUICKPLOTTER.M with the given input arguments.
%
%      QUICKPLOTTER('Property','Value',...) creates a new QUICKPLOTTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before quickPlotter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to quickPlotter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help quickPlotter

% Last Modified by GUIDE v2.5 25-Jun-2015 11:37:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @quickPlotter_OpeningFcn, ...
                   'gui_OutputFcn',  @quickPlotter_OutputFcn, ...
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


% --- Executes just before quickPlotter is made visible.
function quickPlotter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to quickPlotter (see VARARGIN)

% Choose default command line output for quickPlotter
global hFig;
global hAx;
handles.output = hObject;
hFig=[];
hAx=[];
% Update handles structure
guiData=handles;
guiData.hPlot=createNewFigure(hObject);
guiData.updateGui=@updateGui;
guiData.getY=@getY;
guiData.getX1=@getX1;
guiData.getX2=@getX2;
guiData = restoreGUI(guiData);
% guiData.updateSPM=@updateSPM;

set(guiData.PlottingTypesLstBx,'String', {'Line' 'Scatter' 'Histogram' 'Summary'});
set(guiData.PlottingOptionsLstBx,'String',{'Y' 'X1' 'X2' 'X1||Y' 'X2||Y' 'X1, Y' 'X2, Y' 'X1, X2' 'Command'});
set(guiData.Function1LstBx,'String',{'Command line'});
set(guiData.Function2LstBx,'String',{'Command line'});
set(guiData.CommandLstBx,'String',{'Command line'});

guidata(hObject, guiData);

% UIWAIT makes quickPlotter wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function guiData=restoreGUI(guiData)
guiData.statusMap=StatusMap('quickPlotter');
restoreFunction1Lst(guiData.statusMap);
restoreFunction2Lst(guiData.statusMap);
restoreCommandLst(guiData.statusMap);

function restoreFunction1Lst(map)
function restoreFunction2Lst(map)
function restoreCommandLst(map)

% --- Outputs from this function are returned to the command line.
function varargout = quickPlotter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on selection change in RowNameLstBx.
function RowNameLstBx_Callback(hObject, eventdata, handles)
% hObject    handle to RowNameLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns RowNameLstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from RowNameLstBx
guiData=guidata(hObject);
synchRowNumber(hObject, get(guiData.RowNameLstBx,'Value'));

% --- Executes during object creation, after setting all properties.
function RowNameLstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RowNameLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in YLstBx.
function YLstBx_Callback(hObject, eventdata, handles)
% hObject    handle to YLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns YLstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from YLstBx
guiData=guidata(hObject);
synchRowNumber(hObject, get(guiData.YLstBx,'Value'));


% --- Executes during object creation, after setting all properties.
function YLstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in X1LstBx.
function X1LstBx_Callback(hObject, eventdata, handles)
% hObject    handle to X1LstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns X1LstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from X1LstBx
guiData=guidata(hObject);
synchRowNumber(hObject, get(guiData.X1LstBx,'Value'));


% --- Executes during object creation, after setting all properties.
function X1LstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to X1LstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in X2LstBx.
function X2LstBx_Callback(hObject, eventdata, handles)
% hObject    handle to X2LstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns X2LstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from X2LstBx
guiData=guidata(hObject);
synchRowNumber(hObject, get(guiData.X2LstBx,'Value'));

% --- Executes during object creation, after setting all properties.
function X2LstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to X2LstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in X1ChoiceLstBx.
function X1ChoiceLstBx_Callback(hObject, eventdata, handles)
% hObject    handle to X1ChoiceLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns X1ChoiceLstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from X1ChoiceLstBx
updateXList(hObject);
plotData(hObject);
% --- Executes during object creation, after setting all properties.
function X1ChoiceLstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to X1ChoiceLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in X2ChoiceLstBx.
function X2ChoiceLstBx_Callback(hObject, eventdata, handles)
% hObject    handle to X2ChoiceLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns X2ChoiceLstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from X2ChoiceLstBx
updateXList(hObject);
plotData(hObject);

% --- Executes during object creation, after setting all properties.
function X2ChoiceLstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to X2ChoiceLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PlottingOptionsLstBx.
function PlottingOptionsLstBx_Callback(hObject, eventdata, handles)
% hObject    handle to PlottingOptionsLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PlottingOptionsLstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PlottingOptionsLstBx
guiData=guidata(hObject);
subInds=get(guiData.SubplotLstBx,'Value');
len=length(subInds);
if(len>1)%multiple subplot selection
    subs=guiData.subplots;
    for i=1:len
        subs{subInds(i)}.updatePlottingOption(hObject);
    end
end
plotData(hObject);

% --- Executes during object creation, after setting all properties.
function PlottingOptionsLstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlottingOptionsLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function updateGui(hObject, data, colNames, rowNames, appendData)

if(~exist('appendData','var'))
    appendData=false;
end
guiData=guidata(hObject);
if(~exist('data','var'))
    data=[];
end
if(~exist('colNames','var'))
    colNames=[];
end
if(~exist('rowNames','var'))
    rowNames=[];
end


if(~isempty(data))
    dim=size(data);
    if(length(rowNames)~=dim(1))
        rowNames=arrayfun(@(x) num2str(x), 1:dim(1), 'UniformOutput', false);
    end
    if(length(colNames)~=dim(2))
        col=arrayfun(@(x) num2str(x), 1:dim(2), 'UniformOutput', false);
    end
end

if(appendData)
    data0=guiData.data;
    if(size(data0,1)==size(data,1))
        data=[data0 data];
        colNames=horzcat(guiData.colNames, colNames);
    end
end

if(isfield(guiData,'data'))
    if(size(guiData.data,1)~=size(data, 1))
        set(guiData.SubplotLstBx, 'Value', 1);
    end
end

guiData.data=data;
guiData.colNames=colNames;
guiData.rowNames=rowNames;

guidata(hObject, guiData);
updateYChoiceLst(hObject,colNames);
updateX1ChoiceLst(hObject,colNames);
updateX2ChoiceLst(hObject,colNames);
updateRowName(hObject,rowNames);
set(guiData.X1LstBx,'Value', 1);
set(guiData.X2LstBx,'Value', 1);
set(guiData.YLstBx,'Value', 1);
updateXList(hObject);
updateY(hObject);
plotData(hObject);
updateSubplotLstBx(hObject);

function updateRowName(hObject, names)
guiData=guidata(hObject);
set(guiData.RowNameLstBx, 'String', names);

function updateYChoiceLst(hObject,choices)
choices=horzcat(choices, {'Function2'});
guiData=guidata(hObject);
oldChoices=get(guiData.YChoiceLstBx, 'String');
if(~sameChoices(choices, oldChoices))
    set(guiData.YChoiceLstBx,'String', choices);
    set(guiData.YChoiceLstBx,'Value', 1);
    set(guiData.YChoiceLstBx,'Max',length(choices));
end

function updateX1ChoiceLst(hObject,choices)
guiData=guidata(hObject);
oldChoices=get(guiData.X1ChoiceLstBx, 'String');
if(~sameChoices(choices, oldChoices))
    set(guiData.X1ChoiceLstBx,'String', choices);
    set(guiData.X1ChoiceLstBx,'Value', 1);
    set(guiData.X1ChoiceLstBx,'Max',length(choices));
end

function updateX2ChoiceLst(hObject,choices)
choices=horzcat(choices, {'Function1'});
guiData=guidata(hObject);
oldChoices=get(guiData.X2ChoiceLstBx, 'String');
if(~sameChoices(choices, oldChoices))
    set(guiData.X2ChoiceLstBx,'String', choices);
    set(guiData.X2ChoiceLstBx,'Value', 1);
    set(guiData.X2ChoiceLstBx,'Max',length(choices));
end

function IS=sameChoices(c1, c2)
len=length(c1);
if(len~=length(c2))
    IS=false;
    return;
end
for i=1:len
    if(~strcmp(c1{i}, c2{i}))
        IS=false;
        return;
    end
end
    
IS=true;

function updateXList(hObject)
X1=getX1(hObject);
X2=getX2(hObject);
X1=arrayfun(@(x) num2str(x), X1, 'UniformOutput', false);
X2=arrayfun(@(x) num2str(x), X2, 'UniformOutput', false);

guiData=guidata(hObject);
set(guiData.X1LstBx,'String', X1);
set(guiData.X2LstBx,'String', X2);

function updateY(hObject)
Y=getY(hObject);
if(~isempty(Y))
    YL=arrayfun(@(x) num2str(x), Y, 'UniformOutput', false);
    guiData=guidata(hObject);
    set(guiData.YLstBx,'String',YL);
end

function [Y, yInd, choice] =getY(hObject)
Y=[];
guiData=guidata(hObject);
data=guiData.data;
if(~isempty(data))
    id=get(guiData.YChoiceLstBx,'Value');
    choices=get(guiData.YChoiceLstBx,'String');
    choice=choices{id};
    if(strcmp(choice,'Function2'))
        Y=evalFunction2();
        if(isempty(Y))
            Y=data(:,1);
        end
    else
        Y=data(:,id);
    end
    yInd=id;
end

function [X1, xInd, choice] =getX1(hObject)
X1=[];
xInd=[];
choice=[];
if(exist('hObject','var'))
    guiData=guidata(hObject);
    data=guiData.data;
    if(~isempty(data))
        id1=get(guiData.X1ChoiceLstBx,'Value');
        choices=get(guiData.X1ChoiceLstBx, 'String');
        choice=choices{id1};
        X1=data(:,id1);
        xInd=id1;
    end
end

function [X2, xInd, choice] =getX2(hObject)
X2=[];
guiData=guidata(hObject);
data=guiData.data;
if(~isempty(data))
    id2=get(guiData.X2ChoiceLstBx,'Value');
    choices=get(guiData.X2ChoiceLstBx,'String');
    choice=choices{id2};
    if(strcmp(choice,'Function1'))
        X2=evalFunction1();
        if(isempty(X2))
            X2=data(:,1);
        end
    else
        X2=data(:,id2);
    end
    xInd=id2;
end

function out = evalFunction1()
out=[];
function out = evalFunction2()
out=[];
function out = evalComman()
out=[];

function synchRowNumber(hObject, value)
guiData=guidata(hObject);
set(guiData.X1LstBx,'Value',value);
set(guiData.X2LstBx,'Value',value);
set(guiData.YLstBx,'Value',value);
set(guiData.RowNameLstBx,'Value',value);

function hFig = createNewFigure(hObject, cloneSub)
if(~exist('cloneSub','var'))
    cloneSub=false;
end
hFig=figure();
if(cloneSub)
    copySubplots(hObject,hFig);
else
    subplot(1,1,1);
    CommonMethods.arrangeSubplots(hFig, [1 1], @registerGCA);
end

guiDataF=guidata(hFig);
guiDataF.creatorApp='quickPlotter';
guiDataF.creatorHandle=hObject;
guidata(hFig, guiDataF);

guiData=guidata(hObject);
guiData.hPlot=hFig;
if(isfield(guiData, 'hAxis'))
%    guiData=rmfield(guiData, 'hAxis');
end
guidata(hObject,guiData);
updateSubplotLstBx(hObject);

function plotData(hObject)
global hPlot;
hPlot=hObject;
guiData = guidata(hObject);

choice=get(guiData.PlottingOptionsLstBx, 'Value');
options=get(guiData.PlottingOptionsLstBx, 'String');
option=options{choice};
if(~isfield(guiData,'hPlot'))
     createNewFigure(hObject);
     guiData=guidata(hObject);
end

if(~CommonMethods.isFigureHandle(guiData.hPlot))
     createNewFigure(hObject);
     guiData=guidata(hObject);
end

guidata(hObject, guiData);

spInd=get(guiData.SubplotLstBx, 'Value');
spHandlers=CommonMethods.getSubplotHandlers(guiData.hPlot);
sphs=spHandlers(spInd);
if(length(sphs)==1)
    sph=sphs{1};%update(obj,xData,yData,hFig,xInds,yInds,title,xLabel,yLabel,option, style)
    sph.updateQPGuiHandler(hObject);
    sph.plot();
else
    for i=1:length(sphs)
        sph=sphs{i};
        sph.updateData(hObject);
        sph.plot();
    end
end

%title(option,'fontsize',18);
ax=gca;
guiData.hAxis=ax;
guiData.subplots=CommonMethods.getSubplotHandlers(guiData.hPlot);

if(get(guiData.UnifyYScalesCB,'Value'))
    unifyYScales(hObject);
end

if(get(guiData.UnifyXScalesCB,'Value'))
    unifyXScales(hObject);
end

guidata(hObject, guiData);
updateSubplotLstBx(hObject);


function YL = getYLabel(hObject)
guiData=guidata(hObject);
h=guiData.YChoiceLstBx;
YL=get(h,'String');
ID=get(h,'Value');
YL=YL{ID};
YL=CommonMethods.makeFigureLabel(YL,20);

function L = getX1Label(hObject)
guiData=guidata(hObject);
h=guiData.X1ChoiceLstBx;
L=get(h,'String');
ID=get(h,'Value');
L=L{ID};
L=CommonMethods.makeFigureLabel(L,20);

function L = getX2Label(hObject)
guiData=guidata(hObject);
h=guiData.X2ChoiceLstBx;
L=get(h,'String');
ID=get(h,'Value');
L=L{ID};
L=CommonMethods.makeFigureLabel(L,20);


% --- Executes on selection change in YChoiceLstBx.
function YChoiceLstBx_Callback(hObject, eventdata, handles)
% hObject    handle to YChoiceLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns YChoiceLstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from YChoiceLstBx
updateY(hObject);
plotData(hObject);

% --- Executes during object creation, after setting all properties.
function YChoiceLstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YChoiceLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SubplotTF_Callback(hObject, eventdata, handles)
% hObject    handle to SubplotTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SubplotTF as text
%        str2double(get(hObject,'String')) returns contents of SubplotTF as a double
global hFig;
global hAx;
guiData=guidata(hObject);
if(~CommonMethods.isFigureHandle(hFig))
    hFig=guiData.hPlot;
end
dim=CommonMethods.str2nums_decimal(get(guiData.SubplotTF,'String'));
figure(hFig);
CommonMethods.arrangeSubplots(hFig,dim,@registerGCA);
updateSubplotLstBx(hObject);

% --- Executes during object creation, after setting all properties.
function SubplotTF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SubplotTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in GetCurrentAxisBT.
function GetCurrentAxisBT_Callback(hObject, eventdata, handles)
% hObject    handle to GetCurrentAxisBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global hFig;
global hAx;
guiData=guidata(hObject);
guiData.hPlot=hFig;
guiData.hAxis=hAx;
guiData.subplots=CommonMethods.getSubplotHandlers(hFig);
guidata(hObject, guiData);
updateSubplotLstBx(hObject);

function registerGCA(varargin)
global hFig;
global hAx;
global hPlot;
h=gcf;
if(strcmp(CommonMethods.getCreatorApp(h),  'quickPlotter'))
    hFig=gcf;
    hAx=gca;
    cp=get(hAx,'CurrentPoint');
    if(ishandle(hPlot))
        GetCurrentAxisBT_Callback(hPlot);
    end
    hc=CommonMethods.getCreatorHandle(h);
    if(ishandle(hc))
        
        updateCurrentPoint(hc, hAx, cp);
    end
end

function updateCurrentPoint(hObject, hAx, cp)
guiData=guidata(hObject);
hFig=guiData.hPlot;
xy=cp(1,1:2);
subs=CommonMethods.getSubplotHandlers(hFig);
for i=1:length(subs)
    sub=subs{i};
    sub.markCurrentPoint(cp);
end
sub=CommonMethods.getOverlappingSubplot(get(hAx,'position'),subs);
currRow=sub.getCurrentRow(cp);
if(~isempty(currRow))
    synchRowNumber(hObject, currRow);
end


% --- Executes on selection change in SubplotLstBx.
function SubplotLstBx_Callback(hObject, eventdata, handles)
% hObject    handle to SubplotLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SubplotLstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SubplotLstBx

guiData=guidata(hObject);
if(CommonMethods.isFigureHandle(guiData.hPlot))
    subs=CommonMethods.getSubplotHandlers(guiData.hPlot);
    ID=get(guiData.SubplotLstBx,'Value');
    if(length(ID)==1)
        sub=subs{ID};
        ax=sub.hAxs;
        if(ishandle(ax))
            axes(ax);
            registerGCA();
            GetCurrentAxisBT_Callback(hObject);
        end
    end
end
% --- Executes during object creation, after setting all properties.
function SubplotLstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SubplotLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function unifyYScales(hObject)
guiData=guidata(hObject);
guiDataF=guidata(guiData.hPlot);
subs=guiDataF.subHandlers;
ids=get(guiData.SubplotLstBx, 'Value');
Axs=[];
for i=1:length(ids)
    Axs=[Axs subs{i}.hAxs];
end
CommonMethods.unifyYScales(Axs);

function unifyXScales(hObject)
guiData=guidata(hObject);
guiDataF=guidata(guiData.hPlot);
subs=guiDataF.subHandlers;
ids=get(guiData.SubplotLstBx, 'Value');
Axs=[];
for i=1:length(ids)
    Axs=[Axs subs{i}.hAxs];
end
CommonMethods.unifyXScales(Axs);

function updateSubplotLstBx(hObject)
guiData=guidata(hObject);
subs=CommonMethods.getSubplotHandlers(guiData.hPlot);
if(length(subs)>0)
    list=cellfun(@(x) x.getDescription(), subs, 'UniformOutput', false);
    Axes=cellfun(@(x) num2str(x.hAxs(1)), subs, 'UniformOutput', false);
    st0=get(guiData.SubplotLstBx, 'String');
    set(guiData.SubplotLstBx, 'String', list);
    
    if(~CommonMethods.strcmp_cell(st0, list))
        set(guiData.SubplotLstBx,'Value', 1);
    end
    
    set(guiData.SubplotLstBx, 'max', length(subs));
    sub=subs{1};
    set(guiData.SubplotTF,'String',[num2str(sub.rows) 'X' num2str(sub.cols)]);

    if(length(get(guiData.SubplotLstBx,'Value'))==1)
        id=1;
        if(isfield(guiData, 'hAxis'))
            hAx=guiData.hAxis;
            id=find(ismember(Axes,num2str(hAx)));
        end
        if(~isempty(id))
            set(guiData.SubplotLstBx, 'Value',id);
        else
            set(guiData.SubplotLstBx, 'Value',1);
        end
    end
    set(guiData.CurrentFigerT, 'String', ['FIGURE: ' num2str(guiData.hPlot)]);
end


% --- Executes on selection change in PlottingTypesLstBx.
function PlottingTypesLstBx_Callback(hObject, eventdata, handles)
% hObject    handle to PlottingTypesLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PlottingTypesLstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PlottingTypesLstBx
guiData=guidata(hObject);
subInds=get(guiData.SubplotLstBx,'Value');
len=length(subInds);
if(len>1)%multiple subplot selection
    subs=guiData.subplots;
    for i=1:len
        subs{subInds(i)}.updatePlottingType(hObject);
    end
end
plotData(hObject);


% --- Executes during object creation, after setting all properties.
function PlottingTypesLstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlottingTypesLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in UnifyYScalesCB.
function UnifyYScalesCB_Callback(hObject, eventdata, handles)
% hObject    handle to UnifyYScalesCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UnifyYScalesCB
unifyYScales(hObject)

% --- Executes on button press in UnifyXScalesCB.
function UnifyXScalesCB_Callback(hObject, eventdata, handles)
% hObject    handle to UnifyXScalesCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UnifyXScalesCB
unifyXScales(hObject)

function copyFigure(hObject)
    createNewFigure(hObject,true);
    plotData(hObject);
    
function copySubplots(hObject,hFig)
    guiData=guidata(hObject);
    subs=CommonMethods.getSubplotHandlers(guiData.hPlot);
    CommonMethods.makeSubplots(hFig,subs);
    guiData.subplots=CommonMethods.getSubplotHandlers(hFig);
    
        


% --- Executes on button press in NewFigureBT.
function NewFigureBT_Callback(hObject, eventdata, handles)
% hObject    handle to NewFigureBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
copyFigure(hObject);



function XSelectionTF_Callback(hObject, eventdata, handles)
% hObject    handle to XSelectionTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of XSelectionTF as text
%        str2double(get(hObject,'String')) returns contents of XSelectionTF as a double
plotData(hObject);

% --- Executes during object creation, after setting all properties.
function XSelectionTF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XSelectionTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function YSelectionTF_Callback(hObject, eventdata, handles)
% hObject    handle to YSelectionTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of YSelectionTF as text
%        str2double(get(hObject,'String')) returns contents of YSelectionTF as a double
plotData(hObject);


% --- Executes during object creation, after setting all properties.
function YSelectionTF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YSelectionTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Function1LstBx.
function Function1LstBx_Callback(hObject, eventdata, handles)
% hObject    handle to Function1LstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Function1LstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Function1LstBx
guiData=guidata(hObject);
ind=get(guiData.Function1LstBx,'Value');
choices=get(guiData.Function1LstBx,'String');
choice=choices{ind};
if strcmp(get(handles.figure1,'SelectionType'),'open')
%    importAssociatedObject(hObject, el, alias);
else
%    set(guiData.FileNameAssociatedObjectTF,'String',el);
end

% --- Executes during object creation, after setting all properties.
function Function1LstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Function1LstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Function2LstBx.
function Function2LstBx_Callback(hObject, eventdata, handles)
% hObject    handle to Function2LstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Function2LstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Function2LstBx


% --- Executes during object creation, after setting all properties.
function Function2LstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Function2LstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in CommandLstBx.
function CommandLstBx_Callback(hObject, eventdata, handles)
% hObject    handle to CommandLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns CommandLstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CommandLstBx


% --- Executes during object creation, after setting all properties.
function CommandLstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CommandLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
