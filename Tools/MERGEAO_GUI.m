function h1 = MERGEAO_GUI()
% This is the machine-generated representation of a Handle Graphics object
% and its children.  Note that handle values may change when these objects
% are re-created. This may cause problems with any callbacks written to
% depend on the value of the handle at the time the object was saved.
% This problem is solved by saving the output as a FIG-file.
%
% To reopen this object, just type the name of the M-file at the MATLAB
% prompt. The M-file and its associated MAT-file must be on your path.
%
% NOTE: certain newer features in MATLAB may not have been saved in this
% M-file due to limitations of this format, which has been superseded by
% FIG-files.  Figures which have been annotated using the plot editor tools
% are incompatible with the M-file/MAT-file format, and should be saved as
% FIG-files.

clear all;clc;
%close all;

global ori_data output;
ori_data = [];
monkeys = {'Polo';'Qiaoqiao'};

appdata = [];
appdata.GUIDEOptions = struct(...
    'active_h', 403.003784179688, ...
    'taginfo', struct(...
    'figure', 2, ...
    'text', 9, ...
    'edit', 5, ...
    'pushbutton', 9, ...
    'popupmenu', 2), ...
    'override', 0, ...
    'release', 13, ...
    'resize', 'none', ...
    'accessibility', 'callback', ...
    'mfile', 0, ...
    'callbacks', 1, ...
    'singleton', 1, ...
    'syscolorfig', 1, ...
    'blocking', 0, ...
    'lastFilename', 'Z:\Labtools\Tools\MERGEAO_GUI.fig');
appdata.lastValidTag = 'figure1';
appdata.GUIDELayoutEditor = [];
appdata.initTags = struct(...
    'handle', [], ...
    'tag', 'figure1');

h1 = figure(...
    'Units','characters',...
    'Color',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'Colormap',[0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 1;0.125 1 0.9375;0.1875 1 0.875;0.25 1 0.8125;0.3125 1 0.75;0.375 1 0.6875;0.4375 1 0.625;0.5 1 0.5625;0.5625 1 0.5;0.625 1 0.4375;0.6875 1 0.375;0.75 1 0.3125;0.8125 1 0.25;0.875 1 0.1875;0.9375 1 0.125;1 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0],...
    'IntegerHandle','off',...
    'InvertHardcopy',get(0,'defaultfigureInvertHardcopy'),...
    'MenuBar','none',...
    'Name','MERGEAO_GUI',...
    'NumberTitle','off',...
    'PaperPosition',get(0,'defaultfigurePaperPosition'),...
    'Position',[103.8 39.3076923076923 95 22.2307692307692],...
    'Resize','off',...
    'HandleVisibility','callback',...
    'UserData',[],...
    'Tag','figure1');

h2 = uicontrol(...
    'Parent',h1,...
    'Units','characters',...
    'FontSize',12,...
    'HorizontalAlignment','left',...
    'Position',[7.2 18.0000000000001 17.8 2.38461538461538],...
    'String','Monkey: ',...
    'Style','text',...
    'Tag','text1');

h3 = uicontrol(...
    'Parent',h1,...
    'Units','characters',...
    'FontSize',12,...
    'HorizontalAlignment','left',...
    'Position',[7.2 14.923076923077 17.8 2.38461538461538],...
    'String','File name:',...
    'Style','text',...
    'Tag','text2');

hMonkey = uicontrol(...
    'Parent',h1,...
    'Units','characters',...
    'BackgroundColor',[1 1 1],...
    'FontSize',12,...
    'Position',[23.4 18 22 2.76923076923077],...
    'String',monkeys,...
    'Style','popupmenu',...
    'Value',1);

h22 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',12,...
'HorizontalAlignment','left',...
'Position',[7.2 12.0769230769231 9.2 2.38461538461538],...
'String','#Ch:',...
'Style','text',...
'Tag','text1');

hChNo = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'FontSize',12,...
'HorizontalAlignment','left',...
'Position',[14.8 12.5384615384615 6.8 2.23076923076923],...
'String','16',...
'Style','edit',...
'Tag','channel number');

h_fileName = uicontrol(...
    'Parent',h1,...
    'Units','characters',...
    'BackgroundColor',[1 1 1],...
    'FontSize',12,...
    'HorizontalAlignment','left',...
    'Position',[23.4 15.3846153846154 22 2.23076923076923],...
    'String','m?c?r?',...
    'Style','edit',...
    'Tag','Filename');

% Good stuffs for change filename. Copy from HH20130831
fileNametemp = textread('Z:\Labtools\Tools\MergeAO_LastFileName.txt','%s');
fileName = fileNametemp{:};
set(h_fileName,'string',fileName);


h5 = uicontrol(...
    'Parent',h1,...
    'Units','characters',...
    'Callback',{@ChangeFileName,h_fileName},...
    'Position',[23.4 12.8461538461539 5 1.76923076923077],...
    'String','+c',...
    'Tag','pushbutton1');


