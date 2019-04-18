function varargout = quickTabular_img(varargin)
% QUICKTABULAR_IMG MATLAB code for quickTabular_img.fig
%      QUICKTABULAR_IMG, by itself, creates a new QUICKTABULAR_IMG or raises the existing
%      singleton*.
%
%      H = QUICKTABULAR_IMG returns the handle to a new QUICKTABULAR_IMG or the handle to
%      the existing singleton*.
%
%      QUICKTABULAR_IMG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in QUICKTABULAR_IMG.M with the given input arguments.
%
%      QUICKTABULAR_IMG('Property','Value',...) creates a new QUICKTABULAR_IMG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before quickTabular_img_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to quickTabular_img_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%/home/tjin/MyProjects/MatlabProjects_2017b/MRI/GUIs
% Edit the above text to modify the response to help quickTabular_img

% Last Modified by GUIDE v2.5 13-Jun-2018 13:46:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @quickTabular_img_OpeningFcn, ...
                   'gui_OutputFcn',  @quickTabular_img_OutputFcn, ...
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


% --- Executes just before quickTabular_img is made visible.
function quickTabular_img_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to quickTabular_img (see VARARGIN)

% Choose default command line output for quickTabular_img
handles.output = hObject;
guiData=handles;
guiData.lines={};
guiData.table.header={'A' 'B' 'C' 'D' 'E' 'F'}
guiData.table.data=cell(6,6);
guiData.fname='';
guiData.dim=[1 1];
guiData.CoordinateColumn=1;
set(guiData.ImageListColumn, 'String', '1   ');
% Update handles structure
guidata(hObject, guiData);
updateGUI(hObject);
% UIWAIT makes quickTabular_img wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = quickTabular_img_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in loadTableBT.
function loadTableBT_Callback(hObject, eventdata, handles)
% hObject    handle to loadTableBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guiData=guidata(hObject);
%tabledir=fullfile(CommonEnvMethods.getMatlabProjectPath(), 'Literature Tables');
tabledir=pwd;
if(~exist(tabledir,'file'))
    tabledir=pwd;
end
[name, path]=uigetfile(fullfile(pwd,'*.txt;*.xls;*.xlsx;*.csv;*.tsv'),'select file');
fname=fullfile(path,name);
[~, ~, ext]=fileparts(fname);
tab=CommonMethods.tab;
switch ext
    case '.xlsx'
        [num,txt,raw]=xlsread(fname);
        guiData=guidata(hObject);
        guiData.table.data=raw;
        guiData.table.header=arrayfun(@(x) CommonMethods.getDefaultColumnNames(x), 1:size(raw,2), 'UniformOutput', false);
        guidata(hObject,guiData);        
    case '.csv'
        fid=fopen(fname);
        t=textscan(fid,'%s','Delimiter','\n');
        t=t{1};
        rows=length(t);
        tbl=cellfun(@(x)strsplit(x,','),t,'UniformOutput',false);
        lens=cellfun(@(x)length(x),tbl);
        cols=max(lens);
        data=cell(rows,cols);
        
        for r=1:rows
            tmp=tbl{r};
            len=length(tmp);
            for c=1:len
                data{r,c}=tmp{c};
            end
            for c=len+1:cols
                data{r,c}=' ';
            end
        end
%        obj=spmStatSummaryHandler();
        guiData.table.data=data;
        guiData.table.header=arrayfun(@(x) CommonMethods.getDefaultColumnNames(x), 1:cols, 'UniformOutput', false);
        guidata(hObject,guiData);    
    case '.tsv'
        fid=fopen(fname);
        t=textscan(fid,'%s','Delimiter','\n');
        t=t{1};
        rows=length(t);
        tbl=cellfun(@(x)strsplit(x,tab),t,'UniformOutput',false);
        lens=cellfun(@(x)length(x),tbl);
        cols=max(lens);
        data=cell(rows,cols);
        
        for r=1:rows
            tmp=tbl{r};
            len=length(tmp);
            for c=1:len
                data{r,c}=tmp{c};
            end
            for c=len+1:cols
                data{r,c}=' ';
            end
        end
%        obj=spmStatSummaryHandler();
        guiData.table.data=data;
        guiData.table.header=arrayfun(@(x) CommonMethods.getDefaultColumnNames(x), 1:cols, 'UniformOutput', false);
        guidata(hObject,guiData);    
