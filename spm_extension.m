function varargout = spm_extension(varargin)
% SPM_EXTENSION M-file for spm_extension.fig
%      SPM_EXTENSION, by itself, creates a new SPM_EXTENSION or raises the existing
%      singleton*.
%
%      H = SPM_EXTENSION returns the handle to a new SPM_EXTENSION or the handle to
%      the existing singleton*.
%
%      SPM_EXTENSION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPM_EXTENSION.M with the given input arguments.
%
%      SPM_EXTENSION('Property','Value',...) creates a new SPM_EXTENSION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before spm_extension_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to spm_extension_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".c
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help spm_extension

% Last Modified by GUIDE v2.5 12-Jun-2018 21:05:59

% Begin initialization code - DO NOT EDIT
addpath(genpath('/home/JinT/matlab_projects/fMRI'));

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @spm_extension_OpeningFcn, ...
                   'gui_OutputFcn',  @spm_extension_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{cellfun(@(x)~isempty(x), varargin)});
%    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before spm_extension is made visible.
function spm_extension_OpeningFcn(hObject, eventdata, handles, varargin)
global guiData;
FM.addFigure(hObject,'spm_extension');
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to spm_extension (see VARARGIN)

% Choose default command line output for spm_extension
handles.output = hObject;
try
    X = load('TDdatabase');   
    if(~isfield(X,'mat'))
        avg152T1=fullfile(CommonEnvMethods.getMatlabProjectPath(),'External Software', 'spm12', 'canonical', 'avg152T1.nii');
        V=spm_vol(avg152T1);
        mat=V.mat;
        wholeMaskMNIAll=X.wholeMaskMNIAll;
        DB=X.DB;        
        fname=which('TDdatabase.mat');
        save(fname,'DB','wholeMaskMNIAll','mat');
        X = load('TDdatabase');
    end
    if(~isfield(X,'DB_sorted'))
        X=CommonMethods.refineDatabase(X);
        fname=which('TDdatabase.mat');
        DB=X.DB;
        mat=X.mat;
        wholeMaskMNIAll=X.wholeMaskMNIAll;
        wholeMaskMNIAll_eroded=X.wholeMaskMNIAll_eroded;
        DB_sorted=X.DB_sorted;
        DB_eroded=X.DB_eroded;
        DB_sorted_eroded=X.DB_sorted_eroded;
        save(fname,'DB','wholeMaskMNIAll','mat','wholeMaskMNIAll_eroded','DB_sorted','DB_eroded','DB_sorted_eroded');
        X = load('TDdatabase');
    end
    inds=cellfun(@(x) isempty(x),X.DB{5}.anatomy);
    X.DB{5}.anatomy(inds)={'undefined'};
    X.erode=false;
    X.dim=size(X.DB{1}.mnilist);
    X.selection=ones(X.dim);
    handles.X=X;
catch
    errordlg('I can''t find TDdatabase.mat','TDdatabase not found');
end
% Update handles structure
guiData.statusMap=StatusMap('spm_extension');
guiData=handles;
guiData.setImageList=@setImageList;
guiData.update=@updateGUI;
guiData.setOpenImages=@setOpenImages;
guiData.updatePars=@updatePars;
guiData.updateCoordinates_mni=@updateCoordinates_mni;
guiData.spmStruct=[];
guiData.imgFileNameExt=get(guiData.FileNameAssociatedObjectTF,'String');
guiData.updatedMat=false;
guiData.statusMap=StatusMap('spm_extension');
guiData.ACPCAlignSuffix='AC_PC_Aligned';
guiData.SelectedImages=[];
guiData.fidBrowingHist.fid=nan;
guiData.fidBrowingHist.imgs={};
guiData.importAssociatedObject=@importAssociatedObject;
guiData.clearAssociatedObjects=@clearAssociatedObjects;
set(guiData.ListingOptionListBx,'String',{'Opened images' 'Images to open' 'Import image list' 'grab imgs in the associated object' 'populate ImageToOpen List'});
set(guiData.ImageOperationLstBx,'String',{'Subtract Image', 'Apply Mask', 'Masking off Image', 'View SPM Results', 'Intersect Masks'});
set(guiData.ACPCOperationsLstBx,'String',{'Reset View' 'Zoom 40mm' 'Reset Origin' 'Align To Axis2' 'Align To 2-3 Plane' 'Save Aligned Image'});
%set(guiData.ImageHandlingLstBx,'String',{'Append Image' 'Close Image' 'Save Image' 'Intensity Profile' 'Voxel Histogram'});
set(guiData.ImageHandlingLstBx,'String',{'Append Image' 'Load Anatomic Mask' 'Close Image' 'Save Image' 'Intensity Profile' 'Voxel Histogram'});
set(guiData.ZoomLstBx,'String',{'full volume' '160 mm' '80 mm' '40 mm' '20 mm' '10 mm'});
            %for spm*: index should be between 1 and 8, for the zooming
            %option 'BBox(Y> ...' , 'BBox (nonzero)', '10mm', '20mm',
            %'40mm', '80mm', '160mm', and 'full volume', respectively. 

guiData.temporaryImageFiles={};
set(guiData.HemisphereLstBx,'String', horzcat({'any'}, X.DB_sorted{1}.anatomy),'max',length(X.DB_sorted{1}.anatomy));
set(guiData.LobeLstBx,'String', horzcat({'any'}, X.DB_sorted{2}.anatomy),'max',length(X.DB_sorted{2}.anatomy));
set(guiData.GyrusLstBx,'String', horzcat({'any'}, X.DB_sorted{3}.anatomy),'max',length(X.DB_sorted{3}.anatomy));
set(guiData.TissueLstBx,'String', horzcat({'any'}, X.DB_sorted{4}.anatomy),'max',length(X.DB_sorted{4}.anatomy));
set(guiData.CellLstBx,'String', horzcat({'any'}, X.DB_sorted{5}.anatomy),'max',length(X.DB_sorted{5}.anatomy));
guiData.X.AnotomicalListBoxes={guiData.HemisphereLstBx guiData.LobeLstBx guiData.GyrusLstBx guiData.TissueLstBx guiData.CellLstBx};
guiData.X.anatomicalSelection=false;
guiData.CoorSliders={guiData.XSlider guiData.YSlider guiData.ZSlider};
guiData.CoorSliderTexts={guiData.XCoorTxt guiData.YCoorTxt guiData.ZCoorTxt};
guiData.ClusterContour=spm_ClusterContour();

anatomicRegionNames=fieldnames(guiData.X.wholeMaskMNIAll);
set(guiData.AnatomicRegionLstBx, 'String', anatomicRegionNames);
guidata(hObject, guiData);
updateRecentAssociatedObjectsLstBx(hObject);


% UIWAIT makes spm_extension wait for user response (see UIRESUME)
% uiwait(handles.spm_extension);


% --- Outputs from this function are returned to the command line.
function varargout = spm_extension_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function ImageFileLB_Callback(hObject, eventdata, handles)
% hObject    handle to ImageFileLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ImageFileLB as text
%        str2double(get(hObject,'String')) returns contents of ImageFileLB as a double


% --- Executes during object creation, after setting all properties.
function ImageFileLB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ImageFileLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FileNameAssociatedObjectTF_Callback(hObject, eventdata, handles)
% hObject    handle to FileNameAssociatedObjectTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FileNameAssociatedObjectTF as text
%        str2double(get(hObject,'String')) returns contents of FileNameAssociatedObjectTF as a double
guiData=guidata(hObject);
guiData.imgFileNameExt=get(guiData.FileNameAssociatedObjectTF,'String');
if(isfield(guiData, 'associatedObjects'))
    ind=get(guiData.AssociatedObjectsLstBx,'value');
    aos=guiData.associatedObjects;
    ao=aos{ind};
    name=get(guiData.FileNameAssociatedObjectTF, 'String');
    ao.setName(name);
    names=get(guiData.AssociatedObjectsLstBx,'String');
    names{ind}=name;
    set(guiData.AssociatedObjectsLstBx,'String',names);
    
    if(isfield(guiData,'statusMap'))
        fname=ao.fname;
        srh=getRecentAssociatedObjectListHandler(hObject);
        srh.store(fname, name);
        guiData.statusMap.putSRHandler([],srh);
        updateRecentAssociatedObjectsLstBx(hObject);
    end
end

    function srh = getRecentAssociatedObjectListHandler(hObject)
        guiData=guidata(hObject);        
        key='AssociatedObjects';
        srh=guiData.statusMap.getSRHandler(key);  
        if(isempty(srh))
            srh=StringRankingHandler(key, 10, true);
        end
    
    
    function updateRecentAssociatedObjectsLstBx(hObject)
        guiData=guidata(hObject);
        srh=getRecentAssociatedObjectListHandler(hObject);
        [~,alias]=srh.getElements();
        set(guiData.RecentAssociatedObjectsLstBx, 'String', alias);
    
    
% --- Executes during object creation, after setting all properties.
function FileNameAssociatedObjectTF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FileNameAssociatedObjectTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function updateCoordinates_mni(hObject,coorin)
guiData=guidata(hObject);    
app=getInteractingApp(hObject);
if(strcmpi(app,'spm'))
    guiData.spmStruct.centre=coorin;
elseif(strcmpi(app,'xjView'))
    guiData.xjViewStruct.currentxyz=coorin;
