function varargout = tableInputer(varargin)
% TABLEINPUTER MATLAB code for tableInputer.fig
%      TABLEINPUTER, by itself, creates a new TABLEINPUTER or raises the existing
%      singleton*.
%
%      H = TABLEINPUTER returns the handle to a new TABLEINPUTER or the handle to
%      the existing singleton*.
%
%      TABLEINPUTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TABLEINPUTER.M with the given input arguments.
%
%      TABLEINPUTER('Property','Value',...) creates a new TABLEINPUTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tableInputer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tableInputer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tableInputer

% Last Modified by GUIDE v2.5 27-Sep-2016 09:04:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tableInputer_OpeningFcn, ...
                   'gui_OutputFcn',  @tableInputer_OutputFcn, ...
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


% --- Executes just before tableInputer is made visible.
function tableInputer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tableInputer (see VARARGIN)

% Choose default command line output for tableInputer
handles.output = hObject;
guiData=handles;
guiData.lines={};
guiData.fname='';
guiData.dim=[1 1];
% Update handles structure
guidata(hObject, guiData);


% UIWAIT makes tableInputer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = tableInputer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function inputLineTF_Callback(hObject, eventdata, handles)
% hObject    handle to inputLineTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputLineTF as text
%        str2double(get(hObject,'String')) returns contents of inputLineTF as a double


% --- Executes during object creation, after setting all properties.
function inputLineTF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputLineTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in inputRowBT.
function inputRowBT_Callback(hObject, eventdata, handles)
% hObject    handle to inputRowBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guiData=guidata(hObject);
guiData.lines{end+1}=get(guiData.inputLineTF,'String');
guidata(hObject,guiData);
updateGUI(hObject);
% --- Executes on button press in editRowBT.
function editRowBT_Callback(hObject, eventdata, handles)
% hObject    handle to editRowBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function rowNumberTF_Callback(hObject, eventdata, handles)
% hObject    handle to rowNumberTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rowNumberTF as text
%        str2double(get(hObject,'String')) returns contents of rowNumberTF as a double


% --- Executes during object creation, after setting all properties.
function rowNumberTF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rowNumberTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in updateRowBT.
function updateRowBT_Callback(hObject, eventdata, handles)
% hObject    handle to updateRowBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in saveTableBT.
function saveTableBT_Callback(hObject, eventdata, handles)
% hObject    handle to saveTableBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in saveAsBT.
function saveAsBT_Callback(hObject, eventdata, handles)
% hObject    handle to saveAsBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in loadTableBT.
function loadTableBT_Callback(hObject, eventdata, handles)
% hObject    handle to loadTableBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabledir=fullfile(CommonEnvMethods.getMatlabProjectPath(), 'Literature Tables');
if(~exist(tabledir,'file'))
    tabledir=pwd;
end
fname=uigetfile(fullfile(tabledir,'*.txt;*.xls;*.xlsx;*.csv'),'select file');
[name, path, ext]=fileparts(fname);
switch ext
    case '.xlsx'
        [num,txt,raw]=xlsread(fname);
        guiData=guidata(hObject);
        guiData.table=raw;
        guidata(hObject,guiData);        
    case '.csv'      
end
updataGUI(hObject);

function updated=updatefname(hObject)
guiData=guiDate(hObject);
fname=guiData.fname;
if(~isempty(fname))
    [initdir,~,~]=fileparts(fname);
else
    initdir=CommonEnvMethods.getMatlabProjectPath();
end

if(~isempty(initdir))
    cd(initdir);
end

dialogtitle='Select the file for the table';
%folder=uigetdir(initdir,dialogtitle);
%[name,path,filter]=uigetfile('*.csv',dialogtitle);
[name,path,filter]=uiputfile('*.csv',dialogtitle);
if(length(path)==1)
    if(path==0)
        specified=true;
    else
        specified=false;
    end
else
    specified=true;
end
if(specified)    
    guiData.fname=fullfile(path,name);
    updated=true;   
    set(guiData.fnameLB,'String',guiData.fname);
else
    updated=false;
end


function updateGUI(hObject)
updateTable(hObject);

function updateTable(hObject)
guiData=guidata(hObject);
if(isfield(guiData,'table'))
    data=guiData.table.data;
    header=guiData.table.header;
    cols=max(length(header), size(data,2));
    rows=size(data,1)+1;
    for c=length(header)+1:cols
        header{c}='';
    end
else
    lines=guiData.lines;
    rows=length(lines);
    dim=[];
    tmp={};
    
    for r=1:rows
        line=lines{r};
        tmp{end+1}=strsplit(line,'\t');
        dim(end+1)=length(tmp{end});
    end
    cols=max(dim);
    data=cell(rows-1,cols);
    header=cell(1,cols);
    for r=1:rows
        if(r==1)
            n=dim(r);
            for c=1:n
                header{c}=tmp{r}{c};
            end
            for c=n+1:cols
                header{c}='';
            end
        else
            n=dim(r);
            for c=1:n
                data{r-1,c}=tmp{r}{c};
            end
            for c=n+1:cols
                data{r-1,c}='';
            end
        end
    end    