h6 = uicontrol(...
    'Parent',h1,...
    'Units','characters',...
    'Callback',{@ChangeFileName,h_fileName},...
    'Position',[29 12.8461538461539 5 1.76923076923077],...
    'String','-c',...
    'Tag','pushbutton2');

h7 = uicontrol(...
    'Parent',h1,...
    'Units','characters',...
    'Callback',{@ChangeFileName,h_fileName},...
    'Position',[36.8000000000001 12.8461538461539 5 1.76923076923077],...
    'String','+r',...
    'Tag','pushbutton3');

h8 = uicontrol(...
    'Parent',h1,...
    'Units','characters',...
    'Callback',{@ChangeFileName,h_fileName},...
    'Position',[42.4 12.8461538461539 5 1.76923076923077],...
    'String','-r',...
    'Tag','pushbutton4');

h11 = uicontrol(...
    'Parent',h1,...
    'Units','characters',...
    'FontSize',19,...
    'FontWeight','bold',...
    'ForegroundColor',[0.313725490196078 0.313725490196078 0.313725490196078],...
    'HorizontalAlignment','right',...
    'Position',[46 16 45 5.61538461538462],...
    'String',{'Merge AO files'},...
    'Style','text',...
    'Tag','text3');


h14 = uicontrol(...
    'Parent',h1,...
    'Units','characters',...
    'FontSize',12,...
    'HorizontalAlignment','left',...
    'Position',[7.2 6.07692307692311 17.8 2.38461538461538],...
    'String','Save path:',...
    'Style','text',...
    'Tag','text5');

h17 = uicontrol(...
    'Parent',h1,...
    'Units','characters',...
    'FontSize',12,...
    'HorizontalAlignment','left',...
    'Position',[7.2 9.07692307692308 17.8 2.38461538461538],...
    'String','Data path:',...
    'Style','text',...
    'Tag','text8');

h_pathName = uicontrol(...
    'Parent',h1,...
    'Units','characters',...
    'BackgroundColor',[1 1 1],...
    'FontSize',11,...
    'HorizontalAlignment','left',...
    'Position',[23.4 9.53846153846154 56.6 2.23076923076923],...
    'String','Z:\Data\MOOG\Polo\raw\LA\',...
    'Style','edit',...
    'Tag','Pathname');

hSavePath = uicontrol(...
    'Parent',h1,...
    'Units','characters',...
    'BackgroundColor',[1 1 1],...
    'FontSize',11,...
    'HorizontalAlignment','left',...
    'Position',[23.4 6.53846153846156 56.6 2.23076923076923],...
    'String','Z:\Data\MOOG\Polo\raw\LA\',...
    'Style','edit',...
    'Tag','SavePath');

hBrowseOpen = uicontrol(...
    'Parent',h1,...
    'Units','characters',...
    'Callback',{@BrowseOpen,monkeys,hMonkey,h_fileName,h_pathName,hSavePath},...
    'Position',[82.2 9.5 10.6 2.23076923076923],...
    'String','Browse',...
    'Tag','BrowseOpen');

hBrowseSave = uicontrol(...
    'Parent',h1,...
    'Units','characters',...
    'Callback',{@FileSave,hSavePath},...
    'Position',[82.2 6.6 10.6 2.23076923076923],...
    'String','Browse',...
    'Tag','BrowseSave');

hLoadData = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','mergeAO(''load data'')',...
'FontSize',18,...
'FontWeight','bold',...
'ForegroundColor',[0.247058823529412 0.247058823529412 0.247058823529412],...
'Position',[5 1.84615384615385 25 3.23076923076923],...
'String','Load data',...
'Tag','LoadData');

hInfo = uicontrol(...
    'Parent',h1,...
    'Units','characters',...
    'Callback','mergeAO(''show info'')',...
    'FontSize',18,...
    'FontWeight','bold',...
    'ForegroundColor',[0.247058823529412 0.247058823529412 0.247058823529412],...
    'Position',[34.2 1.84615384615385 14 3.23076923076923],...
    'String','Info',...
    'Tag','info');

hInfoShowPanel = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)MERGEAO_GUI_export('Info_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[52.4 13 37.6 5.30769230769231],...
'String','Information of the data',...
'Style','listbox',...
'Value',1,...
'Tag','InfoShowPanel');

hMergeAO = uicontrol(...
    'Parent',h1,...
    'Units','characters',...
    'Callback','mergeAO(''merge files'')',...
    'FontSize',18,...
    'FontWeight','bold',...
    'ForeGroundColor',[0 0.6 0.6],...
    'Position',[52.4000000000001 1.84615384615385 11.6 3.23076923076923],...
    'String','GO!',...
    'Tag','pushbutton6');

hSaveFiles = uicontrol(...
    'Parent',h1,...
    'Units','characters',...
    'Callback','mergeAO(''save files'')',...
    'FontSize',18,...
    'FontWeight','bold',...
    'ForegroundColor',[0.247058823529412 0.247058823529412 0.247058823529412],...
    'Position',[68.2000000000001 1.84615384615385 25 3.23076923076923],...
    'String','Save files',...
    'Tag','save files');