%     guiData.xjViewStruct.handles.currentDisplayMNI{1}=guiData.xjViewStruct.handles.currentDisplayMNI{1}(1:10);
%     guiData.xjViewStruct.handles.currentDisplayDisplayIntensity{1}=guiData.xjViewStruct.handles.currentDisplayIntensity{1}(1:10);
%     guidata(guiData.xjViewStruct.xjViewFigureHandle,guiData.xjViewStruct.handles);
    %guiData(
end
spm_orthviews('reposition',coorin,'fromSPMExt')
%spm_orthviews('setcoords', coorin);
guidata(hObject, guiData);
updateGUI(hObject);
%set(guiData.ZoomLstBx,'String',{'full volume' '160 mm' '80 mm' '40 mm' '20 mm' '10 mm'});
ind=get(guiData.ZoomLstBx, 'Value');
options=[8 7 6 5 4 3];
CommonMethods.spm_setZoom(options(ind));

function output = updateGUI(hObject,varargin)
%This function updates the states of gui
CommonMethods.assignToBaseWrokspace('hObject_spmExtension', hObject);
guiData=guidata(hObject);    
output=guiData;
app=getInteractingApp(hObject);

%%% preparing the current image (V) to display using SPM or xjView
if(strcmpi(app,'spm'))
    if(length(varargin)>=1)
        spmStruct=varargin{1};
        guiData.spmStruct=spmStruct;
    else
        spmStruct=guiData.spmStruct;
    end
    %%%%%
    if(get(guiData.AdjustFramesRB,'Value'))
        spmStruct=adjustFrames(spmStruct);
        guiData.spmStruct=spmStruct;
    end
    
    [imgNames,fNames]=CommonMethods.getOpenImages(spmStruct)
    setOpenImages(hObject, imgNames, fNames);
    
    imgIndex=CommonMethods.getCurrentVolumeIndex(spmStruct);%the index of the file that is associated with the clicked section view.
    if(isempty(spmStruct))
        return;
    end
    if(~isfield(spmStruct, 'vols'))
        return;
    end
    
    Vs=spmStruct.vols;
    for i=1:length(Vs)
        Vt=Vs{i};
        if(isempty(Vt))
            continue;
        end
        if(~isfield(Vt,'vol'))
            Vt.vol=spm_read_vols(spm_vol(Vt.fname));
            Vt.MaxStr={'Local Maxima List not Built'};
            Vt.MinStr={'Local Minima List not Built'};
            spmStruct.vols{i}=Vt;
            guiData.spmStruct=spmStruct;
        end
    end
    Vs=spmStruct.vols;
    if(imgIndex>0)
        V=spmStruct.vols{imgIndex};
    else
        V=[];
    end
    
    if(~isempty(V))
        options=get(guiData.ListingOptionListBx, 'String');
        index1=get(guiData.ListingOptionListBx,'Value');
        option=options{index1};
        switch (option)
            case 'Images to open'
            case 'Opened images'
                set(guiData.ImageFilesLstB, 'Value', imgIndex);
        end
                
        guiData.updatedMat=false;
        coor=spmStruct.centre;
    end
elseif(strcmpi(app,'xjView'))
    
    if(length(varargin)>=1)
        xjViewStruct=varargin{1};
        guiData.xjViewStruct=xjViewStruct;
    else
        xjViewStruct=guiData.xjViewStruct;
    end

    guidata(hObject,guiData);
    imgIndex= get(guiData.ImageFilesLstB, 'Value');
    Vs=xjViewStruct.vols;
    spmStruct=xjViewStruct.st;
    
    for i=1:length(Vs)
        V=Vs{i};
        if(isempty(V))
            continue;
        end
        
        if(~isfield(V,'vol'))
            V.vol=spm_read_vols(spm_vol(V.fname));
            V.MaxStr={'Local Maxima List not Built'};
            V.MinStr={'Local Minima List not Built'};
            spmStruct.vols{i}=V;
            guiData.spmStruct=spmStruct;
        end
    end
    xjViewStruct.st=Vs;
    V=xjViewStruct.vols{imgIndex};  
    
    coor=xjViewStruct.currentxyz;
    if(isfield(V, 'clusterHandler'))
        stats=V.clusterHandler.stats;
        set(guiData.ClusterLstBx, 'String', stats.descriptions);
        cind=V.clusterHandler.getClusterIndx(coor);
        set(guiData.ClusterLstBx, 'Value', cind);
    end
end

%%%handling the current image (V) if selected
if(~isempty(V))        
    
    currentImg=V.fname;
           
    guiData.updatedMat=false;
      
    %% Find the local peak if the choice is selected
    if(get(guiData.FindPeakRB, 'Value'))
        inds=CommonMethods.mni2ind(coor,V.mat);  
        inds=CommonMethods.findPeak(V.vol, inds, 1);
        coor=CommonMethods.ind2mni_spmMat(V.mat, inds);
        spmStruct.centre=coor;
        guiData.spmStruct=spmStruct;
        spm_orthviews('update_st', spmStruct);
        spm_orthviews('redraw');
    end
    displayVoxelInfo(hObject,Vs,V,coor);
    %%% the following block is for a functionality no longer using 1/8/2018
    %recordBrowsingHist(hObject)    
    
    %%% displaying atlas information
    showAtlasInfo(hObject,coor);
    
    %%% plotting the associated object
    if(get(guiData.UpdateplotsRB, 'Value'))
        plotAssociatedObject(hObject,coor);
    end
    
    hObject=guiData.spm_extension;
    guidata(hObject,guiData);
    %%%
else
    currentImg=[];
end
guiData.currentCoor=coor;
guiData.currentImgFileName=currentImg;
updateAssociatedObjectListBox(hObject);
updateCoorSliders(hObject, coor);
drawClusterContours(hObject,coor);
output=guiData;
%%%% Endof function "updateGUI"


    function spmStruct=adjustFrames(spmStruct)
        if(~isfield(spmStruct,'vols_o'))
            vols=spmStruct.vols;
            spmStruct.vols_o=vols;
            info=COH1_DTI_AnalysisInfo();
            mask=info.mask_spmICV;
            fnames={};
            for i=1:length(vols)
                vol=vols{i};
                if(isempty(vol))
                    continue;
                end
                fnames{end+1}=vol.fname;
            end
            vlhs=cellfun(@(x)VolumeLandscapeHandler(x,mask),fnames,'UniformOutput',false);
            spmStruct.VolumeLandscapeHandlers=vlhs;
        end
        
        vols_o=spmStruct.vols_o;
        coor=spmStruct.centre';
        for i=1:length(vols_o)
            vol=vols_o{i};
            if(isempty(vol))
                continue;
            end
            vlh=spmStruct.VolumeLandscapeHandlers{i};
            dcoor=vlh.getCoorShift(coor);
            spmStruct.vols{i}.mat(1:3,4)=spmStruct.vols_o{i}.mat(1:3,4)-dcoor';
        end
               
        spm_orthviews('update_st', spmStruct);
        spm_orthviews('redraw');
        
    function plotAssociatedObject(hObject,coor)
        guiData=guidata(hObject);
        if(get(guiData.PlotSphereRB,'Value'))
            sphere=getCurrentShpere(hObject);
            coorst=CommonMethods.ind2coor_mat(sphere.curVIndexes, sphere.idim.mat);
            updatePlotter(hObject, coorst');
        else
            updatePlotter(hObject, coor');%The FourD_Vol_Handler takes 3xN coordinate matrix.
        end
        
    function displayVoxelInfo(hObject,Vs,V,coor)
        guiData=guidata(hObject);
        img=V.fname;
        if(isfield(guiData,'OpenedImageFiles'))
            [~,pos]=ismember(img,guiData.OpenedImageFiles);
            if(pos>=1)
                sdim=guiData.OpenedImageDims{pos(1)};
            else
                sdim='';
            end
        else
            sdim='';
        end
        set(guiData.ImageFileLB,'String', [V.fname ' ' sdim]);
        
        mmLB=sprintf('%6.2f %6.2f %6.2f', coor(1), coor(2), coor(3));
        inds=CommonMethods.mni2ind(coor,V.mat);          
        volIndexes=inds;
        indLB=[num2str(volIndexes(1)) ' ' num2str(volIndexes(2)) ' ' num2str(volIndexes(3))];
        if(any(inds<1)||any(inds>V.dim))
            val=nan;
        else
            val=V.vol(inds(1),inds(2), inds(3));
        end
        valLB=num2str(val);
        guiData.currentVolInds=inds;
        guiData.currentMat=V.mat;
        guidata(hObject,guiData);
        tab=sprintf('%s\t','');
        for i=1:length(Vs)
            Vt=Vs{i};
            if(isempty(Vt))
                continue;
            end
            inds=CommonMethods.mni2ind(coor,Vt.mat);
            if(any(inds<1)||any(inds>Vt.dim))
                val=nan;
            else
                val=Vt.vol(inds(1),inds(2), inds(3));
            end
            if(i==1)
                valsLB=sprintf('%5.2f', val);
                valsLB1=sprintf('%5.2f', val);
            else
                valsLB=[valsLB ', ' sprintf('%5.2f', val)];
                valsLB1=[valsLB1 tab sprintf('%5.2f', val)];
            end
        end
        
        set(guiData.Coor_mmTF,'String', mmLB);
        set(guiData.Coor_voxelTF,'String', indLB);
        set(guiData.VoxelValueTF,'String', valLB);
        set(guiData.VoxelValuesTF,'String', valsLB);
        
        if(get(guiData.LocalMaximaLstBx,'Value')>length(V.MaxStr))
            set(guiData.LocalMaximaLstBx,'Value', 1);
        end
        set(guiData.LocalMaximaLstBx,'String', V.MaxStr);
        
        if(get(guiData.LocalMinimaLstBx,'Value')>length(V.MinStr))
            set(guiData.LocalMinimaLstBx,'Value', 1);
        end
        set(guiData.LocalMinimaLstBx,'String', V.MinStr);
        
        
    function showAtlasInfo(hObject,coor)
        dim=size(coor);
        if(dim(2)<dim(1))
            coor=coor';
        end
        guiData=guidata(hObject);
        if(~isfield(guiData,'AtlasHander'))
            guiData.AtlasHandler=TDAtlasHandler();
            guidata(hObject,guiData);           
        end
%        [structures, atlasIndexes]=guiData.AtlasHandler.findStructures(coor);
        [onelinestructure, cellarraystructure] = cuixuFindStructure(coor, guiData.X.DB);
        name=cell(1,3);
        name{1}=[cellarraystructure{1} '_' cellarraystructure{2}];
        name{2}=[cellarraystructure{3} '_' cellarraystructure{4}];
        name{3}=[cellarraystructure{1} '_' cellarraystructure{5}];
        set(guiData.AtlasLstBx, 'String', name);
        
    function recordBrowsingHist(hObject)
        guiData=guidata(hObject);
        if(~isnan(guiData.fidBrowingHist.fid))
            imgst=getSelectedImages(hObject);
            doit=true;
            if(length(imgst)~=length(guiData.fidBrowingHist.imgs))
                doit=false;
            else
                doit=all(ismember(imgst,guiData.fidBrowingHist.imgs));
            end
            if(doit)
                line=[mmLB tab valsLB1 tab onelinestructure];
                fprintf(guiData.fidBrowingHist.fid,'%s\n',line);
            else
                set(guiData.SaveImageBrowsingHistoryRB,'Value', false);
                SaveImageBrowsingHistoryRB_Callback(hObject);
            end
        end
        
        
% --- Executes on button press in DisplayImageBT.
function DisplayImageBT_Callback(hObject, eventdata, handles)
% hObject    handle to DisplayImageBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guiData=guidata(hObject);
options=get(guiData.ListingOptionListBx, 'String');
index=get(guiData.ListingOptionListBx,'Value');
option=options{index};
app=getInteractingApp(hObject);

switch (option)
    case 'Images to open'
        if(isfield(guiData, 'ImagesToOpen'))
            if(strcmpi(app,'spm'))
                guiData=guidata(hObject);
                inds=get(guiData.ImageFilesLstB,'Value');
                imgs=guiData.ImagesToOpen(inds);
                imgs=cellfun(@(x) spm_vol(x),imgs,'UniformOutput',false);
                imgs=cell2mat(imgs);
                spm_check_registration(imgs);
            end
        end
end

% --- Executes on selection change in ImageFilesLstB.
function ImageFilesLstB_Callback(hObject, eventdata, handles)
% hObject    handle to ImageFilesLstB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ImageFilesLstB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ImageFilesLstB
guiData=guidata(hObject);
options=get(guiData.ListingOptionListBx, 'String');
index=get(guiData.ListingOptionListBx,'Value');
option=options{index};
app=getInteractingApp(hObject);

switch (option)
    case 'Images to open'
%         if(isfield(guiData, 'ImagesToOpen'))
%             if(strcmpi(app,'spm'))
%                 Imgs=guiData.ImagesToOpen;
%                 if(iscell(Imgs))
%                     if(~isempty(Imgs))
%                         index=get(guiData.ImageFilesLstB,'Value');
%                         set(guiData.SelectedImageIndexTF,'String', [num2str(index) '/' num2str(length(Imgs))]);
%                         img=Imgs{index};
%                         if(get(guiData.DispACPCAlignedImgRB,'Value'))
%                             img=CommonMethods.getSuffixedFilename(img, ['_' guiData.ACPCAlignSuffix]);
%                         end
%                         if(exist(img,'file'))
%                             spm_image('Init',img);
%                             guiData=guidata(hObject);
%                             CommonMethods.spm_setView(guiData.spmStruct, [0 0 0]);
%                             CommonMethods.spm_setZoom(7);
%                         end
%                     end
%                 end
%             end
%         end
    case 'Opened images'   
        set(handles.ImageFilesLstB, 'Max', length(get(handles.ImageFilesLstB,'String')));
        if(strcmpi(app,'spm'))
            ind = get(guiData.ImageFilesLstB, 'Value');
            [fnames, names]=getOpenedImages(hObject);
            snames=get(handles.SelectedImageLstBx,'String')';
            labels=arrayfun(@(x)[names{x} ';' fnames{x}], ind, 'UniformOutput',false);
            
            idx=~ismember(labels,snames);
            if(~isempty(idx))
                set(handles.SelectedImageLstBx,'String', horzcat(snames, labels(idx)));
            end
            CommonMethods.spm_setCurrentVolumeIndex(guiData.spmStruct, ind);
            if(length(ind)==1)
                updateGUI(hObject);
            end
        elseif(strcmpi(app,'xjView'))
            updateGUI(hObject);
        end
    case 'populate ImgToOpenList'
        imgs=COH1_CommonMethods.getVBMImages();
end


% --- Executes during object creation, after setting all properties.
function ImageFilesLstB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ImageFilesLstB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function setImageList(hObject,imgs)
guiData=guidata(hObject);
guiData.ImagesToOpen=imgs;
set(guiData.ImageFilesLstB,'Value',1);
set(guiData.ImageFilesLstB,'String',imgs);
guidata(hObject, guiData);

function setOpenImages(hObject,imgs,fnames)
guiData=guidata(hObject);
if(isfield(guiData,'OpenedImageFiles'))
    fnames0=guiData.OpenedImageFiles;
else
    fnames0={};
end

updated=false;

if(length(fnames)~=length(fnames0))
    updated=true;
elseif(any(arrayfun(@(x) ~strcmp(fnames{x}, fnames0{x}), 1:length(fnames0))))
    updated=true;
end

if (updated)
%    guiData.OpenedImages=imgs;
    if(~iscell(fnames))
        fnames={fnames};
    end
    guiData.OpenedImageFiles=fnames;
    guiData.OpenedImages= CommonMethods.getFileNames(fnames);
    guiData.OpenedImageDims={};
    for i=1:length(fnames)
        idim=CommonMethods.getImageDimension(fnames{i});
        guiData.OpenedImageDims{end+1}=['[' num2str(idim.lwd(1),1) ' ' num2str(idim.lwd(2),1) ' ' num2str(idim.lwd(3),1) ']'];
    end
    guidata(hObject, guiData);
    set(guiData.ImageFilesLstB,'String', imgs);
    if(get(guiData.ImageFilesLstB,'Value')>length(imgs))
        set(guiData.ImageFilesLstB,'Value',1);
    end
%    guiData.update(hObject);
end
guidata(hObject,guiData);
function SelectedImageIndexTF_Callback(hObject, eventdata, handles)
% hObject    handle to SelectedImageIndexTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SelectedImageIndexTF as text
%        str2double(get(hObject,'String')) returns contents of SelectedImageIndexTF as a double

%this function is written for adjusting "AC-PC" line using spm
guiData=guidata(hObject);
options=get(guiData.ListingOptionListBx, 'String');
index=get(guiData.ListingOptionListBx,'Value');
option=options{index};
app=getInteractingApp(hObject);

switch (option)
    case 'Images to open'
        if(isfield(guiData, 'ImagesToOpen'))
            if(strcmpi(app,'spm'))
                guiData=guidata(hObject);
                index=str2num(get(guiData.SelectedImageIndexTF,'String'));
                selectImageByIndex(hObject,index);
            end
        end
end


function selectImageByIndex(hObject,index)
guiData=guidata(hObject);
set(guiData.ImageFilesLstB,'Value',index);
imgs=get(guiData.ImageFilesLstB,'String');
img=imgs{index};
spm_image('Init',img);


% --- Executes during object creation, after setting all properties.
function SelectedImageIndexTF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SelectedImageIndexTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ListingOptionListBx.
function ListingOptionListBx_Callback(hObject, eventdata, handles)
% hObject    handle to ListingOptionListBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ListingOptionListBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ListingOptionListBx
persistent ImageFilesLstBValues;
persistent previousValue;
guiData=guidata(hObject);
value=get(guiData.ListingOptionListBx, 'Value');
if(isempty(ImageFilesLstBValues))
    ImageFilesLstBValues=ones(1,3);
end
if(isempty(previousValue))
    previousValue=-1;
end

if(value~=previousValue)
    options=get(guiData.ListingOptionListBx, 'String');
    option=options{value};
    switch (option)
        case 'Images to open'
            if(isfield(guiData,'ImagesToOpen'))
                Imgs=guiData.ImagesToOpen;
            else
                Imgs={};
            end
            if(iscell(Imgs))
%                if(~isempty(Imgs))
                    set(guiData.ImageFilesLstB,'Value',ImageFilesLstBValues(value));
                    set(guiData.ImageFilesLstB,'String',Imgs);
                    set(guiData.ImageFilesLstB,'max',length(Imgs));
%                end
            end
        case 'Opened images'
            if(isfield(guiData,'OpenedImages'))
                Imgs=guiData.OpenedImages;
                if(iscell(Imgs))
                    if(~isempty(Imgs))
                        set(guiData.ImageFilesLstB,'Value',ImageFilesLstBValues(value));
                        set(guiData.ImageFilesLstB,'String',Imgs);
                    end
                end
            end
        case 'Import image list'
            cohdir=fullfile(CommonEnvMethods.getCOHPath(), 'data');
            if(~exist(cohdir, 'file'))
                mkdir(cohdir);
            end
            [fname,folder,filterIndex]=uigetfile(fullfile(cohdir,'*.lst'),'select file');
            fname=fullfile(folder,fname);
            imgs=CommonMethods.getTextLines(fname);
            if(~isempty(imgs))
                guiData.ImagesToOpen=imgs;
                guidata(hObject,guiData);
                set(guiData.ListingOptionListBx, 'Value', 2);
                ListingOptionListBx_Callback(hObject, eventdata, handles);
            end
        case 'grab imgs in the associated object'
            inds=get(guiData.AssociatedObjectsLstBx,'Value');
            if(~isempty(inds))
                ind=inds(1);
                strs=get(guiData.AssociatedObjectsLstBx,'String');
                fname=strs{ind};
                [folder,name,ext]=fileparts(fname);
                imgs={};
                if(strcmpi(name,'SPM'))
                    X=load(fname);
                    imgs=X.SPM.xY.P;
                else
                    try
                        V=spm_vol(fname);
                        noVols=length(V);
                        imgs=arrayfun(@(x)[fname ',' num2str(x)],1:noVols,'UniformOUtput',false);
                    catch err
                    end
                end
                if(~isempty(imgs))
                    guiData.ImagesToOpen=imgs;
                    guidata(hObject,guiData);
                    set(guiData.ListingOptionListBx, 'Value', 2);
                    ListingOptionListBx_Callback(hObject, eventdata, handles);                
                end
            end
        case 'populate ImageToOpen List'
            Imgs=COH1_CommonMethods.getVBMImages();
            aligned=cellfun(@(x)strrep(x,'f.nii', 'f_AC_PC_Aligned.nii'), Imgs, 'UniformOutput', false);
            ne=cellfun(@(x)~exist(x,'file'),aligned);
            %            Imgs=Imgs(ne);
            guiData.ImagesToOpen=Imgs;
            guidata(hObject,guiData);
            set(guiData.ListingOptionListBx, 'Value', 2);
            ListingOptionListBx_Callback(hObject, eventdata, handles);
    end
else
    ImageFilesLstBValues(value)=get(guiData.ImageFilesLstB,'Value');
end
previousValue=value;

% --- Executes during object creation, after setting all properties.
function ListingOptionListBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ListingOptionListBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Coor_mmTF_Callback(hObject, eventdata, handles)
% hObject    handle to Coor_mmTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Coor_mmTF as text
%        str2double(get(hObject,'String')) returns contents of Coor_mmTF as a double
guiData=guidata(hObject);
str=get(guiData.Coor_mmTF,'String');
coor=CommonMethods.str2nums(str, ' ')';
%spm_orthviews('reposition', coor);
% if(isfield(guiData, 'spmStruct'))
%     guiData.spmStruct.centre=coor;
%     guidata(hObject, guiData);
%     spm_orthviews('update_st', guiData.spmStruct);
% end
updateCoordinates_mni(hObject,coor(1:3));

    function idx = getCurrentVoxelIndexes(hObject)
        guiData=guidata(hObject);
        str=get(guiData.Coor_voxelTF,'String');
        idx=CommonMethods.str2nums(str, ' ')';
        
        
% --- Executes during object creation, after setting all properties.
function Coor_mmTF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Coor_mmTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Coor_voxelTF_Callback(hObject, eventdata, handles)
% hObject    handle to Coor_voxelTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Coor_voxelTF as text
%        str2double(get(hObject,'String')) returns contents of Coor_voxelTF as a double
guiData=guidata(hObject);
options=get(guiData.ListingOptionListBx, 'String');
id=get(guiData.ListingOptionListBx, 'Value');
option=options{id};
if(strcmp(option, 'Opened images'))
    inds=CommonMethods.str2nums_decimal(get(guiData.Coor_voxelTF, 'String'));
    app=CommonMethods.getSourceApp();
    imgIndex=get(guiData.ImageFilesLstB,'Value');
    if(strcmpi(app, 'SPM'))
        spmStruct=guiData.spmStruct;
        mat=spmStruct.vols{imgIndex}.mat;
        dim=spmStruct.vols{imgIndex}.dim;
    elseif(strcmpi(app,'xjView'))
        xjViewStruct=guiData.xjViewStruct;
        mat=xjViewStruct.vols{imgIndex}.mat;
        dim=xjViewStruct.vols{imgIndex}.dim;
    end
    
    if(length(inds)==3)
        inds = CommonMethods.getValidMatrixIndexes(dim, inds)
        coor=mat*([inds 1])';
        %spm_orthviews('reposition', coor(1:3));
        updateCoordinates_mni(hObject,coor(1:3));
    end
end
% --- Executes during object creation, after setting all properties.
function Coor_voxelTF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Coor_voxelTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function VoxelValueTF_Callback(hObject, eventdata, handles)
% hObject    handle to VoxelValueTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VoxelValueTF as text
%        str2double(get(hObject,'String')) returns contents of VoxelValueTF as a double


% --- Executes during object creation, after setting all properties.
function VoxelValueTF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VoxelValueTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in LocalMaximaLstBx.
function LocalMaximaLstBx_Callback(hObject, eventdata, handles)
% hObject    handle to LocalMaximaLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LocalMaximaLstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LocalMaximaLstBx
guiData = guidata(hObject);
value=get(guiData.LocalMaximaLstBx, 'Value');

app=getInteractingApp(hObject);
if(strcmpi(app,'spm'))
    index=CommonMethods.getCurrentVolumeIndex(guiData.spmStruct);
    if(index<0) 
        set(guiData.LocalMaximaLstBx, 'Value', 1);
        set(guiData.LocalMaximaLstBx, 'String', {});
        return;
    end
    V=guiData.spmStruct.vols{index};
else
    imgIndex= get(guiData.ImageFilesLstB, 'Value');
    V=guiData.xjViewStruct.vols{imgIndex};
end
mat=V.mat;
if(~isfield(V,'MinPos'))
    set(guiData.LocalMaximaLstBx, 'Value', 1);
    set(guiData.LocalMaximaLstBx, 'String', {});
    return;
end
Inds=V.MaxPos(value,:);
Inds=[Inds [1]];
coor=mat*Inds';
%spm_orthviews('reposition',coor(1:3));
updateCoordinates_mni(hObject,coor(1:3));

% --- Executes during object creation, after setting all properties.
function LocalMaximaLstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LocalMaximaLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in LocalMinimaLstBx.
function LocalMinimaLstBx_Callback(hObject, eventdata, handles)
% hObject    handle to LocalMinimaLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LocalMinimaLstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LocalMinimaLstBx
guiData = guidata(hObject);
value=get(guiData.LocalMinimaLstBx, 'Value');
app=getInteractingApp(hObject);
if(strcmpi(app,'spm'))
    index=CommonMethods.getCurrentVolumeIndex(guiData.spmStruct);
    V=guiData.spmStruct.vols{index};
else
    imgIndex= get(guiData.ImageFilesLstB, 'Value');
    V=guiData.xjViewStruct.vols{imgIndex};
end
if(~isfield(V,'MinPos'))
    set(guiData.LocalMinimaLstBx, 'Value', 1);
    set(guiData.LocalMinimaLstBx, 'String', {});
    return;
end
mat=V.mat;
Inds=V.MinPos(value,:);
Inds=[Inds 1];
coor=mat*Inds';
%spm_orthviews('reposition',coor(1:3));
updateCoordinates_mni(hObject,coor(1:3));

% --- Executes during object creation, after setting all properties.
function LocalMinimaLstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LocalMinimaLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function buildLocalExtrema(hObject)
guiData=guidata(hObject);

app=getInteractingApp(hObject);

if(strcmpi(app,'spm'))
    index=CommonMethods.getCurrentVolumeIndex(guiData.spmStruct);
    V=guiData.spmStruct.vols{index};
else
    imgIndex= get(guiData.ImageFilesLstB, 'Value');
    V=guiData.xjViewStruct.vols{imgIndex};
end

if(~isfield(V,'vol'))
    V.vol=spm_read_vols(spm_vol(V.fname));
end
[path,name,ext]=fileparts(V.fname);

stmfile=fullfile(path,[name '_xtm' '.csv']);

    vol=V.vol;
    if(length(size(vol))>3)
        vol=V.vol(:,:,:,1);
    end
    [Maxima,MaxPos,Minima,MinPos]=CommonMethods.localExtrema_clusterCenters(vol);

if(~CommonMethods.ValidAuxiliaryFile(V.fname, stmfile)||get(guiData.RecomputeLocalExtremaRB,'Value'))
    cprintf('blue','building local extrema list ... ...');
    vol=V.vol;
    if(length(size(vol))>3)
        vol=V.vol(:,:,:,1);
    end
    
    [Maxima,MaxPos,Minima,MinPos]=CommonMethods.localExtrema_clusterCenters(vol);
    cprintf('blue','finished local extrema list\n');
    exportXTM(stmfile,Maxima, MaxPos, Minima, MinPos);
else
    [Maxima,MaxPos,Minima,MinPos]=importXTM(stmfile);
end

ln=length(Minima);
lx=length(Maxima);
V.Maxima=Maxima;
V.MaxPos=MaxPos;
V.Minima=Minima;
V.MinPos=MinPos;
V.MaxStr=cell(1,lx);
V.MinStr=cell(1,ln);
len=max(ln,lx);
for i=1:len
    if(i<=lx)
        x=sprintf('%5d: %4d %4d %4d    %12.4d', i, MaxPos(i,1), MaxPos(i,2), MaxPos(i,3), Maxima(i));
        V.MaxStr{i}=x;
    end
    if(i<=ln)
        n=sprintf('%5d: %4d %4d %4d    %12.4d', i, MinPos(i,1), MinPos(i,2), MinPos(i,3), Minima(i));
        V.MinStr{i}=n;
    end
end

if(strcmpi(app,'spm'))
    guiData.spmStruct.vols{index}=V;
    spm_orthviews('update_st', guiData.spmStruct);
    updateGUI(hObject, guiData.spmStruct);
else
    imgIndex= get(guiData.ImageFilesLstB, 'Value');
    guiData.xjViewStruct.vols{imgIndex}=V;
    spm_orthviews('update_st', guiData.xjViewStruct.st);
    updateGUI(hObject, guiData.xjViewStruct);
end
guidata(hObject, guiData);

function exportXTM(stmfile, Maxima, MaxPos, Minima, MinPos)
nl=length(Minima);
nx=length(Maxima);
len=max(nl,nx);
table=-1*ones(len,8);
columnNames={'MaxI' 'MaxJ' 'MaxK' 'MaxV' 'MinI' 'MinJ' 'MinK' 'MinV'};
rowNames={};
for i=1:len
    if(i<=nx)
        table(i,1:3)=MaxPos(i,1:3);
        table(i,4)=Maxima(i);
    end
    if(i<=nl)
        table(i,5:7)=MinPos(i,1:3);
        table(i,8)=Minima(i);
    end
end
CommonMethods.exportTable_CSV(stmfile,columnNames,rowNames,table)

function [Maxima, MaxPos, Minima, MinPos] = importXTM(stmfile)
data=importdata(stmfile);
data=data.data;
ni=data(:,1);
ni=data(ni>0);
len=length(ni);
MaxPos=data(1:len,1:3);
Maxima=data(1:len,4);
ni=data(:,5);
ni=data(ni>0);
len=length(ni);
MinPos=data(1:len,5:7);
Minima=data(1:len,8);


% --- Executes on button press in BuildLocalExtremaBT.
function BuildLocalExtremaBT_Callback(hObject, eventdata, handles)
% hObject    handle to BuildLocalExtremaBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
buildLocalExtrema(hObject);
function [onelinestructure, cellarraystructure] = cuixuFindStructure(mni, DB)
% function [onelinestructure, cellarraystructure] = cuixuFindStructure(mni, DB)
%
% this function converts MNI coordinate to a description of brain structure
% in aal
%
%   mni: the coordinates (MNI) of some points, in mm.  It is Nx3 matrix
%   where each row is the coordinate for one point
%   LDB: the database.  This variable is available if you load
%   TDdatabase.mat
%
%   onelinestructure: description of the position, one line for each point
%   cellarraystructure: description of the position, a cell array for each point
%
%   Example:
%   cuixuFindStructure([72 -34 -2; 50 22 0], DB)
%
% Xu Cui
% 2007-11-20
%

N = size(mni, 1);

% round the coordinates
mni = round(mni/2) * 2;

T = [...
     2     0     0   -92
     0     2     0  -128
     0     0     2   -74
     0     0     0     1];

index = mni2cor(mni, T);
dim=size(DB{1}.mnilist);

cellarraystructure = cell(N, length(DB));
onelinestructure = cell(N, 1);

for ii=1:N
    for jj=1:length(DB)
        cur_index=index(ii,:);
        cur_index(cur_index>dim)=1;
        cur_index(cur_index<0)=1;%to keep the cur_index within the range
        graylevel = DB{jj}.mnilist(cur_index(ii, 1), cur_index(ii, 2),cur_index(ii, 3));
        if graylevel == 0
            thelabel = 'undefined';
        else
            if jj==length(DB); tmp = ' (aal)'; else tmp = ''; end
            thelabel = [DB{jj}.anatomy{graylevel} tmp];
        end
        cellarraystructure{ii, jj} = thelabel;
        onelinestructure{ii} = [ onelinestructure{ii} ' // ' thelabel ];
    end
end

function coordinate = mni2cor(mni, T)
% function coordinate = mni2cor(mni, T)
% convert mni coordinate to matrix coordinate
%
% mni: a Nx3 matrix of mni coordinate
% T: (optional) transform matrix
% coordinate is the returned coordinate in matrix
%
% caution: if T is not specified, we use:
% T = ...
%     [-4     0     0    84;...
%      0     4     0  -116;...
%      0     0     4   -56;...
%      0     0     0     1];
%
% xu cui
% 2004-8-18
%

if isempty(mni)
    coordinate = [];
    return;
end

if nargin == 1
	T = ...
        [-4     0     0    84;...
         0     4     0  -116;...
         0     0     4   -56;...
         0     0     0     1];
end

coordinate = [mni(:,1) mni(:,2) mni(:,3) ones(size(mni,1),1)]*(inv(T))';
coordinate(:,4) = [];
coordinate = round(coordinate);
return;
function [onelinestructure, cellarraystructure] = cuixuFindTDstructure(pos)
% function [onelinestructure, cellarraystructure] = cuixuFindTDstructure(pos, DB, TALMNI)
%
% this function converts Talairach Daemon coordinate or MNI coordinate to a description of
% brain structure.
%
%   pos: the coordinate (MNI or Talairach coordinate, defined by TALMNI) of the position in the brain, in mm
%   DB: the database structure (see below for detailed explanation). If you don't input this argument, there
%   should be a file called 'TDdatabase.mat' in the current directory
%   TALMNI: 1 if pos is talairach coordinate, 0 if pos is MNI coordinate. 1
%   by default.
%
%   onelinestructure: a one-line description of the returned brain
%   structure
%   cellarraystructure: a cell array of size 5, each cell contains a string
%   describing the structure of the brain in a certain level.
%
%   Example:
%       [onelinestructure, cellarraystructure] = cuixuFindTDstructure([-24 24 48], DB, 1)
%       [onelinestructure, cellarraystructure] = cuixuFindTDstructure([-24 24 48])
%       then
%       onelinestructure = // Left Cerebrum // Frontal Lobe (L) // Middle Frontal Gyrus (L) // Gray Matter (L) // Brodmann area 8 (L)
%       cellarraystructure = 'Left Cerebrum'    'Frontal Lobe (L)'    [1x24 char]    'Gray Matter (L)'    'Brodmann area 8 (L)'
%
% Xu Cui
% 2004-6-28
%

%----------------------------------------------------------------------------------
% DB strcture
%----------------------------------------------------------------------------------
%-------------------------------
% Grid specification parameters:
%-------------------------------
% minX              - min X (mm)
% maxX              - max X (mm)
% voxX              - voxel size (mm) in X direction
% minY              - min Y (mm)
% maxY              - max Y (mm)
% voxY              - voxel size (mm) in Y direction
% minZ              - min Z (mm)
% maxZ              - max Z (mm)
% voxZ              - voxel size (mm) in Z direction
% nVoxX             - number of voxels in X direction
% nVoxY             - number of voxels in Y direction
% nVoxZ             - number of voxels in Z direction
%-------------------------------
% Classification parameters:
%-------------------------------
% numClass          - number of classification types
% cNames            - cNames{i}             - cell array of class names for i-th CT
% numClassSize      - numClassSize(i)       - number of classes for i-th CT
% indUnidentified   - indUnidentified(i)    - index of "indUnidentified" class for i-th CT
% volClass          - volClass{i}(j)        - number of voxels in class j for i-th CT
%
% data              - N x numClass matrix of referencies; let
%                       x y z coordinates in mm (on the grid) and
%                                      which (x y z) belongs, i.e.
%                                      cNames{i}{data(ind, i)} name of class for i-th CT
%----------------------------------------------------------------------------------

%                       nx = (x-minX)/voxX
%                       ny = (y-minY)/voxY
%                       nz = (z-minZ)/voxZ
%                       ind = nz*nVoxX*nVoxY + ny*nVoxX + nx + 1
%                       data(ind, i) - index of the class for i-th CT in cNames{i} to

%load('TDdatabase.mat');
%Modified by Taihao on 2/3/2015 to avoid possible confusion to other users.
%It was part of showsrs3
persistent wholeMaskMNIAll;
persistent DB;

if(isempty(DB))
    a=load('TDdatabase.mat');
    wholeMaskMNIAll=a.wholeMaskMNIAll;
    DB=a.DB;
end

if(size(pos,2)==4)
    pos=pos(1:3);
end
if(size(pos,1)>size(pos,2))
   pos=pos';
end

TALMNI = 0;

pos(:,1) = DB.voxX*round(pos(:,1)/DB.voxX);
pos(:,2) = DB.voxY*round(pos(:,2)/DB.voxY);
pos(:,3) = DB.voxZ*round(pos(:,3)/DB.voxZ);

min = [];
vox = [];
for(i=1:size(pos,1))
    min = [min; DB.minX DB.minY DB.minZ];
    vox = [vox; DB.voxX DB.voxY DB.voxZ];
end
n_pos = (pos - min)./vox;

nx = n_pos(:,1);
ny = n_pos(:,2);
nz = n_pos(:,3);
index = nz*DB.nVoxX*DB.nVoxY + ny*DB.nVoxX + nx + 1;
indMax = size(DB.data, 1);

onelinestructuretmp = [];
onelinestructure = [];
for(j=1:size(pos,1))
    onelinestructuretmp = [];
    for(i=1:DB.numClass)

        if (index(j) <= 0 | index(j) > indMax)
            ind(j) = DB.indUnidentified(i);
        else
            ind(j) = DB.data(index(j), i);
        end

        cellarraystructure{j,i} = DB.cNames{i}{ind(j)};
        onelinestructuretmp = [onelinestructuretmp ' // ' cellarraystructure{j,i}];
    end
    onelinestructure{j} = onelinestructuretmp;
end

return


% --- Executes on selection change in AtlasLstBx.
function AtlasLstBx_Callback(hObject, eventdata, handles)
% hObject    handle to AtlasLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns AtlasLstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AtlasLstBx


% --- Executes during object creation, after setting all properties.
function AtlasLstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AtlasLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in FindPeakRB.
function FindPeakRB_Callback(hObject, eventdata, handles)
% hObject    handle to FindPeakRB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FindPeakRB


% --- Executes on button press in spmMatBT.
function spmMatBT_Callback(hObject, eventdata, handles)
% hObject    handle to spmMatBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
persistent spmViewer;

if(~CommonMethods.isFigureHandle(spmViewer))
    spmViewer=[];
end
if(isempty(spmViewer))
    spmViewer=spmMatViewer;
end

guiData=guidata(hObject);
st=guiData.spmStruct;
index=CommonMethods.getCurrentVolumeIndex(st)
vol=st.vols{index};
coor=st.centre;
ind=CommonMethods.mni2ind_spm(st, coor, index);
if(~isfield(vol,'SPM'))
    path=fileparts(vol.fname);
    matfile=fullfile(path,'SPM.mat');
    if(exist(matfile,'file'))
        a=load(matfile);
        SPM=a.SPM;
        SPM.filepath=path;
    else
        SPM=[];
    end
else
    SPM=vol.SPM;
end
if(~isempty(SPM))
    guiDatat=guidata(spmViewer);
    vol.SPM = guiDatat.updateSPM(spmViewer,SPM,ind);
    st.vols{index}=vol;
    guiData.spmStruct=st;
    guidata(hObject, guiData);
    spm_orthviews('update_st', st);
end


% --- Executes on selection change in AssociatedObjectsLstBx.
function AssociatedObjectsLstBx_Callback(hObject, eventdata, handles)
% hObject    handle to AssociatedObjectsLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns AssociatedObjectsLstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AssociatedObjectsLstBx
guiData=guidata(hObject);

if(isfield(guiData, 'associatedObjects'))
   ind=get(guiData.AssociatedObjectsLstBx, 'value');
   aoj=guiData.associatedObjects{ind};
   set(guiData.FileNameAssociatedObjectTF, 'string', aoj.fname);
end

% --- Executes during object creation, after setting all properties.
function AssociatedObjectsLstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AssociatedObjectsLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ClearAssociatedObjectBT.
function ClearAssociatedObjectBT_Callback(hObject, eventdata, handles)
% hObject    handle to ClearAssociatedObjectBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clearAssociatedObjects(hObject);

    function clearAssociatedObjects(hObject, exception)
        if(~exist('exception','var'))
            exception={};
        end
        
guiData=guidata(hObject);
if(isfield(guiData, 'associatedObjects'))
    names=cellfun(@(x) x.name, guiData.associatedObjects, 'UniformOutput', false);
    idx=ismember(names,exception);
    guiData.associatedObjects=guiData.associatedObjects(idx);
    guidata(hObject,guiData);
end
updateAssociatedObjectListBox(hObject);




    function updateAssociatedObjectListBox(hObject)
        guiData=guidata(hObject);
        names={};
        if(isfield(guiData, 'associatedObjects'))
            if(~isempty(guiData.associatedObjects))
                names=cellfun(@(x) x.name, guiData.associatedObjects, 'UniformOutput', false);
            end
        end
        set(guiData.AssociatedObjectsLstBx, 'String', names);
    
        
% --- Executes on button press in ImportAssociatedObjectBT.
function ImportAssociatedObjectBT_Callback(hObject, eventdata, handles)
% hObject    handle to ImportAssociatedObjectBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fname=spm_select([0 1],{'Mat', 'nii'},'Select an spm mat file or a 4D image file');
if(~isempty(fname))
    if(exist(fname,'file'))
        importAssociatedObject(hObject, fname);
    end
end

    function importAssociatedObject(hObject, fname, alias)
guiData=guidata(hObject);
if(isfield(guiData, 'associatedObjects'))
    associatedObjects=guiData.associatedObjects;
else
    associatedObjects={};
    set(guiData.AssociatedObjectsLstBx, 'String',{});
end

if(~exist('alias','var'))
    alias=fname;
end

set(guiData.FileNameAssociatedObjectTF, 'String', fname);
if(isfield(guiData, 'hPlotter'))
    hPlotter=guiData.hPlotter';
else
    hPlotter=[];
end

ID=-1;
for i=1:length(associatedObjects)
    fnamet=associatedObjects{i}.fname;
    if(strcmp(fname,fnamet))
        ID=i;
    end
end

if(ID>0)
    set(guiData.AssociatedObjectsLstBx, 'Value', ID);
else
    
    obj = FourD_Vol_Handler(fname, hPlotter);
    obj.name=alias;
    if(~strcmpi(obj.type, 'invalid'))
        %It is a new valid associated object
        
        srh=getRecentAssociatedObjectListHandler(hObject);
        srh.store(fname, alias);
        guiData.statusMap.putSRHandler([], srh);
        
        associatedObjects{end+1}=obj;
        set(guiData.AssociatedObjectsLstBx, 'Value', length(associatedObjects));
        guiData.associatedObjects=associatedObjects;
        guiData.hPlotter=obj.hPlotter;
        guidata(hObject,guiData);
    end
end
updateRecentAssociatedObjectsLstBx(hObject);
updateAssociatedObjectListBox(hObject);
size=length(get(guiData.AssociatedObjectsLstBx,'String'));
set(guiData.AssociatedObjectsLstBx,'Max',size);

function updatePlotter(hObject, mni)
guiData=guidata(hObject);
if(get(guiData.ClusterRB,'Value'))
    imgIndex=get(guiData.ImageFilesLstB, 'Value');
    V=guiData.xjViewStruct.vols{imgIndex};
    if(isfield(V,'clusterHandler'))
        handler=V.clusterHandler;
        [mnic, center, morphDist]=handler.getClusterMNIs(mni);
        if(~isempty(mnic))
            mni=mnic;
        end
    end
end
if(isfield(guiData, 'associatedObjects'))
    objs=guiData.associatedObjects;
    if(~isempty(objs))
        objs=objs(get(guiData.AssociatedObjectsLstBx, 'Value'));
        if(exist('mni', 'var'))
            obj0=objs{1};
            [data, colNames, rowNames]=obj0.getData(mni);
            
            for i=2:length(objs)
                obj=objs{i};
                [datat, colNamest, ~]=obj.getData(mni);
                data=[data datat];
                colNames=horzcat(colNames, colNamest);
            end
            obj0.plotData(data, colNames, rowNames);
        else
            objs{1}.updatePlotter();
        end
    end
end

function app = getInteractingApp(hObject)
%this function returns the label of the app that hObject is interacting
%with
app=[];
guiData=guidata(hObject);
if(isfield(guiData,'interactingApp'))
    app=guiData.interactingApp;
else
    if(~isempty(CommonMethods.getFigureByName('xjView')))
        app='xjView';
    elseif(~isempty(CommonMethods.getFigureByName('spm')))
        app='spm';
    end
    if(~isempty(app))
        guiData.interactingApp=app;
    end
end

function calling = callingSPM_orthviews(hObject, calling)
%this function set the status of hObject to indicate whether it has just
%called spm_orthviews.
guiData=guidata(hObject);
if(exist('calling','var'))
    guiData.callingSPM_orthview=calling;
    guidata(hObject,guiData);
else
    if(~isfield(guiData,'callingSPM_orthview'))
        calling=false;
    else
        calling=guiData.callingSPM_orthviews;
    end
end


% --- Executes on button press in StoreVoxelsBT.
function StoreVoxelsBT_Callback(hObject, eventdata, handles)
% hObject    handle to StoreVoxelsBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guiData=guidata(hObject);
if(isfield(guiData, 'associatedObjects'))
    for i=1:length(guiData.associatedObjects)
        guiData.associatedObjects{i}.storeCoordinates();
    end
    guidata(hObject, guiData);
    updatePlotter(hObject);
end

coorStrs=get(guiData.StoredCoordinatesLstBx,'String');
coorStrs{end+1}=get(guiData.Coor_mmTF,'String');
set(guiData.StoredCoordinatesLstBx,'String', coorStrs);
set(guiData.StoredCoordinatesLstBx,'Value', 1);

% --- Executes on button press in ClearVoxelsBT.
function ClearVoxelsBT_Callback(hObject, eventdata, handles)
% hObject    handle to ClearVoxelsBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guiData=guidata(hObject);
if(isfield(guiData, 'associatedObjects'))
    for i=1:length(guiData.associatedObjects)
        guiData.associatedObjects{i}.clearStoredCoordinates();
    end
    guidata(hObject, guiData);
    updatePlotter(hObject);
end
CommonMethods.removedSelection_LstBx(guiData.StoredCoordinatesLstBx);

    function updatePars(hObject, varargin)        
    %do nothing right now.
    
% --- Executes on button press in ClusterRB.
function ClusterRB_Callback(hObject, eventdata, handles)
% hObject    handle to ClusterRB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ClusterRB


% --- Executes on selection change in ClusterLstBx.
function ClusterLstBx_Callback(hObject, eventdata, handles)
% hObject    handle to ClusterLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ClusterLstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ClusterLstBx
guiData=guidata(hObject);    
set(guiData.ListingOptionListBx,'String',{'Opened images' 'Images to open'});
app=getInteractingApp(hObject);

if(strcmpi(app,'xjView'))
    imgIndex= get(guiData.ImageFilesLstB, 'Value');
    V=guiData.xjViewStruct.vols{imgIndex};    
    if(isfield(V, 'clusterHandler'))
        ind=get(guiData.ClusterLstBx, 'Value');
        stats=V.clusterHandler.stats;
        center=stats.centers(:,ind);
        mnis=stats.mnis{ind};
%         guiData.xjViewStruct.currentDisplayMNI=mat2cell(mnis);
        set(guiData.ClusterRB, 'Value', true);
        updateCoordinates_mni(hObject, center);
        guidata(hObject, guiData);
    end
end

% --- Executes during object creation, after setting all properties.
function ClusterLstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ClusterLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse press over figure background.
function spm_extension_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to spm_extension (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guiData=guidata(hObject);
if(~isfield(guiData,'restoredGUI'))
    restoreGUI(hObject);
end

    function restoreGUI(hObject)
        guiData=guidata(hObject);
        statusMap=StatusMap('spm_extension');
        guiData.statusMap=statusMap;
        guiData.restoredGUI=true;
        guidata(hObject, guiData);
        

% --- Executes on selection change in RecentAssociatedObjectsLstBx.
function RecentAssociatedObjectsLstBx_Callback(hObject, eventdata, handles)
% hObject    handle to RecentAssociatedObjectsLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns RecentAssociatedObjectsLstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from RecentAssociatedObjectsLstBx
guiData=guidata(hObject);
ind=get(guiData.RecentAssociatedObjectsLstBx,'Value');
strs=get(guiData.RecentAssociatedObjectsLstBx,'String');
alias=strs{ind};
srh=getRecentAssociatedObjectListHandler(hObject);
el=srh.getElement_alias(alias);
if strcmp(get(handles.spm_extension,'SelectionType'),'open')
    importAssociatedObject(hObject, el, alias);
else
    set(guiData.FileNameAssociatedObjectTF,'String',el);
end

% --- Executes during object creation, after setting all properties.
function RecentAssociatedObjectsLstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RecentAssociatedObjectsLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close spm_extension.
function spm_extension_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to spm_extension (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
saveGUI(hObject);
delete(hObject);
    function saveGUI(hObject)        
        guiData=guidata(hObject);
        if(isfield(guiData,'statusMap'))
            guiData.statusMap.save();
        end
        deletetemporaryFiles(hObject);
        
        


% --- Executes on button press in VoxelHistogamBT.
        function displayVoxelHistogam(hObject)
            % hObject    handle to VoxelHistogamBT (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            guiData=guidata(hObject);
            app=getInteractingApp(hObject);
            
            if(strcmpi(app,'spm'))
                spmStruct=guiData.spmStruct;
                setOpenImages(hObject, CommonMethods.getOpenImages(spmStruct));
                
                imgIndex=CommonMethods.getCurrentVolumeIndex(spmStruct);%the index of the file that is associated with the clicked section view.
                V=spmStruct.vols{imgIndex};
                if(~isempty(V))
                    
                    options=get(guiData.ListingOptionListBx, 'String');
                    index1=get(guiData.ListingOptionListBx,'Value');
                    option=options{index1};
                    switch (option)
                        case 'Images to open'
                        case 'Opened images'
                            set(guiData.ImageFilesLstB, 'Value', imgIndex);
                    end
                    
                    if(~isfield(V,'vol'))
                        V.vol=spm_read_vols(spm_vol(V.fname));
                        V.MaxStr={'Local Maxima List not Built'};
                        V.MinStr={'Local Minima List not Built'};
                        spmStruct.vols{imgIndex}=V;
                        guiData.spmStruct=spmStruct;
                    end
                    
                    guiData.updatedMat=false;
                    coor=spmStruct.centre;
                end
            elseif(strcmpi(app,'xjView'))
                
                xjViewStruct=guiData.xjViewStruct;
                
                guidata(hObject,guiData);
                imgIndex= get(guiData.ImageFilesLstB, 'Value');
                V=xjViewStruct.vols{imgIndex};
                coor=xjViewStruct.currentxyz;
                if(isfield(V, 'clusterHandler'))
                    stats=V.clusterHandler.stats;
                    set(guiData.ClusterLstBx, 'String', stats.descriptions);
                    cind=V.clusterHandler.getClusterIndx(coor);
                    set(guiData.ClusterLstBx, 'Value', cind);
                end
            end
            
            vol=V.vol;
            if(V.dt(1)<=8)%interger voxel value
                idx=find(vol~=0);
            else
                idx=find(~isnan(vol));
            end
            y=vol(idx);
            figure();
            hist(y);
            stitle=CommonMethods.getFileName(V.fname);
            stitle=strrep(stitle,'_', '\_');
            title(stitle);
            set(gca, 'fontsize', 18);
            set(get(gca,'title'), 'fontsize', 24);
          
            


% --- Executes on button press in RecomputeLocalExtremaRB.
function RecomputeLocalExtremaRB_Callback(hObject, eventdata, handles)
% hObject    handle to RecomputeLocalExtremaRB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RecomputeLocalExtremaRB

function [imgs, names]=getOpenedImages(hObject)
    imgs={};
    names={};
    guiData=guidata(hObject);
    app=getInteractingApp(hObject);
    
    if(strcmpi(app,'spm'))
        spmStruct=guiData.spmStruct;
        vols=spmStruct.vols;
    elseif(strcmpi(app,'xjView'))
        xjViewStruct=guiData.xjViewStruct;
        vols=xjViewStruct.vols;
    end
    
    for i=1:length(vols)
        vol=vols{i};
        if(~isempty(vol))
            imgs{end+1}=vol.fname;
            [~, name, ~]=fileparts(vol.fname);
            names{end+1}=[name];
        end
    end
        
function addImage(hObject, img)
    if(~exist('img','var'))
        [img, sts] = spm_select(1,'image','Select image');
    end
    imgs=getOpenedImages(hObject);
    imgs{end+1}=img;
    imgs=cellfun(@(x) spm_vol(x),imgs,'UniformOutput',false);
    imgs=cell2mat(imgs);
    spm_check_registration(imgs);
    addpath('/home/JinT/matlab_projects/fMRI/Scripts/Modified Scripts/spm');

% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx=get(handles.ImageFilesLstB, 'Value');
if(length(idx)~=2) return;end;

imgs=getOpenedImages(hObject);
imgs=imgs(idx);
V=spm_vol(imgs{1});
vols1=spm_read_vols(spm_vol(imgs{1}));
vols2=CommonMethods.getVoxelValues(imgs{1}, imgs{2});
vols2=vols2{1,1};
vold=vols1-vols2;
[path,name,ext]=fileparts(V.fname);
V.fname=fullfile(path,['temp' ext]);
spm_write_vol(V,vold);
addImage(hObject, V.fname);
delete(V.fname);

    function imgs = getSelectedImages(hObject)
        guiData=guidata(hObject);
        [oimgs, onames]=getOpenedImages(hObject);
        snamest=get(guiData.SelectedImageLstBx,'String');
        
        len=length(snamest);
        imgs=cell(1,len);
        for i=1:len
            tmp=snamest{i};
            tmp1=strsplit(tmp,';');
            imgs{i}=tmp1{2};
        end
        
% --- Executes on selection change in ImageOperationLstBx.
function ImageOperationLstBx_Callback(hObject, eventdata, handles)
% hObject    handle to ImageOperationLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ImageOperationLstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ImageOperationLstBx
options=get(handles.ImageOperationLstBx,'String');
operation=options{get(handles.ImageOperationLstBx,'Value')};

if(strcmp(operation, 'View SPM Results'))
    spm_results_ui();
end

imgs=getSelectedImages(hObject);
if(length(imgs)~=2) return;end;
V=spm_vol(imgs{1});
[path,name1,ext]=fileparts(V.fname);
[~,name2,~]=fileparts(imgs{2});
vols1=spm_read_vols(V);
vols2=CommonMethods.getVoxelValues(imgs{1}, imgs{2});
vols2=vols2{1,1};
fname='temp';
switch (operation)
    case 'Subtract Image'
        volsn=vols1-vols2;
        fname=[name1 '_subtract_' name2];
        V.dt(1)=16;
    case 'Apply Mask'
        if(V.dt<16)
            volsn=zeros(V.dim);
        else
            volsn=nan(V.dim);
        end
        vols2=CommonMethods.getVoxelValues(imgs{1}, imgs{2},0);%imgs{2} is a mask
        vols2=vols2{1,1};
        m=vols2>0.5;
        volsn(m)=vols1(m);
        fname=[name1 '_maskOn_' name2];
    case 'Masking off Image'
        if(V.dt<16)
            volsm=zeros(V.dim);
        else
            volsm=nan(V.dim);
        end
        volsn=vols1;
        m=vols2>=0.5;
        volsn(m)=volsm(m);
        fname=[name1 '_maskOff_' name2];
    case 'View SPM Results'
        spm_results_ui();
    case 'Intersect Masks'
        volsn=(vols1>0.5).*(vols2>0.5);
        fname=[name1 '_Intersect_' name2];
        V.dt(1)=2;
end

V.fname=fullfile(CommonEnvMethods.getTempImageDir(),[fname ext]);
spm_write_vol(V,volsn);
%addImage(hObject, V.fname);
appendImage(hObject, V.fname);
addTotemporaryFileList(hObject,V.fname);
%updateImage(hObject);

    function addTotemporaryFileList(hObject,fname)
        guiData=guidata(hObject);
        guiData.temporaryImageFiles{end+1}=fname;
        guidata(hObject,guiData);
        
    function deletetemporaryFiles(hObject)
        guiData=guidata(hObject);
        fnames=guiData.temporaryImageFiles;
        cellfun(@(x) deleteImage(hObject,x), fnames);        

    function deleteImage(hObject,fname)
        closeImage(fname,hObject);
        delete(fname);

    function removeFromtemporaryFileList(hObject,fname)
        if(~iscell(fname))
            if(~ischar(fname))
                return;
            end
            fname={fname};
        end
        guiData=guidata(hObject);
        guiData.temporaryImageFiles=CommonMethods.removeStringEles(guiData.temporaryImageFiles, fname);
        guidata(hObject,guiData);
        
% --- Executes during object creation, after setting all properties.
function ImageOperationLstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ImageOperationLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SelectedImageLstBx.
function SelectedImageLstBx_Callback(hObject, eventdata, handles)
% hObject    handle to SelectedImageLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SelectedImageLstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SelectedImageLstBx
idx=get(handles.SelectedImageLstBx,'Value');
strs=get(handles.SelectedImageLstBx,'String');
strs=CommonMethods.getStringCellarrayComparison(strs, strs(idx));
set(handles.SelectedImageLstBx,'Value', 1);
set(handles.SelectedImageLstBx,'String', strs{1});

% --- Executes during object creation, after setting all properties.
function SelectedImageLstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SelectedImageLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ACPCOperationsLstBx.
function ACPCOperationsLstBx_Callback(hObject, eventdata, handles)
% hObject    handle to ACPCOperationsLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ACPCOperationsLstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ACPCOperationsLstBx
%'Reset View' 'Zoom 40mm' 'Reset Origin' 'Align To Axis2' 'Align To 2-3 Plane' 'Save Aligned Image'
options=get(handles.ACPCOperationsLstBx,'String');
operation=options{get(handles.ACPCOperationsLstBx,'Value')};

switch (operation)
    case 'Reset View'
        app=CommonMethods.getSourceApp();
        if(strcmpi(app,'SPM'))
%             guiData=guidata(hObject);
%             CommonMethods.spm_setView(guiData.spmStruct, [0 0 0]');
%             CommonMethods.spm_setZoom(7);
            updateCoordinates_mni(hObject,[0 0 0]');
        end
    case 'Zoom 40mm'
        app=CommonMethods.getSourceApp();
        if(strcmpi(app,'SPM'))
            CommonMethods.spm_setZoom(5);
        end
    case 'Reset Origin'
        app=CommonMethods.getSourceApp();
        if(strcmpi(app,'SPM'))
            guiData=guidata(hObject);
            st=CommonMethods.resetOrigin_spm(guiData.spmStruct);
            guiData.spmStruct=st;
            guiData.updatedMat=true;
            guidata(hObject,guiData);
            spm_orthviews('update_st', st);
            CommonMethods.spm_setView(st,[0 -23 0]);
            CommonMethods.spm_setZoom(5);
            %    spm_orthviews('Reposition',[0;0;0],'fromSPMExt');
        end
    case 'Align To Axis2'
        app=CommonMethods.getSourceApp();
        if(strcmpi(app,'SPM'))
            guiData=guidata(hObject);
            st=CommonMethods.toYAxis_spm(guiData.spmStruct);
            guiData.spmStruct=st;
            guiData.updatedMat=true;
            guidata(hObject,guiData);
            spm_orthviews('update_st', st);
            %    spm_orthviews('Reposition',[0;0;0],'fromSPMExt');
            CommonMethods.spm_setView(st,[0 20 0]);
            CommonMethods.spm_setZoom(7);
        end
    case 'Align To 2-3 Plane'
        app=CommonMethods.getSourceApp();
        if(strcmpi(app,'SPM'))
            guiData=guidata(hObject);
            st=CommonMethods.toYZPlane_spm(guiData.spmStruct);
            guiData.spmStruct=st;
            guiData.updatedMat=true;
            guidata(hObject,guiData);
            spm_orthviews('update_st', st);
            spm_orthviews('Reposition',[0;20;0],'fromSPMExt');
            %saving the AC_PC aligned image
            imgFile=get(guiData.ImageFileLB,'String');
            [path,name,ext]=fileparts(imgFile);
            name=[name '_' guiData.ACPCAlignSuffix];
            imgFile=fullfile(path,[name ext]);
            V=guiData.spmStruct.vols{1};
            V0=V;
            V.fname=imgFile;
            spm_write_vol(V,spm_read_vols(V0));
        end
    case 'Save Aligned Image'
        app=CommonMethods.getSourceApp();
        if(strcmpi(app,'SPM'))
            guiData=guidata(hObject);
            imgFile=get(guiData.ImageFileLB,'String');
            [path,name,ext]=fileparts(imgFile);
            name=[name '_' guiData.ACPCAlignSuffix];
            imgFile=fullfile(path,[name ext]);
            V=guiData.spmStruct.vols{1};
            V0=V;
            V.fname=imgFile;
            spm_write_vol(V,spm_read_vols(V0));
        end
end

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

    function appendImage(hObject, fname)
        imgs=getOpenedImages(hObject);
        imgs{end+1}=fname;
        imgs=cellfun(@(x) spm_vol(x),imgs,'UniformOutput',false);
        imgs=cell2mat(imgs);
        spm_check_registration(imgs);
        
% --- Executes on selection change in ImageHandlingLstBx.
function ImageHandlingLstBx_Callback(hObject, eventdata, handles)
% hObject    handle to ImageHandlingLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ImageHandlingLstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ImageHandlingLstBx
%set(guiData.ImageHandlingLstBx,'String',{'Append Image' 'Close Image' 'Save Image' 'Intensity Profile' 'Voxel Histogram'});
options=get(handles.ImageHandlingLstBx,'String');
operation=options{get(handles.ImageHandlingLstBx,'Value')};
switch (operation)
    case 'Append Image'
        [img, ~] = spm_select(1,'image','Select image');
        appendImage(hObject, img);
    case 'Load Anatomic Mask'
        imgs=getOpenedImages(hObject);
        img1=imgs{1};
        V=spm_vol(img1);
        
    case 'Close Image'
        imgs=getOpenedImages(hObject);
        idx=get(handles.ImageFilesLstB, 'Value');
        imgs=CommonMethods.removeCells(imgs, idx);
        imgs=cellfun(@(x) spm_vol(x),imgs,'UniformOutput',false);
        imgs=cell2mat(imgs);
        spm_check_registration(imgs);
    case 'Save Image'
        imgs=getOpenedImages(hObject);
        idx=get(handles.ImageFilesLstB, 'Value');
        arrayfun(@(x) removeFromtemporaryFileList(hObject,imgs{x}), idx);
    case 'Intensity Profile'
        imgs=getOpenedImages(hObject);
        idx=get(handles.ImageFilesLstB, 'Value');
        fname=imgs{idx(1)};
        V=spm_vol(fname);
        vols=spm_read_vols(spm_vol(fname));
        dim=size(vols);
        mat=V.mat;
        
        coori=mat*[0 0 0 1]';
        coorf=mat*[dim(1), dim(2), dim(3), 1]';
        coord=coorf-coori;
        
        idx = getCurrentVoxelIndexes(hObject);
        figure();
        
        [~, name, ~]=fileparts(fname);
        name=strrep(name,'_', '\_');
        subplot(2,2,1);
        len=dim(1);
        x=1:len;
        y=vols(:,idx(2),idx(3));
        x=x-idx(1);
%         if(coord(1)<0)             
%             x=-1*x;
%         end;
        plot(x,y);
        set(gca, 'fontsize', 14);
        title(name);
        xlabel('Axis 1 (voxel)')
        ylabel('Intensity');
        
        subplot(2,2,2);
        len=dim(2);
        x=1:len;
        y=vols(idx(1),:,idx(3));
        x=x-idx(2);
%        if(coord(2)<0) x=-1*x;end;
        plot(x,y);
        set(gca, 'fontsize', 14);
        title(name);
        xlabel('Axis 2 (voxel)')
        ylabel('Intensity');        
        
        subplot(2,2,3);
        len=dim(3);
        x=1:len;
        y=squeeze(vols(idx(1),idx(2),:));
        x=x-idx(3);
%        if(coord(3)<0) x=-1*x;end;
        plot(x,y);
        set(gca, 'fontsize', 14);
        title(name);
        xlabel('Axis3 (voxel)')
        ylabel('Intensity');
    case 'Voxel Histogram'
        displayVoxelHistogam(hObject);
end

    function closeImage(fname,hObject)
        imgs=getOpenedImages(hObject);
        idx=find(ismember(imgs,fname));
        if(isempty(idx))
            return;
        end
        imgs=CommonMethods.removeCells(imgs, idx);
        imgs=cellfun(@(x) spm_vol(x),imgs,'UniformOutput',false);
        imgs=cell2mat(imgs);
        spm_check_registration(imgs);

% --- Executes during object creation, after setting all properties.
function ImageHandlingLstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ImageHandlingLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function SelectedImageLstBx_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to SelectedImageLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function MinIntensityTF_Callback(hObject, eventdata, handles)
% hObject    handle to MinIntensityTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MinIntensityTF as text
%        str2double(get(hObject,'String')) returns contents of MinIntensityTF as a double


    function IntensityRangeSelection(hObject)
app=getInteractingApp(hObject);
guiData=guidata(hObject);
iI=str2num(get(guiData.MinIntensityTF, 'String'));
iF=str2num(get(guiData.MaxIntensityTF, 'String'));
if(strcmpi(app,'xjview'))
    if(isfield(guiData,'interactingAppHandle'))
        h=guiData.interactingAppHandle;
        guiData=guidata(h);
        guiData.CallBack_slider_TJ(guiData.slider,[],[iI iF]);
    end    
elseif(strcmpi(app,'spm'))
    fname=getCurrentImage(hObject);
    V=spm_vol(fname);
    vols=spm_read_vols(V);
    [path, name, ext]=fileparts(fname);
    name1=[name '_' num2str(iI) '_to_' num2str(iF)]
    fname1=fullfile('/home/JinT/tempData', [name1 ext]);
    guiData.temporaryImageFiles{end+1}=fname1;
    V.fname=fname1;
    vols1=zeros(V.dim);
    vols1(((vols>=iI).*(vols<=iF))>0)=1;
    V.dt(1)=2;
    spm_write_vol(V,vols1);
    appendImage(hObject, fname1);
end

        function fname=getCurrentImage(hObject)
            guiData=guidata(hObject);
            fname=guiData.currentImgFileName;
            
% --- Executes during object creation, after setting all properties.
function MinIntensityTF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MinIntensityTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function MaxIntensityTF_Callback(hObject, eventdata, handles)
% hObject    handle to MaxIntensityTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaxIntensityTF as text
%        str2double(get(hObject,'String')) returns contents of MaxIntensityTF as a double
IntensityRangeSelection(hObject);

% --- Executes during object creation, after setting all properties.
function MaxIntensityTF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxIntensityTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in StoredCoordinatesLstBx.
function StoredCoordinatesLstBx_Callback(hObject, eventdata, handles)
% hObject    handle to StoredCoordinatesLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns StoredCoordinatesLstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from StoredCoordinatesLstBx
guiData=guidata(hObject);
[idx, strs]=CommonMethods.getSelection(guiData.StoredCoordinatesLstBx);
set(guiData.Coor_mmTF,'String', strs{1});
Coor_mmTF_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function StoredCoordinatesLstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StoredCoordinatesLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AnatomicMaskBT.
function AnatomicMaskBT_Callback(hObject, eventdata, handles)
% hObject    handle to AnatomicMaskBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guiData=guidata(hObject);
app=getInteractingApp(hObject);
if(strcmpi(app,'spm'))
elseif(strcmpi(app,'xjView'))
    xjViewStruct=guiData.xjViewStruct;
     h=xjViewStruct.xjViewFigureHandle;
     handles=guidata(h);
     
     anatomySelection=zeros(1,5);
     anatomySelection(1)=get(guiData.HemisphereLstBx,'Value')-1;
     anatomySelection(2)=get(guiData.LobeLstBx,'Value')-1;
     anatomySelection(3)=get(guiData.GyrusLstBx,'Value')-1;
     anatomySelection(4)=get(guiData.TissueLstBx,'Value')-1;
     anatomySelection(5)=get(guiData.CellLstBx,'Value')-1;
     handles.externalFunction(h, 'anatomicMasking',guiData.X.DB_sorted,anatomySelection);
%     handles.externalFunction(h, 'anatomicMasking',guiData.X);
end

function AnatomicRegionTF_Callback(hObject, eventdata, handles)
% hObject    handle to AnatomicRegionTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AnatomicRegionTF as text
%        str2double(get(hObject,'String')) returns contents of AnatomicRegionTF as a double
guiData=guidata(hObject);
set(guiData.AnatomicRegionLstBx, 'String', fieldnames(guiData.X.wholeMaskMNIAll));
strs=CommonMethods.searchStri_LstBx(guiData.AnatomicRegionLstBx, get(guiData.AnatomicRegionTF, 'String'));
set(guiData.AnatomicRegionLstBx, 'Value', length(strs));
set(guiData.AnatomicRegionLstBx, 'String', strs);

% --- Executes during object creation, after setting all properties.
function AnatomicRegionTF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnatomicRegionTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in AnatomicRegionLstBx.
function AnatomicRegionLstBx_Callback(hObject, eventdata, handles)
% hObject    handle to AnatomicRegionLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns AnatomicRegionLstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AnatomicRegionLstBx
guiData=guidata(hObject);
[~,selection]=CommonMethods.getSelection(guiData.AnatomicRegionLstBx);
set(guiData.AnatomicRegionTF, 'String', selection{1});

% --- Executes during object creation, after setting all properties.
function AnatomicRegionLstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnatomicRegionLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fname=spm_select();
fname=trim(fname(1,:));
[path, name, ext]=fileparts(fname);
fname=fullfile(path,'saved_coordinates.txt');
fid=fopen(fname,'wt');
guiData=guidata(hObject);
coors=get(guiData.StoredCoordinatesLstBx,'String');
for i=1:length(coors)
    fprintf(fid,'%s\n',coors{i});
end
fclose(fid);



function VoxelValuesTF_Callback(hObject, eventdata, handles)
% hObject    handle to VoxelValuesTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VoxelValuesTF as text
%        str2double(get(hObject,'String')) returns contents of VoxelValuesTF as a double


% --- Executes during object creation, after setting all properties.
function VoxelValuesTF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VoxelValuesTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
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


% --- Executes on button press in NoTranslationRB.
function NoTranslationRB_Callback(hObject, eventdata, handles)
% hObject    handle to NoTranslationRB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of NoTranslationRB
updateGUI(hObject);


% --- Executes on button press in DispACPCAlignedImgRB.
function DispACPCAlignedImgRB_Callback(hObject, eventdata, handles)
% hObject    handle to DispACPCAlignedImgRB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DispACPCAlignedImgRB


% --- Executes when spm_extension is resized.
function spm_extension_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to spm_extension (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over ImageHandlingLstBx.
function ImageHandlingLstBx_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to ImageHandlingLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guiData=guidata(hObject)
if(isfield(guiData,'tableHandle'))
    hTable=guiData.tableHandle;
    uistat(hTable,'top');
else
    hTable=quickTabular();
    udt=guidata(hTable);
    udt.spmExtension=hObject;
    guidata(hTable, udt);
end


% --- Executes on key press with focus on spm_extension or any of its controls.
function spm_extension_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to spm_extension (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if  ~(strcmp(eventdata.Key, 'uparrow')||strcmp(eventdata.Key, 'downarrow')||strcmp(eventdata.Key, 'rightarrow')||strcmp(eventdata.Key, 'leftarrow'))
    return;
end

dx=1;
dy=1;
guiData=guidata(hObject);
voxelStep=get(guiData.VoxelStepSizeTF,'String');
if(~isempty(voxelStep))
    step=CommonMethods.str2nums(voxelStep,' ');
    if length(step) ~=3
        return;
    end
    volInds=guiData.currentVolInds+step;
    guiData.currentVolInds=volInds;
    guidata(hObject,guiData);
    coor=CommonMethods.ind2coor_mat(volInds,guiData.currentMat);
    updateCoordinates_mni(hObject,coor);
else
    if(strcmp(eventdata.Key, 'uparrow'))
        CommonMethods.shiftUIControls(hObject, 0, dy);
    elseif(strcmp(eventdata.Key, 'downarrow'))
        CommonMethods.shiftUIControls(hObject, 0, -dy);
    elseif(strcmp(eventdata.Key, 'leftarrow'))
        CommonMethods.shiftUIControls(hObject,-dx,0);
    elseif(strcmp(eventdata.Key, 'rightarrow'))
        CommonMethods.shiftUIControls(hObject, dx,0);
    end
end


% --- Executes on button press in ExportClusterInfosBT.
function ExportClusterInfosBT_Callback(hObject, eventdata, handles)
% hObject    handle to ExportClusterInfosBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
exportSignificantLocalMaxima_xjView(hObject);

    function exportDB(DB)
        tab=sprintf('%s\t','');
        mnilist=DB{1}.mnilist;
        dim=size(mnilist);
        outdir=fullfile(CommonEnvMethods.getMatlabProjectPath(),'Literature Tables','DB');
        if(~exist(outdir,'file'))
            mkdir(outdir);
        end
        fname=fullfile(outdir,'TD_atlas_structures.tsv');
        fid=fopen(fname,'wt');
        
        structures={};%unique structures
        for i=1:dim(1)
            for j=1:dim(2)
                for k=1:dim(3)
                    inds=cellfun(@(x)x.mnilist(i,j,k),DB);
                    structure='';
                    defined=false;
                    for s=1:length(inds)
                        ind=inds(s);
                        if(ind==0)
                            str='undefined';
                        else
                            str=DB{s}.anatomy{ind};
                            defined=true;
                        end
                        structure=[structure tab str];
                    end
                    if(~defined)
                        continue;
                    end
                    uq=false;
                    if(isempty(structures))
                        uq=true;
                    elseif(~ismember(structure, structures))
                        uq=true;
                    end
                    if(uq)
                        structures{end+1}=structure;
                    end
                end
            end
        end
        
        for s=1:length(structures)
            line=structures{s};
            for i=1:6
                anatomy=DB{i}.anatomy;
                if(s<=length(anatomy))
                    line=[line tab anatomy{s}];
                else
                    line=[line tab ''];
                end
            end
            fprintf(fid,'%s\n',line);
        end
        fclose(fid);
        
function exportSignificantLocalMaxima_xjView(hObject)
guiData=guidata(hObject);    
app=getInteractingApp(hObject);


if(strcmpi(app,'xjView'))
%    exportDB(guiData.DB);
    chandler=SPM_statFileHandler(guiData.xjViewStruct.handles,guiData.currentImgFileName);
    chandler.exportClusterAnatomicalMasks(3);
    chandler.exportSummaryTables();
end    

    function name=tableRoiName(cellname)
    %one line roi name
    name=cellname{1};
    switch (name)
        case 'Left Cerebrum'
            name='L';
        case 'Right Cerebrum'
            name='R';                
    end
    
    if(strcmpi(cellname{3},'undefined'))
        name=[name ' ' cellname{2}];
    else
        name=[name ' ' cellname{3}];
    end
    
    if(~strcmpi(cellname{5},'undefined'))
        name=[name ' (' cellname{5} ')'];
    end   
    
    name=strrep(name,'brodmann area', 'BA');
    
    function name=tableRoiShortName(cellname)
    %one line roi name
    name=cellname{1};
    switch (name)
        case 'Left Cerebrum'
            name='L';
        case 'Right Cerebrum'
            name='R';                
    end
    
    if(strcmpi(cellname{3},'undefined'))
        name=[name ' ' cellname{2}];
    else
        name=[name ' ' cellname{3}];
    end
    
%     if(~strcmpi(cellname{5},'undefined'))
%         name=[name ' (' cellname{5} ')'];
%     end   


% --- Executes on selection change in HemisphereLstBx.
function HemisphereLstBx_Callback(hObject, eventdata, handles)
% hObject    handle to HemisphereLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns HemisphereLstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from HemisphereLstBx
updateAnatomicSelection(hObject);

% --- Executes during object creation, after setting all properties.
function HemisphereLstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HemisphereLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in LobeLstBx.
function LobeLstBx_Callback(hObject, eventdata, handles)
% hObject    handle to LobeLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LobeLstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LobeLstBx
updateAnatomicSelection(hObject);

% --- Executes during object creation, after setting all properties.
function LobeLstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LobeLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in GyrusLstBx.
function GyrusLstBx_Callback(hObject, eventdata, handles)
% hObject    handle to GyrusLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns GyrusLstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from GyrusLstBx
updateAnatomicSelection(hObject);

% --- Executes during object creation, after setting all properties.
function GyrusLstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GyrusLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in TissueLstBx.
function TissueLstBx_Callback(hObject, eventdata, handles)
% hObject    handle to TissueLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns TissueLstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TissueLstBx
updateAnatomicSelection(hObject);

% --- Executes during object creation, after setting all properties.
function TissueLstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TissueLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in CellLstBx.
function CellLstBx_Callback(hObject, eventdata, handles)
% hObject    handle to CellLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns CellLstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CellLstBx
updateAnatomicSelection(hObject);

% --- Executes during object creation, after setting all properties.
function CellLstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CellLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AnatomicalRegionVoxelAcountsBT.
function AnatomicalRegionVoxelAcountsBT_Callback(hObject, eventdata, handles)
% hObject    handle to AnatomicalRegionVoxelAcountsBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guiData=guidata(hObject);
app=getInteractingApp(hObject);
X=guiData.X;
if(strcmpi(app,'spm'))
elseif(strcmpi(app,'xjView'))
    xjViewStruct=guiData.xjViewStruct;
     h=xjViewStruct.xjViewFigureHandle;
     handles=guidata(h);
     curImg=guiData.currentImgFileName;
    [cur_dir,name,ext]=fileparts(curImg);
    cur_fname=['Anatomical Voxel Counts_' name '.tsv'];
    handles.externalFunction(h, 'AnatomicVoxelCounts',X,cur_dir, cur_fname);
end


% --- Executes on button press in ErodeCB.
function ErodeCB_Callback(hObject, eventdata, handles)
% hObject    handle to ErodeCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ErodeCB
guiData=guidata(hObject);
guiData.X.erode=get(guiData.ErodeCB,'Value');
guidata(hObject, guiData);
updateAnatomicSelection(hObject);

% --- Executes on slider movement.
function XSlider_Callback(hObject, eventdata, handles)
% hObject    handle to XSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
CoordinateSliderUpdated(hObject,1);

% --- Executes during object creation, after setting all properties.
function XSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function YSlider_Callback(hObject, eventdata, handles)
% hObject    handle to YSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
CoordinateSliderUpdated(hObject,2);

% --- Executes during object creation, after setting all properties.
function YSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function ZSlider_Callback(hObject, eventdata, handles)
% hObject    handle to ZSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
CoordinateSliderUpdated(hObject,3);

% --- Executes during object creation, after setting all properties.
function ZSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ZSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

    function CoordinateSliderUpdated(hObject, axis)
        guiData=guidata(hObject);
        coor=[get(guiData.XSlider,'Value') get(guiData.YSlider, 'Value') get(guiData.ZSlider, 'Value')];
        if(get(guiData.WithinROIRB,'Value')&&exist('axis','var'))
            cur_inds=CommonMethods.mni2ind_cols(coor',guiData.X.mat);
            inds=guiData.X.cluster.idx{get(guiData.ROICenterLstBx,'Value')};
            idx=inds(:,axis)==cur_inds(axis);
            inds=inds(idx,:);%the indexes of the voxels on the plane normal to axis and going through coor
            if(size(inds,1)>1)
                mins=min(inds);
            else
                mins=min([inds;inds]);
            end
            
            axes=[1 2 3];
            axes=axes(axes~=axis);
            a=axes(1);
            ind=cur_inds(a);
            idx1=inds(:,a)==ind;
            if(~any(idx1))
                ind=mins(a);
                idx1=inds(:,a)==ind;
                cur_inds(a)=ind;
            end            
            inds=inds(idx1,:);
            if(size(inds,1)>1)
                mins=min(inds);
            else
                mins=min([inds;inds]);
            end
            
            a=axes(2);
            ind=cur_inds(a);
            idx2=inds(:,a)==ind;
            if(~any(idx2))
                ind=mins(a);
                cur_inds(a)=ind;
            end
            coor=CommonMethods.ind2coor_mat(cur_inds',guiData.X.mat);
        end
        updateCoordinates_mni(hObject,coor');
        
        function updateCoorSliders(hObject, coors)
            guiData=guidata(hObject);
            if(~get(guiData.WithinROIRB, 'Value'))
                return;
            end
%             ind=get(guiData.ROICenterLstBx, 'Value');
%             mins=guiData.X.cluster.coorMins{ind};
%             maxs=guiData.X.cluster.coorMaxs{ind};
%             center=guiData.X.cluster.centers{ind};
            
            for i=1:3
                coor=coors(i);
                n=min(get(guiData.CoorSliders{i},'Min'),coor);
                x=max(get(guiData.CoorSliders{i},'Max'),coor);
%                 if(coor < n || coor > x)
%                     coor=0.5*(n+x);
%                 end
                set(guiData.CoorSliders{i},'Min',n);
                set(guiData.CoorSliders{i},'Max',x);
                set(guiData.CoorSliders{i},'Value',coor);
                
                label=guiData.CoorSliderTexts{i};
                str=get(label,'String');
                str=[str(1:4) num2str(coor) ' (' num2str(n) ' to ' num2str(x) ')'];
                set(label,'String',str);
            end
            
            
            
            
            % --- Executes on button press in WithinROIRB.
            function WithinROIRB_Callback(hObject, eventdata, handles)
                % hObject    handle to WithinROIRB (see GCBO)
                % eventdata  reserved - to be defined in a future version of MATLAB
                % handles    structure with handles and user data (see GUIDATA)
                
        function updateAnatomicSelection(hObject)
        %This function update the selection of voxels based on the choices
        %on the five list boxes which specify the anatomical region
        %selections at the file level of Tarairach Daemon atlas.
        %It update two fields in X:
        %X.selection: a matrix of X.dim indicating the selected voxels
        %X.cluster: clusterising X.selection
        guiData=guidata(hObject);
        X=guiData.X;
        X.selection(:,:,:)=1;
        len=length(X.AnotomicalListBoxes);
        if(X.erode)
            DB=X.DB_sorted_eroded;
        else
            DB=X.DB_sorted;
        end
        X.anatomicalSelection=false;
        for a=1:len
            db=DB{a};
            v=get(X.AnotomicalListBoxes{a},'Value')-1;
            if(v(1)==0)%select all
                continue;
            end
            X.anatomicalSelection=true;
            cur_selection=zeros(X.dim);
            for i=1:length(v)
                cur_selection(db.mnilist==v(i))=1;
            end
            X.selection=X.selection.*cur_selection;
        end
        if(~X.anatomicalSelection)
            X.selection(:,:,:)=0;
            X.cluster.sizes={};
            X.cluster.idx={};
            X.cluster.coors={};
            X.cluster.centers={};
            X.cluster.coorMins={};       
            X.cluster.coorMaxs={};       
            return;
        end
        
        idx=find(X.selection);
        [a1,a2,a3]=ind2sub(X.dim,idx);
        a=[a1 a2 a3];
        [centers, sizes, clusters] = CommonMethods.findClusterCenters(a);
        noClusters=size(centers,1);
        %clusters: the voxel indexes of voxels in each cluster
        X.cluster.sizes=sizes;
        X.cluster.idx=clusters;
        X.cluster.coors=cell(1,noClusters);
        X.cluster.centers=cell(1,noClusters);
        X.cluster.coorMins=cell(1,noClusters);       
        X.cluster.coorMaxs=cell(1,noClusters);       
        clusterInfo=cell(1,noClusters);%to display on ROICenterLstBx
        for c=1:noClusters;        
            a=clusters{c};
            X.cluster.coors{c}=CommonMethods.ind2coor_mat(a,X.mat);
            center=CommonMethods.ind2coor_mat(centers(c,:),X.mat);
            clusterInfo{c}=[num2str(center(1)) ' ' num2str(center(2)) ' '  num2str(center(3)) ' size: ' num2str(size(a,1))]; 
            X.cluster.centers{c}=center;
            if(size(X.cluster.coors{c},1)==1)
                X.cluster.coorMins{c}=min([X.cluster.coors{c};X.cluster.coors{c}]);            
                X.cluster.coorMaxs{c}=max([X.cluster.coors{c};X.cluster.coors{c}]);            
            else
                X.cluster.coorMins{c}=min(X.cluster.coors{c});            
                X.cluster.coorMaxs{c}=max(X.cluster.coors{c});            
            end
        end
        set(guiData.ROICenterLstBx, 'String', clusterInfo);
        set(guiData.ROICenterLstBx, 'Value', 1);
        set(guiData.ROICenterLstBx, 'Max',noClusters);
        guiData.X=X;
        guidata(hObject,guiData);
        resetXYZRange(hObject)
        
    function resetXYZRange(hObject)
        %this function resets the coordinate sliderbars according to the
        %cluster information specified in X
        guiData=guidata(hObject);
        if(~get(guiData.WithinROIRB, 'Value'))
            return;
        end
        if(isempty(guiData.X.cluster.sizes))
            return;
        end
        ind=get(guiData.ROICenterLstBx, 'Value');
        mins=guiData.X.cluster.coorMins{ind};
        maxs=guiData.X.cluster.coorMaxs{ind};
        center=guiData.X.cluster.centers{ind};        
        for i=1:3
            coor=center(i);
            n=mins(i);
            x=maxs(i);
            if(coor < n || coor > x)
                coor=0.5*(n+x);
            end            
            set(guiData.CoorSliders{i},'Min',n);
            set(guiData.CoorSliders{i},'Max',x);
            set(guiData.CoorSliders{i},'Value',coor);            
            label=guiData.CoorSliderTexts{i};
            str=get(label,'String');
            str=[str(1:4) num2str(coor) ' (' num2str(n) ' to ' num2str(x) ')'];
            set(label,'String',str);
        end
        CoordinateSliderUpdated(hObject);    
        
        function drawClusterContours(hObject,coor)
            guiData=guidata(hObject);
            if(~get(guiData.ClusterContourRB,'Value'))
                guiData.ClusterContour.clearContourLines();
                return;
            end
            if(~exist('coor','var'))
                coor=guiData.currentCoor;
            end
            guiData=guidata(hObject);
            app=getInteractingApp(hObject);
            X=guiData.X;
            if(~X.anatomicalSelection)
                return;
            end
            if(strcmpi(app,'spm'))
            elseif(strcmpi(app,'xjView'))
                xjViewStruct=guiData.xjViewStruct;
                st=xjViewStruct.st;
                idx=get(guiData.ROICenterLstBx,'Value');
                coors=[];
                len=min(length(idx),length(X.cluster.coors));
                for t=1:len
                    coorst=X.cluster.coors{t};
                    coors=[coors;coorst];
                end
                guiData.ClusterContour.update(st, coor, coors,X.mat);
            end
            
            


% --- Executes on selection change in ROICenterLstBx.
function ROICenterLstBx_Callback(hObject, eventdata, handles)
% hObject    handle to ROICenterLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ROICenterLstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ROICenterLstBx
% --- Executes during object creation, after setting all properties.
resetXYZRange(hObject);

function ROICenterLstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ROICenterLstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ClusterContourRB.
function ClusterContourRB_Callback(hObject, eventdata, handles)
% hObject    handle to ClusterContourRB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ClusterContourRB
drawClusterContours(hObject);

    function sphere=getCurrentShpere(hObject)
        %this function update the shperes in guidata of hObject and return
        %the current one
        guiData=guidata(hObject);
        if(~isfield(guiData,'spheres'))
            spheres={};
        else
            spheres=guiData.spheres;
        end
        fnames=cellfun(@(x)x.fname,spheres,'UniformOutput',false);
        fname=guiData.currentImgFileName;
        idx=find(ismember(fnames,fname));
        if(~isempty(idx))
            ind=idx(1);
        else %initialize one
            radius=CommonMethods.str2nums(get(guiData.SphereRadiusTF,'String'), ' ');
            sphere.name='sphere';
            sphere.size=radius;
            sphere.fname=fname;
            sphere=CommonMethods.getShape(sphere);
            spheres{end+1}=sphere;
            fnames{end+1}=fname;
            ind=length(fnames);
        end
        
        str=get(guiData.Coor_mmTF,'String');
        coor=CommonMethods.str2nums(str, ' ');
        sphere=spheres{ind};
        center=CommonMethods.coor2ind_mat(coor,sphere.idim.mat);
        sphere=CommonMethods.updateShapePosition(sphere,center);
        spheres{ind}=sphere;
        
        %removing out dated spheres
%         [~, names]=getOpenedImages(hObject);
%         idx=ismember(fnames, names);
%         spheres=spheres(idx);
%         %update the sphere list
        guiData.spheres=spheres;
        guidata(hObject, guiData);
       
        % --- Executes on button press in ExportSphereBT.
function ExportSphereBT_Callback(hObject, eventdata, handles)
% hObject    handle to ExportSphereBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%guiData=guidata(hObject);
% str=get(guiData.Coor_mmTF,'String');
% coor=CommonMethods.str2nums(' ', str);
% fname=guiData.currentImgFileName;
% V=spm_vol(fname);
% radius=CommonMethods.str2nums(' ',get(guiData.SphereRadiusTF,'String'));
% shape.name='shpere';
% shape.size=radius;
% shape.fname=fname;
% shape=CommonMethods.getShape(shape);
% center=CommonMethods.coor2ind_mat(coor,shape.idim.mat);
% shape=CommonMethods.updateShapePosition(shape,center);

shape=getCurrentShpere(hObject);
[folder,cfname,ext]=fileparts(fname);
folder=fullfile(folder,'maskImgs','shperes');
if(~exist(folder,'file'))
    mkdir(folder);
end
name=[cfname '_shpere_'];
name=[name 'r' num2str(radius) '_'];
for i=1:3
    tmp=coor(i);
    if(tmp>=0)
        name=[name 'p'];
    else
        name=[name 'n'];
    end
    name=[name strtrim(sprintf('%6.0f',abs(tmp)))];
end
tdah=TDAtlasHandler();
sname=tdah.findStructures(coor);
sname=TDAtlasHandler.getOnelineStructureName(sname);
name=[name '_' sname];
fname=fullfile(folder,[name ext]);
vols=zeros(V.dim);
inds=sub2ind(shape.idim.dim,shape.curVIndexes(:,1),shape.curVIndexes(:,2),shape.curVIndexes(:,3));
vols(inds)=1;
V.fname=fname;
spm_write_vol(V,vols);

function SphereRadiusTF_Callback(hObject, eventdata, handles)
% hObject    handle to SphereRadiusTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SphereRadiusTF as text
%        str2double(get(hObject,'String')) returns contents of SphereRadiusTF as a double


% --- Executes during object creation, after setting all properties.
function SphereRadiusTF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SphereRadiusTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PlotSphereRB.
function PlotSphereRB_Callback(hObject, eventdata, handles)
% hObject    handle to PlotSphereRB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PlotSphereRB


% --- Executes on button press in SaveImageBrowsingHistoryRB.
function SaveImageBrowsingHistoryRB_Callback(hObject, eventdata, handles)
% hObject    handle to SaveImageBrowsingHistoryRB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SaveImageBrowsingHistoryRB
guiData=guidata(hObject);
tab=sprintf('%s\t','');
if(get(guiData.SaveImageBrowsingHistoryRB,'value'))
    imgs=getSelectedImages(hObject);
    if(~isempty(imgs))
        [cur_dir, cur_fname, ~]=fileparts(imgs{1});
        name=['browsing_hist_' cur_fname];
        line=imgs{1};
        for i=2:length(imgs)
            [~, tmp, ~]=fileparts(imgs{i})
            name=[name '_' tmp];
            line=[line tab imgs{i}];
        end
        name=[name '.tsv'];
        [fname, path]=uiputfile('*.tsv','Specify a tab separated file to export the image browsing history', fullfile(cur_dir,name));
        guiData.fidBrowingHist.fid=fopen(fullfile(path,fname),'wt');
        fprintf(guiData.fidBrowingHist.fid,'%s\n',[tab line]);
        guiData.fidBrowingHist.imgs=imgs;
    end
else    
    if(~isnan(guiData.fidBrowingHist.fid));
        fclose(guiData.fidBrowingHist);
        guiData.fidBrowingHist.fid=nan;
        guiData.fidBrowingHist.imgs={};
    end
end
guidata(hObject,guiData);


% --- Executes on button press in PlotAnatPB.
function PlotAnatPB_Callback(hObject, eventdata, handles)
% hObject    handle to PlotAnatPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hObject    handle to AnatomicalRegionVoxelAcountsBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%plot anatomical region
guiData=guidata(hObject);
app=getInteractingApp(hObject);
X=guiData.X;
if(strcmpi(app,'spm'))
elseif(strcmpi(app,'xjView'))
    xjViewStruct=guiData.xjViewStruct;
    coor=xjViewStruct.handles.currentDisplayMNI{1};
    len=size(coor,1);
    inds=CommonMethods.mni2ind_cols(coor', X.mat)';
    selected=arrayfun(@(x)X.selection(inds(x,1),inds(x,2),inds(x,3)), 1:len);
    coor=coor(find(selected),:);
    updatePlotter(hObject, coor')
end


% --- Executes on button press in UpdateplotsRB.
function UpdateplotsRB_Callback(hObject, eventdata, handles)
% hObject    handle to UpdateplotsRB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UpdateplotsRB


% --- Executes on button press in curDirBT.
function curDirBT_Callback(hObject, eventdata, handles)
% hObject    handle to curDirBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guiData=guidata(hObject);
curImg=guiData.currentImgFileName;
[folder,~,~]=fileparts(curImg);
cd(folder);


% --- Executes on button press in AdjustFramesRB.
function AdjustFramesRB_Callback(hObject, eventdata, handles)
% hObject    handle to AdjustFramesRB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function VoxelStepSizeTF_Callback(hObject, eventdata, handles)
% hObject    handle to VoxelStepSizeTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VoxelStepSizeTF as text
%        str2double(get(hObject,'String')) returns contents of VoxelStepSizeTF as a double


% --- Executes during object creation, after setting all properties.
function VoxelStepSizeTF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VoxelStepSizeTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