end
updateGUI(hObject);
        
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
        hObject=getMainHObject(hObject);
        updateTable(hObject);
        
    function hObject=getMainHObject(hObject)
        while(~MainHObject(hObject))
            hObject=get(hObject,'parent');
        end
            
    function IS=MainHObject(hObject)
        IS=false;
        tmp=get(hObject);
        if(isfield(tmp,'Name'))
            IS=strcmp(tmp.Name, 'quickTabular_img');
        end
        
        function updateTable(hObject);
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
            fs=10;
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
            position=getpixelposition(guiData.tablePanel,true);
            hTable=uitable(parent,'Data',data,'Position', position,'Units','normalized');
            if(~isempty(header))
                set(hTable,'ColumnWidth',cellMaxLen,'columnName',header);
            end
            if(isempty(get(hTable,'CellSelectionCallback')))
                set(hTable,'CellSelectionCallback',@uitable_CellSelectionCallback);
            end
            
            guiData.table.hTable=hTable;
            guidata(hObject,guiData);

function uitable_CellSelectionCallback(hObject, eventdata, handles)
    guiData=guidata(hObject);
    guiData.selectedIndices=eventdata.Indices;
    guidata(hObject,guiData);

function ImageListColumn_Callback(hObject, eventdata, handles)
% hObject    handle to ImageListColumn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ImageListColumn as text
%        str2double(get(hObject,'String')) returns contents of ImageListColumn as a double
guiData=guidata(hObject);
guiData.CoordinateColumn=str2double(get(guiData.CoordinateColumnTF,'String'));
guidata(hObject, guiData);

% --- Executes during object creation, after setting all properties.
function ImageListColumn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ImageListColumn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in getAppendingImgBT.
function getAppendingImgBT_Callback(hObject, eventdata, handles)
% hObject    handle to getAppendingImgBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[name, path]=uigetfile(fullfile(pwd,'*.nii;*.img'),'select file');
fname=fullfile(path,name);
guiData=guidata(hObject);
strs=get(guiData.AppendingImgLst,'String');
%strs{end+1}=fname;
strs=fname;
set(guiData.AppendingImgLst,'Value',1);
set(guiData.AppendingImgLst,'String',strs);
guidata(hObject,guiData);

% --- Executes on selection change in AppendingImgLst.
function AppendingImgLst_Callback(hObject, eventdata, handles)
% hObject    handle to AppendingImgLst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns AppendingImgLst contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AppendingImgLst


% --- Executes during object creation, after setting all properties.
function AppendingImgLst_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AppendingImgLst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AppendImgageRB.
function AppendImgageRB_Callback(hObject, eventdata, handles)
% hObject    handle to AppendImgageRB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AppendImgageRB



function ReplaceImageNameTF_Callback(hObject, eventdata, handles)
% hObject    handle to ReplaceImageNameTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ReplaceImageNameTF as text
%        str2double(get(hObject,'String')) returns contents of ReplaceImageNameTF as a double


% --- Executes during object creation, after setting all properties.
function ReplaceImageNameTF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ReplaceImageNameTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DisplayBT.
function DisplayBT_Callback(hObject, eventdata, handles)
% hObject    handle to DisplayBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guiData=guidata(hObject);
indices=guiData.selectedIndices;
col=str2num(get(guiData.ImageListColumn,'String'));
rows=indices(:,1);
imgs=guiData.table.data(rows,col);
rImgNames=get(guiData.ReplaceImageNameTF,'String');
if(~isempty(rImgNames))
    strs=strsplit(rImgNames,';');
    rImgNames=cellfun(@(x)strtrim(x),strs,'UniformOutput',false);
    imgs0=imgs;
    imgs={};
    for i=1:length(imgs0)
        img=imgs0{i};
        img=cellfun(@(x)fullfile(fileparts(img),x),rImgNames,'UniformOutput',false);
        imgs=horzcat(imgs,img);
    end
end

if get(guiData.AppendImgageRB,'Value')
    imgsa=get(guiData.AppendingImgLst,'String');
    if(~iscell(imgsa))
        imgsa={imgsa};
    end
    imgsa=imgsa(get(guiData.AppendingImgLst,'Value'));
    imgs=horzcat(imgs,imgsa);
end
imgs=imgs(cellfun(@(x)exist(x,'file')==2,imgs));
CommonMethods.spm_check_registration(imgs);


% --- Executes on button press in ToDirBT.
function ToDirBT_Callback(hObject, eventdata, handles)
% hObject    handle to ToDirBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guiData=guidata(hObject);
indices=guiData.selectedIndices;
col=str2num(get(guiData.ImageListColumn,'String'));
rows=indices(:,1);
imgs=guiData.table.data(rows,col);
cd(fileparts(imgs{1}));