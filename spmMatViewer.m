function varargout = spmMatViewer(varargin)
% SPMMATVIEWER M-file for spmMatViewer.fig
%      SPMMATVIEWER, by itself, creates a new SPMMATVIEWER or raises the existing
%      singleton*.
%
%      H = SPMMATVIEWER returns the handle to a new SPMMATVIEWER or the handle to
%      the existing singleton*.
%
%      SPMMATVIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPMMATVIEWER.M with the given input arguments.
%
%      SPMMATVIEWER('Property','Value',...) creates a new SPMMATVIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before spmMatViewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to spmMatViewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help spmMatViewer

% Last Modified by GUIDE v2.5 15-May-2015 14:54:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @spmMatViewer_OpeningFcn, ...
                   'gui_OutputFcn',  @spmMatViewer_OutputFcn, ...
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


% --- Executes just before spmMatViewer is made visible.
function spmMatViewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to spmMatViewer (see VARARGIN)

% Choose default command line output for spmMatViewer
handles.output = hObject;

% Update handles structure
guiData=handles;
guiData.updateSPM=@updateSPM;
guidata(hObject, guiData);

% UIWAIT makes spmMatViewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = spmMatViewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function matFilepathTF_Callback(hObject, eventdata, handles)
% hObject    handle to matFilepathTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of matFilepathTF as text
%        str2double(get(hObject,'String')) returns contents of matFilepathTF as a double


% --- Executes during object creation, after setting all properties.
function matFilepathTF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to matFilepathTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ScansLstBx.
function ScansLstBx_Callback(hObject, eventdata, handles)
% hObject    handle to ScansLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ScansLstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ScansLstBx
guiData=guidata(hObject);
setXYScanListValue(hObject, get(guiData.ScansLstBx,'Value'));

% --- Executes during object creation, after setting all properties.
function ScansLstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ScansLstBx (see GCBO)
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
setXYScanListValue(hObject, get(guiData.YLstBx,'Value'));


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
setXYScanListValue(hObject, get(guiData.X1LstBx,'Value'));


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
setXYScanListValue(hObject, get(guiData.X2LstBx,'Value'));

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

function out = updateSPM(hObject, varargin)
global SPM;
global volIndex;
global coor;
if(~isempty(varargin))
    SPM=varargin{1};
    if(ischar(SPM))
        path=fileparts(SPM);
        a=load(SPM);   
        SPM=a.SPM;
        SPM.filepath=path;
    end
    if(length(varargin)==2)
        volIndex=varargin{2};
    else
        volIndex=[1 1 1];
    end
end

guiData=guidata(hObject);
if(isfield(SPM,'filepath'))
    set(guiData.matFilepathTF, 'String', SPM.filepath);
end


set(guiData.PlottingOptionsLstBx,'String',{'Y' 'X1' 'X2' 'X1||Y' 'X2||Y' 'X1, Y' 'X2, Y' 'X1, X2' 'Y Hist' 'Y Hist_Group' 'X1 Hist' 'X2 Hist'});

scans=SPM.xY.P;
%scans in the first level modeling are stored as a column array
if(~iscell(scans)) 
    dim = size(scans);
    
    scan=scans(1,:);
    try
        V=spm_vol(scan);
        di=1;
    catch ME
        scan=scans(:,1)
        try
            V=spm_vol(scan)
            di=2;
        catch ME2
           rethrow(ME2)
        end
    end
        
    temp=scans;
    scans=cell(1,dim(di));
    for i=1:dim(di)
        if(di==1)
            scans{i}=temp(i,:);
        else
            scans{i}=temp(:,i);
        end
    end
end

set(guiData.ScansLstBx,'String', scans);

XChoices=SPM.xX.name;
set(guiData.X1ChoiceLstBx, 'String', XChoices);
set(guiData.X2ChoiceLstBx, 'String', XChoices);

if(~isfield(SPM,'handle'))
    SPM.handle=rand;
end

if(~isfield(SPM, 'vols'))
    temp=cellfun(@(x) spm_read_vols(spm_vol(x)), scans, 'UniformOutput', false);
    len=size(scans,2);
    dim=[size(temp{1}) len];        
    vols=zeros(dim);
    for i=1:len
        vols(:,:,:,i)=temp{i};
    end
    SPM.vols=vols;
    V=spm_vol(scans{1});
    SPM.mat=V.mat;
end
%SPM.vols is turned into a 4D volume.


dim=size(SPM.vols);
dim=dim(1:3);
volIndex(volIndex>dim)=dim(volIndex>dim);
lows=[1 1 1];
volIndex(volIndex<1)=lows(volIndex<1);

if(isempty(volIndex))
    volIndStr=' ';
    coorStr=' ';
else
    volIndStr=[num2str(volIndex(1)) '  ' num2str(volIndex(2)) '  ' num2str(volIndex(3))];
    coor=SPM.mat*([volIndex 1])';
    coor=coor(1:3);
    coorStr=[num2str(coor(1)) '  ' num2str(coor(2)) '  ' num2str(coor(3))];
end

set(guiData.VoxelIndexTF, 'String', volIndStr);
set(guiData.CoordinatesTF, 'String', coorStr);
plotData(hObject);
updateXList(hObject);
updateY(hObject);

out=SPM;

function desMat = getDesignMat_spm(SPM)
desMat=SPM.xX.X;

function updateXList(hObject)
global SPM;
guiData=guidata(hObject);
desMat=SPM.xX.X;

id1=get(guiData.X1ChoiceLstBx,'Value');
id2=get(guiData.X2ChoiceLstBx,'Value');

X1=desMat(:,id1);
X2=desMat(:,id2);

