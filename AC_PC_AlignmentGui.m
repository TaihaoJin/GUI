function varargout = AC_PC_AlignmentGui(varargin)
% AC_PC_ALIGNMENTGUI MATLAB code for AC_PC_AlignmentGui.fig
%      AC_PC_ALIGNMENTGUI, by itself, creates a new AC_PC_ALIGNMENTGUI or raises the existing
%      singleton*.
%
%      H = AC_PC_ALIGNMENTGUI returns the handle to a new AC_PC_ALIGNMENTGUI or the handle to
%      the existing singleton*.
%
%      AC_PC_ALIGNMENTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AC_PC_ALIGNMENTGUI.M with the given input arguments.
%
%      AC_PC_ALIGNMENTGUI('Property','Value',...) creates a new AC_PC_ALIGNMENTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AC_PC_AlignmentGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AC_PC_AlignmentGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AC_PC_AlignmentGui

% Last Modified by GUIDE v2.5 04-Oct-2018 12:25:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AC_PC_AlignmentGui_OpeningFcn, ...
                   'gui_OutputFcn',  @AC_PC_AlignmentGui_OutputFcn, ...
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


% --- Executes just before AC_PC_AlignmentGui is made visible.
function AC_PC_AlignmentGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AC_PC_AlignmentGui (see VARARGIN)

% Choose default command line output for AC_PC_AlignmentGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AC_PC_AlignmentGui wait for user response (see UIRESUME)
% uiwait(handles.AC_PC_AlignmentGui);


% --- Outputs from this function are returned to the command line.
function varargout = AC_PC_AlignmentGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
guiData=guidata(hObject);
varargout{1} = handles.output;
set(guiData.ACPCOperationsLstBx,'String',{'Reset View' 'Zoom 40mm' 'Reset Origin' 'Align To Axis2' 'Align To 2-3 Plane' 'Save Aligned Image'});
set(guiData.ZoomLstBx,'String',{'full volume' '160 mm' '80 mm' '40 mm' '20 mm' '10 mm'});

% --- Executes on selection change in ImageListCB.
function ImageListCB_Callback(hObject, eventdata, handles)
% hObject    handle to ImageListCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ImageListCB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ImageListCB
guiData=guidata(hObject);
guiData.obj.refreshGui();

% --- Executes during object creation, after setting all properties.
function ImageListCB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ImageListCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in NextBT.
function NextBT_Callback(hObject, eventdata, handles)
% hObject    handle to NextBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guiData=guidata(hObject);
guiData.obj.runCommand();

% --- Executes on button press in DoneBT.
function DoneBT_Callback(hObject, eventdata, handles)
% hObject    handle to DoneBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guiData=guidata(hObject);
guiData.obj.imageAligned();
%guiData.obj.updateCommand('Done');

% --- Executes on selection change in ACPCOperationsLstBx.
function ACPCOperationsLstBx_Callback(hObject, eventdata, handles)
% hObject    handle to ACPCOperationsLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ACPCOperationsLstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ACPCOperationsLstBx

guiData=guidata(hObject);
set(guiData.ImagesToAlignTxt, 'String', ['Images to align (' num2str(nnz(guiData.obj.toAlign)) '/' num2str(length(guiData.obj.imgs)) ')']); 
drawnow();
options=get(guiData.ACPCOperationsLstBx,'String');
operation=options{get(guiData.ACPCOperationsLstBx,'Value')};
updateSPM_Ext(hObject)
guiData=guidata(hObject);
guiDataExt=guidata(guiData.hSpmExt);
mask_volInds=guiData.obj.mask_volInds;
if(exist('handles','var'))
    guiData.obj.updateCommand(operation);