% saveas(h1,'MERGEAO_GUI.fig');

%%%%%%%%%%%%% Functions

function ChangeFileName(src, ~, h_fileName)
fileName = get(h_fileName,'String');
c_pos = find(fileName == 'c', 1);
r_pos = find(fileName == 'r',1);
dot_pos = find(fileName=='.',1);

if ~isempty(dot_pos) 
    fileName = fileName(1:dot_pos-1); 
end

if ~isempty(c_pos) && ~isempty(r_pos)
    switch get(src,'string')
        case '+c'
            value = str2double(fileName(c_pos+1:r_pos-1)) + 1;
            fileName = [fileName(1:c_pos) num2str(value) 'r1'];
        case '-c'
            value = str2double(fileName(c_pos+1:r_pos-1));
            value = value - 1 * (value~=1);
            fileName = [fileName(1:c_pos) num2str(value) 'r1'];
        case '+r'
            value = str2double(fileName(r_pos+1:end)) + 1;
            fileName = [fileName(1:r_pos) num2str(value)];
        case '-r'
            value = str2double(fileName(r_pos+1:end));
            value = value - 1 * (value~=1);
            fileName = [fileName(1:r_pos) num2str(value)];
    end
    
    if ~isempty(dot_pos) fileName = [fileName '.htb']; end
    set(h_fileName,'String',fileName);
    
end


function BrowseOpen(src,~,monkeys,hMonkey,h_fileName,h_pathName,hSavePath)

filename = get(h_fileName,'string');
pathname = ['Z:\Data\MOOG\',monkeys{get(hMonkey,'value')},'\raw\LA\',filename,'\'];
% PATH = get(h_pathName, 'String');
fname = uigetdir(pathname,'Select the directory');
if (fname ~= 0)
    set(h_pathName, 'String', fname);
    set(hSavePath, 'String', fname); % Set save path the same as the file open path
end

function FileSave(src,~,hSavePath)

PATH = get(hSavePath, 'String');
fname = uigetdir(PATH,'Select the directory you want to save the files');
if (fname ~= 0)
    set(hSavePath, 'String', fname); % Set the new save path 
end


function ChangeDataPath(src,~,h_fileName, h_pathName)

fileNametemp = get(h_fileName,'string');
set(h_pathName,'string',['Z:\Data\MOOG\',monkeys{get(hMonkey,'value')},'\raw\LA\',fileNametemp,'\']);

function ChangeSavePath(src,~)

filePath = get(h_pathName,'string');
set(hSavePath,'string',filePath);

%{
function LoadData(src,~,h_pathName,h_fileName)

global ori_data;

pathname = get(h_pathName,'string');
cellname = get(h_fileName,'string');
filename = dir([pathname,'\*.mat']);
disp(['Loading spike data of ', cellname, '...']);

for fs = 1:length(filename)
    % load spike data
    data{fs} = load([pathname '\' filename(fs).name]);
end

function ShowInfo(src,~,h_pathName,h_fileName)

chName = {'001','002','003','004','005','006','007','008','009','010','011','012','013','014','015','016',...
    '017','018','019','020','021','022','023','024','025','026','027','028','029','030','031','032'};

global ori_data output;

output = [];

for ch = 1:chN
    tempSPK = [];
    eval(['tempSR = ori_data{1}.CSPK_',chName{ch},'.KHz * 1000;']);
    % tempSR = temp{1}.CSPK_001.KHz * 1000;
    
    % save all infos into output
    output.spk{ch} = tempSPK; data = tempSPK; % spike data (voltage)
    output.sr{ch} = tempSR; sr = tempSR; % Sample rate, Hz
    
    % show the infos
end

function MergeAO(src,~,h_pathName,h_fileName)

chName = {'001','002','003','004','005','006','007','008','009','010','011','012','013','014','015','016',...
    '017','018','019','020','021','022','023','024','025','026','027','028','029','030','031','032'};

global ori_data output;

output = [];

for ch = 1:chN
    tempSPK = [];
    for fs = 1:length(filename)
        eval(['tempSPK = [tempSPK, ori_data{',num2str(fs),'}.CSPK_',chName{ch},'.Samples];']);
        % tempSPK = [tempSPK, ori_data{1}.CSPK_001.Samples];
        
    end
    eval(['tempSR = ori_data{1}.CSPK_',chName{ch},'.KHz * 1000;']);
    % tempSR = temp{1}.CSPK_001.KHz * 1000;
    
    % save all infos into output
    output.spk{ch} = tempSPK; data = tempSPK; % spike data (voltage)
    output.sr{ch} = tempSR; sr = tempSR; % Sample rate, Hz
    
    % save files (for wave_clus)
    save([cellname, '_ch', chName{ch}, '.mat'],'data','sr');
    % m5c1665r1_ch001.mat
end

function SaveFiles(src,~,h_pathName,h_fileName)

disp(['All saved! ',num2str(chN),' channels in total!']);

%}