end

lens=zeros(rows,cols);
fs=6.5;
rows=size(data,1)+1;
for r=1:rows
    for c=1:cols
        if(r==1)
            lens(r,c)=length(header{c});
        else
            lens(r,c)=length(data{r-1,c});
        end
    end
end
lens=lens*fs;
cellMaxLen=num2cell(max(lens));
% if(~isfield(guiData,'htable'))
%     guiData.htable=figure();
%     guidata(hObject,guiData);
% end
parent=get(guiData.tablePanel,'parent');
position=get(guiData.tablePanel,'position');
t=uitable(parent,'Data',data,'Position', position,'Units','characters');
if(~isempty(header))
    set(t,'ColumnWidth',cellMaxLen,'columnName',header);
end
if(isempty(get(t,'CellSelectionCallback')))
    set(t,'CellSelectionCallback',@uitable_CellSelectionCallback);   
end

function uitable_CellSelectionCallback(hObject, eventdata, handles)
 row = eventdata.Indices(1)
 col = eventdata.Indices(2)
 
 
function updateTable_csv(hObject)
guiData=guidata(hObject);
lines=guiData.lines;
rows=length(lines);
dim=[];
tmp={};
for r=1:rows
    line=lines{r};
    tmp{end+1}=strsplit(line{1},',');
    dim(end+1)=length(tmp{end});
end
cols=max(dim);
data=cell(rows-1,cols);
lens=zeros(rows,cols);
fs=6.5;
header=cell(1,cols);
for r=1:rows
    if(r==1)
        n=dim(r);
        for c=1:n
            header{c}=tmp{r}{c};
            lens(r,c)=length(tmp{r}{c})*fs;
        end
        for c=n+1:cols
            header{c}='';
        end
    else
        n=dim(r);
        for c=1:n
            data{r-1,c}=tmp{r}{c};
            lens(r,c)=length(tmp{r}{c})*fs;
        end
        for c=n+1:cols
            data{r-1,c}='';
        end
    end
end
cellMaxLen=num2cell(max(lens));
if(~isfield(guiData,'htable'))
    guiData.htable=figure();
    guidata(hObject,guiData);
end
parent=get(guiData.tablePanel,'parent');
position=get(guiData.tablePanel,'position');
t=uitable(parent,'Data',data,'Position', position,'Units','characters');
set(t,'ColumnWidth',cellMaxLen,'columnName',header);


% --- Executes on button press in pasteFromClipboardTB.
function pasteFromClipboardTB_Callback(hObject, eventdata, handles)
% hObject    handle to pasteFromClipboardTB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%table=ocrTable();
content=clipboard('paste');
dt=double(content);
content=content(dt<=127);
len=length(content);
p=1;
p0=1;
row=1;
lines={};
while(p<=len)
    c=content(p);
    if(double(c)==10)%endline
        if(p>p0)
            lines{row}=content(p0:p-1);
            p0=p+1;
            row=row+1;
        end
    end
    p=p+1;
end

guiData=guidata(hObject);
guiData.lines=lines;
guidata(hObject,guiData);
updateGUI(hObject);
% --- Executes on button press in pasteFromClipboardTB.
function ocrClipboardTB_Callback_o(hObject, eventdata, handles)
%this function is not working properly due to the poor performance of the
%matlab built in ocr function. %Taihao 20160926
% hObject    handle to pasteFromClipboardTB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%table=ocrTable();
content=clipboard('paste');
dt=double(content);
content=content(dt<=127);
len=length(content);
p=1;
p0=1;
row=1;
col=1;
lines={};
while(p<=len)
    c=content(p);
    if(double(c)==10)%endline
        if(p>p0)
            lines{row}=content(p0:p-1);
            p0=p+1;
            row=row+1;
        end
    end
    p=p+1;
end
rows=length(lines);

tablec={};

cols=0;
for r=1:rows
    line=lines{r};
    p0=1;
    p=1;
    len=length(line);
    cline={};
    
    for p=1:len
        c=line(p);
        if(double(c)==9)
            if(p>p0)
                cline{end+1}=line(p0:p-1);
            else
                cline{end+1}='';
            end
            p0=p+1;
        end
    end
    tablec{end+1}=cline;
    col=length(cline);
    if(col>cols)
        cols=col;
    end
end
table=cell(rows,cols);
for r=1:rows
    cline=tablec{r};
    for c=1:length(cline)
        table{r,c}=cline{c};
    end
end
guiData=guidata(hObject);
guiData.lines=table;
guidata(hObject,guiData);
updateGUI(hObject);