end
switch (operation)
    case 'Reset View'
        coor=CommonMethods.ind2coor_mat(mask_volInds, guiDataExt.spmStruct.vols{1}.mat);%% the mask volInds has converted to that of the target image
        guiDataExt.updateCoordinates_mni(guiData.hSpmExt,coor(1,:)');
        CommonMethods.spm_setZoom(5);
    case 'Zoom 40mm'
        CommonMethods.spm_setZoom(5);
    case 'Reset Origin'
        [st,R4]=CommonMethods.resetOrigin_spm(guiDataExt.spmStruct);
        guiData.obj=guiData.obj.updateMatrix(R4);
        guiData.obj.cur_V.mat=st.vols{1}.mat;
        guiData.obj=guiData.obj.storeVolInds(st,1);%AC
        guiDataExt.spmStruct=st;
        guiDataExt.updatedMat=true;
        guidata(guiData.hSpmExt,guiDataExt);
        guiData.obj=guiData.obj.updateCoorLists();
        spm_orthviews('update_st', st);
        coor=CommonMethods.ind2coor_mat(mask_volInds, guiDataExt.spmStruct.vols{1}.mat);
        guiDataExt.updateCoordinates_mni(guiData.hSpmExt,coor(2,:)');
        CommonMethods.spm_setZoom(5);
    case 'Align To Axis2'
        guiData.obj=guiData.obj.storeVolInds(guiDataExt.spmStruct,2);%PC
        [st,R4]=CommonMethods.toYAxis_spm(guiDataExt.spmStruct);
        guiData.obj=guiData.obj.updateMatrix(R4);
        guiData.obj.cur_V.mat=st.vols{1}.mat;
        guiDataExt.spmStruct=st;
        guiDataExt.updatedMat=true;
        guidata(guiData.hSpmExt,guiDataExt);
        spm_orthviews('update_st', st);
        %    spm_orthviews('Reposition',[0;0;0],'fromSPMExt');
        coor=CommonMethods.ind2coor_mat(guiData.obj.volInds{1}, guiDataExt.spmStruct.vols{1}.mat);%showing AC
        coor(3)=coor(3)+60;
        coor=guiData.obj.getOptimalCoor(coor);
        guiDataExt.updateCoordinates_mni(guiData.hSpmExt,coor');
        CommonMethods.spm_setZoom(7);
    case 'Align To 2-3 Plane'
        guiData.obj=guiData.obj.storeVolInds(guiDataExt.spmStruct,3);%AC
        [st,R4]=CommonMethods.toYZPlane_spm(guiDataExt.spmStruct);
        guiData.obj=guiData.obj.updateMatrix(R4);
        guiData.obj.cur_V.mat=st.vols{1}.mat;
        guiDataExt.spmStruct=st;
        guiDataExt.updatedMat=true;
        guidata(guiData.hSpmExt,guiDataExt);
        spm_orthviews('update_st', st);
        %saving the AC_PC aligned image
        guiData.obj.saveAlignedImg(st);
        coor=CommonMethods.ind2coor_mat(guiData.obj.volInds{1}, guiDataExt.spmStruct.vols{1}.mat);%showing AC
        guiDataExt.updateCoordinates_mni(guiData.hSpmExt,coor');
        CommonMethods.spm_setZoom(7);
    case 'Save Aligned Image'
        guiData.obj.saveAlignedImg(guiDataExt.spmStruct);
end
guidata(hObject, guiData);
guiData.obj.updateCoorLists();
% --- Executes during object creation, after setting all properties.
function ACPCOperationsLstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ACPCOperationsLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ZoomLstBx.
function ZoomLstBx_Callback(hObject, eventdata, handles)
% hObject    handle to ZoomLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ZoomLstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ZoomLstBx
guiData=guidata(hObject);
%set(guiData.ZoomLstBx,'String',{'full volume' '160 mm' '80 mm' '40 mm' '20 mm' '10 mm'});
ind=get(guiData.ZoomLstBx, 'Value');
options=[8 7 6 5 4 3];
CommonMethods.spm_setZoom(options(ind));

% --- Executes during object creation, after setting all properties.
function ZoomLstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ZoomLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function updateSPM_Ext(hObject)
h=getSPM_Ext();
guiData=guidata(hObject);
guiData.hSpmExt=h;
guiData.guiData.guiDataExt=guidata(h);
guidata(hObject, guiData);

function h=getSPM_Ext()
h=FM.getFigure('spm_extension');
% hs=get(0, 'children');
% for i=1:length(hs)
%     name=hs(i).Name;
%     if(length(name)<6)
%         continue;
%     end
%     if(strcmp(name(1:13), 'spm_extension'))
%         h=hs(i);
%         break
%     end
% end


% --- Executes on selection change in AlignedImagesLstCB.
function AlignedImagesLstCB_Callback(hObject, eventdata, handles)
% hObject    handle to AlignedImagesLstCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns AlignedImagesLstCB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AlignedImagesLstCB
guiData=guidata(hObject);
Imgs=get(guiData.AlignedImagesLstCB,'String');
img=Imgs{get(guiData.AlignedImagesLstCB,'Value')};
%delete(fullfile(fileparts(img),'AC_PC_volInds.txt'));
guiData.obj=guiData.obj.realignImage();
guidata(hObject,guiData);

% --- Executes during object creation, after setting all properties.
function AlignedImagesLstCB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AlignedImagesLstCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ACPCCoorsCB.
function ACPCCoorsCB_Callback(hObject, eventdata, handles)
% hObject    handle to ACPCCoorsCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ACPCCoorsCB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ACPCCoorsCB
strs=get(handles.ACPCCoorsCB,'String');
ind=get(handles.ACPCCoorsCB,'Value');
updatePosition(hObject, strs{ind});
if(ind<3)
    CommonMethods.spm_setZoom(5);
end

function updatePosition(hObject, str)
strs=strsplit(strtrim(str),' ');
coors=[str2num(strs{1}) str2num(strs{2}) str2num(strs{3})];
guiData=guidata(hObject);
guiDataExt=guidata(guiData.hSpmExt);
guiDataExt.updateCoordinates_mni(guiData.hSpmExt,coors');
guiData.guiDataExt=guidata(guiData.hSpmExt);
guidata(hObject, guiData);    

% --- Executes during object creation, after setting all properties.
function ACPCCoorsCB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ACPCCoorsCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in InitialACPCCoorsCB.
function InitialACPCCoorsCB_Callback(hObject, eventdata, handles)
% hObject    handle to InitialACPCCoorsCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns InitialACPCCoorsCB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from InitialACPCCoorsCB
strs=get(handles.InitialACPCCoorsCB,'String');
ind=get(handles.InitialACPCCoorsCB,'Value');
updatePosition(hObject, strs{ind});


% --- Executes during object creation, after setting all properties.
function InitialACPCCoorsCB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InitialACPCCoorsCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ImportImageListBT.
function ImportImageListBT_Callback(hObject, eventdata, handles)
% hObject    handle to ImportImageListBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global st_aligner;
initdir=pwd;
[name,path]=uigetfile(fullfile(initdir,'*.tsv; *.csv; *.txt'),'select a spm stat summary file');
fname=fullfile(path,name);
lines=CommonMethods.getTextLines(fname);
len=length(lines);
inds=find(cellfun(@(x)~isempty(strfind(x,'Other Images')),lines));
if(isempty(inds))
    st_aligner.sourceImgs=lines;
    st_aligner.otherImgs=cell(1,len);
else
    ind=inds(1);
    st_aligner.sourceImgs=lines(1:ind);
    st_aligner.otherImgs=cell(1,ind);
    num=(len-ind)/ind;
    for i=1:ind
        iI=ind+(i-1)*num+1;
        iF=iI+num-1;
        st_aligner.otherImgs{i}=lines(iI:iF);
    end
end
AC_PC_aligner(st_aligner.sourceImgs,path);
% --- Executes on button press in PreprocessingBT.
function PreprocessingBT_Callback(hObject, eventdata, handles)
% hObject    handle to PreprocessingBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global st_aligner;
imgs=st_aligner.sourceImgs;
ImgsToSegment=imgs; %for the purpose of bentchmarking
% %% Initiliaze SPM
len=length(imgs);
imgs2=cell(1,len);
for i=1:len
    img=imgs{i};
    [folder,name,ext]=fileparts(img);
    imgs2{i}=fullfile(folder,['iy_' name ext]);
end
ImgsToSegment=ImgsToSegment(cellfun(@(x)exist(x,'file'),imgs2)==0);
% logF=fullfile(obj.info.groupdir,'AC_PC_pullback.log');
% flst=CommonMethods.getTextLines(logF);
% ImgsToSegment=cellfun(@(x)fullfile(x,'f.nii'),flst,'UniformOutput',false)';

numJobs=min(12,length(ImgsToSegment));
num=length(ImgsToSegment);
if(num>0)
    delta=num/numJobs;
    IStarts=zeros(1,numJobs);
    for i=1:numJobs
        IStarts(i)=round((i-1)*delta)+1;
    end
    
    jobs=cell(1,numJobs);
    for order=1:numJobs
        load(fullfile(CommonEnvMethods.getScriptPath(),'Jobtemplates','Segmentation_batch_spm12.mat'));
        tissue=matlabbatch{1}.spm.spatial.preproc.tissue;
        for j=1:length(tissue)
            matlabbatch{1}.spm.spatial.preproc.tissue(j).tpm=strrep(matlabbatch{1}.spm.spatial.preproc.tissue(j).tpm,'Matlab Projects_20116a', 'MatlabProjects_2017b');
        end
        jobs{order}=matlabbatch;
    end
    
    parfor order=1:numJobs
        %for order=1:numJobs
        iI=IStarts(order);
        if(order==numJobs)
            iF=num;
        else
            iF=IStarts(order+1)-1;
        end
        
        % List of open inputs
        matlabbatch=jobs{order};
        matlabbatch{1}.spm.spatial.preproc.channel.vols=ImgsToSegment(iI:iF)';
        cprintf('blue', '%s\n', ['Starting NewSegmentation: ' datestr(clock) ' (' num2str(length(matlabbatch{1}.spm.spatial.preproc.channel.vols)) 'images)']);
        spm('defaults', 'FMRI');
        %spm_jobman('run', jobfile, inputs{1});
        %spm_jobman('run', jobs, inputs{:});
        try
            spm_jobman('run', matlabbatch);
        catch err
            cprintf('red','%s\n', ['The job ' num2str(order) ' failed']);
            continue;
        end
        cprintf('blue', '%s\n', ['Completed NewSegmentation: ' datestr(clock) ' (' num2str(length(matlabbatch{1}.spm.spatial.preproc.channel.vols)) 'images)']);
    end
end

CommonMethods.makeAC_PC_imgs(imgs);
    
% --- Executes on button press in ReviewRB.
function ReviewRB_Callback(hObject, eventdata, handles)
% hObject    handle to ReviewRB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ReviewRB


% --- Executes on button press in TakeNoteBT.
function TakeNoteBT_Callback(hObject, eventdata, handles)
% hObject    handle to TakeNoteBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guiData=guidata(hObject);
msg=get(guiData.NoteTF,'String');
h=getSPM_Ext();
guiData1=guidata(h);
coor=guiData1.currentCoor;
guiData.obj.takeNote(msg,coor);

function NoteTF_Callback(hObject, eventdata, handles)
% hObject    handle to NoteTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NoteTF as text
%        str2double(get(hObject,'String')) returns contents of NoteTF as a double


% --- Executes during object creation, after setting all properties.
function NoteTF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NoteTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
