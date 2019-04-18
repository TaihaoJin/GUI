classdef FM
    
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mainFig;
    end
    
    methods
        function obj=FM()
            obj.mainFig=FM.getFM();
        end
    end
    
    methods (Static=true)
        function closeAll()
            CommonMethods.closeAll();
        end
        function clear();
            exceptions=FM.getFigures();            
            CommonMethods.closeAll(exceptions);
        end
        function fm=getFM()
            fm=CommonMethods.getFigureByName('FigureManager');
            if(isempty(fm))
                fm=FigureManager();
            end
            figure(fm);
        end
        function statSummary()
            quickTabular_spmSummary();
        end
        function addFigure(fH,name)
            h=FM.getFM();
            guiData=guidata(h);
            len=length(guiData.fHs);
            idx=find(ismember(guiData.fNames,name));
            if(isempty(idx))
                ind=len+1;
            else
                ind=idx(1);
            end
            bt=guiData.buttons{ind};
            guiData.fHs{ind}=fH;
            guiData.fNames{ind}=name;
            set(bt,'String',name);
            set(bt,'Visible','on');
            guidata(h,guiData);
        end
        
        function buttonPushed(bt)
            h=FM.getFM();
            guiData=guidata(h);
            idx=find(cellfun(@(x)x==bt,guiData.buttons));
            if(isempty(idx))
                return;
            end
            if(~isvalid(guiData.fHs{idx(1)}))
                return;
            end
            figure(guiData.fHs{idx(1)});
        end
        
        function fHs=getFigures()
            h=FM.getFM();
            guiData=guidata(h);
            fHs=guiData.fHs;
            fHs{end+1}=FM.getFM();
        end
        
        function fH=getFigure(name)
            fH=[];
            h=FM.getFM();
            guiData=guidata(h);
            idx=find(ismember(guiData.fNames,name));
            if(isempty(idx))
                return;
            end
            fH=guiData.fHs{idx(1)};
        end
    end
end