X1=arrayfun(@(x) num2str(x), X1, 'UniformOutput', false);
X2=arrayfun(@(x) num2str(x), X2, 'UniformOutput', false);

set(guiData.X1LstBx,'String', X1);
set(guiData.X2LstBx,'String', X2);

function updateY(hObject)
global volIndex;
global SPM;
global Y;
if(~isempty(volIndex)&&isfield(SPM,'vols'))
    vols=SPM.vols;
    dim=size(vols);
    %now vols should be a cellarray of 3D voluem.
    if iscell(vols)
        Y=arrayfun(@(x) SPM.vols{x}(volIndex(1), volIndex(2), volIndex(3)), 1:length(SPM.vols));
    else
        Y=squeeze(vols(volIndex(1), volIndex(2), volIndex(3),:));
    end
    YL=arrayfun(@(x) num2str(x), Y, 'UniformOutput', false);
    guiData=guidata(hObject);
    set(guiData.YLstBx,'String',YL);
end

function X1 =getX1(hObject)
global SPM;
guiData=guidata(hObject);
desMat=SPM.xX.X;
id1=get(guiData.X1ChoiceLstBx,'Value');
X1=desMat(:,id1);

function X2 =getX2(hObject)
global SPM;
guiData=guidata(hObject);
desMat=SPM.xX.X;
id2=get(guiData.X2ChoiceLstBx,'Value');
X2=desMat(:,id2);


function setXYScanListValue(hObject, value)
guiData=guidata(hObject);
set(guiData.X1LstBx,'Value',value);
set(guiData.X2LstBx,'Value',value);
set(guiData.YLstBx,'Value',value);
set(guiData.ScansLstBx,'Value',value);

function plotData(hObject)
global volIndex;
global SPM;
global Y;
%set(guiData.PlottingOptionsLstBx,'String',{'Y' 'X1' 'X2' 'X1||Y' 'X2||Y' 'X1, Y' 'X2, Y' 'X1, X2' 'Y Hist' 'Y Hist_Group' 'X1 Hist' 'X2 Hist'});

guiData = guidata(hObject);
choice=get(guiData.PlottingOptionsLstBx, 'Value');
options=get(guiData.PlottingOptionsLstBx, 'String');
option=options{choice};
% options=get(guiData.PlottingOptionsLstBx, 'String');
% option=options(choice);
%figure();
if(~isfield(SPM, 'figure'))
    SPM.figure=figure();
end
if(get(guiData.NewFigureRB, 'Value'))
    SPM.figure=figure();
end

figure(SPM.figure);

if(strcmp(option,'X1, Y'))
    X1=getX1(hObject);
    scatter(X1, Y);
elseif(strcmp(option,'X2, Y'))
    X2=getX2(hObject);
    scatter(X2, Y);
elseif(strcmp(option,'X1, X2'))
    X1=getX1(hObject);
    X2=getX2(hObject);
    scatter(X1, X2);
elseif(strcmp(option,'Y Hist'))
    Hist(Y);
elseif(strcmp(option,'Y Hist_Group'))
    X1=getX1(hObject);
    Y=Y(X1>0);
    Hist(Y);
elseif(strcmp(option,'X1 Hist'))
    X1=getX1(hObject);
    Hist(X1);
elseif(strcmp(option,'X2 Hist'))
    X2=getX2(hObject);
    Hist(X2);
elseif(strcmp(option,'Y'))
    plot(Y);
elseif(strcmp(option,'X1'))
    X1=getX2(hObject);
    plot(X1);
elseif(strcmp(option,'X2'))
    X2=getX2(hObject);
    plot(X2);
elseif(strcmp(option,'X1||Y'))
    X1=getX1(hObject);
    x=(1:length(Y))';
    plotyy(x,X1,x,Y);
elseif(strcmp(option,'X2||Y'))
    X2=getX2(hObject);
    x=(1:length(Y))';
    plotyy(x,X2,x,Y);
end
title(option,'fontsize',18);


function VoxelIndexTF_Callback(hObject, eventdata, handles)
% hObject    handle to VoxelIndexTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VoxelIndexTF as text
%        str2double(get(hObject,'String')) returns contents of VoxelIndexTF as a double
global SPM;
guiData=guidata(hObject);
volIndex=CommonMethods.str2nums_decimal(get(guiData.VoxelIndexTF,'String'));
updateSPM(hObject,SPM, volIndex);

% --- Executes during object creation, after setting all properties.
function VoxelIndexTF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VoxelIndexTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in NewFigureRB.
function NewFigureRB_Callback(hObject, eventdata, handles)
% hObject    handle to NewFigureRB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of NewFigureRB


% --- Executes on button press in ImportMatFileBT.
function ImportMatFileBT_Callback(hObject, eventdata, handles)
% hObject    handle to ImportMatFileBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    file=spm_select([0 Inf],'Mat','Select an spm mat file to view');
    updateSPM(hObject,file);



function CoordinatesTF_Callback(hObject, eventdata, handles)
% hObject    handle to CoordinatesTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CoordinatesTF as text
%        str2double(get(hObject,'String')) returns contents of CoordinatesTF as a double
guiData=guidata(hObject);
coor=CommonMethods.str2nums_decimal(get(guiData.CoordinatesTF,'String'));
updateCoordinates_mni(hObject, coor)


% --- Executes during object creation, after setting all properties.
function CoordinatesTF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CoordinatesTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function updateCoordinates_mni(hObject,coorin)
global SPM;
global coor;
coor=coorin;
if(~isempty(SPM))
    if(isfield(SPM,'mat'))
        volIndex=CommonMethods.mni2ind(coor,SPM.mat);
        updateSPM(hObject,SPM,volIndex);
    end
end
