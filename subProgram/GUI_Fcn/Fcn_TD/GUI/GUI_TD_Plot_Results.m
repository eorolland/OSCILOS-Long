function varargout = GUI_TD_Plot_Results(varargin)
% GUI_TD_Plot_Results MATLAB code for GUI_TD_Plot_Results.fig
%      GUI_TD_Plot_Results, by itself, creates a new GUI_TD_Plot_Results or raises the existing
%      singleton*.
%
%      H = GUI_TD_Plot_Results returns the handle to a new GUI_TD_Plot_Results or the handle to
%      the existing singleton*.
%
%      GUI_TD_Plot_Results('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_TD_Plot_Results.M with the given input arguments.
%
%      GUI_TD_Plot_Results('Property','Value',...) creates a new GUI_TD_Plot_Results or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_TD_Plot_Results_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_TD_Plot_Results_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_TD_Plot_Results

% Last Modified by GUIDE v2.5 16-Dec-2014 09:34:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_TD_Plot_Results_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_TD_Plot_Results_OutputFcn, ...
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
%
% -------------------------------------------------------------------------
%          
% --- Executes just before GUI_TD_Plot_Results is made visible.
function GUI_TD_Plot_Results_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_TD_Plot_Results (see VARARGIN)
indexEdit = 1;
switch indexEdit 
    case 0
        %--------------------------------------------------------------------------
        dontOpen = false;
        mainGuiInput = find(strcmp(varargin, 'OSCILOS_long'));
        if (isempty(mainGuiInput)) ...
            || (length(varargin) <= mainGuiInput) ...
            || (~ishandle(varargin{mainGuiInput+1}))
            dontOpen = true;
        else % load from the main GUI
            % handles of main GUI
            handles.MainGUI = varargin{mainGuiInput+1};
            try
                handles.ExampleGUI = varargin{mainGuiInput+2};
            catch
            end
            % Obtain handles using GUIDATA with the caller's handle 
            mainHandles         = guidata(handles.MainGUI);
            % background colors
            handles.bgcolor     = mainHandles.bgcolor;
            % fontsize
            handles.FontSize    = mainHandles.FontSize;
            %
            handles.sW          = mainHandles.sW;
            handles.sH          = mainHandles.sH;
            handles.indexApp    = 0;
            % Update handles structure
            guidata(hObject, handles);
            handles.output = hObject;
            guidata(hObject, handles);
            % Initialization
            GUI_Pannel_Initialization(hObject, eventdata, handles)
        end
        % Update handles structure
        guidata(hObject, handles);
        if dontOpen
           disp('-----------------------------------------------------');
           disp('This is a subprogram. It cannot be run independently.') 
           disp('Please load the program "OSCILOS_long'' from the ')
           disp('parent directory!')
           disp('-----------------------------------------------------');
        end
    case 1
        handles = Fcn_GUI_default_configuration(handles);
        handles.output = hObject;
        guidata(hObject, handles);
        guidata(hObject, handles);  
        GUI_Pannel_Initialization(hObject, eventdata, handles)
end
%
% -------------------------------------------------------------------------
%
function GUI_Pannel_Initialization(varargin)
hObject = varargin{1};
handles = guidata(hObject);
global CI        
%
set(0, 'units', 'points');
screenSize  = get(0, 'ScreenSize');                             % get the screen size
sW          = handles.sW;                                       % screen width
sH          = handles.sH;                                       % screen height
FigW        = sW.*3/4;                                          % window width
FigH        = sH.*1/2;                                          % window height
set(handles.figure,     'units', 'points',...
                        'position',[(screenSize(3)-FigW)./2 (screenSize(4)-FigH)./2 FigW FigH],...
                        'name','Calculation monitor',...
                        'color',handles.bgcolor{3});
%----------------------------------------
% pannel axes
set(handles.uipanel_axes,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[FigW*10.0/20 FigH*0/20 FigW*9.75/20 FigH*19.75/20],...
                        'Title','',...
                        'visible','on',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3});  
pannelsize=get(handles.uipanel_axes,'position');
pW=pannelsize(3);
pH=pannelsize(4);                
set(handles.axes1,      'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*2/10 pH*2.0/10 pW*7.5/10 pH*6.5/10],...
                        'fontsize',handles.FontSize(1),...
                        'color',handles.bgcolor{1},...
                        'box','on');                     
guidata(hObject, handles);
%----------------------------------------
set(handles.uipanel_listbox,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[FigW*0.25/20 FigH*13/20 FigW*9.5/20 FigH*6.75/20],...
                        'Title','',...
                        'visible','on',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3});
pannelsize=get(handles.uipanel_listbox,'position');
pW=pannelsize(3);
pH=pannelsize(4); 
msg={   '<HTML><FONT color="blue">This GUI is used to plot the time domain calculation results;';...
        '<HTML><FONT color="blue">Please select the data type and plot type and then click plot'};
set(handles.listbox,...
                        'units', 'points',...
                        'fontunits','points',...
                        'position',[pW*0/20 pH*0/20 pW*20/20 pH*19.5/20],...
                        'fontsize',handles.FontSize(1),...
                        'string',msg,...
                        'backgroundcolor',handles.bgcolor{4},...
                        'value',1);  
%----------------------------------------
% pannel input
set(handles.uipanel_Select,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[FigW*0.25/20 FigH*2.5/20 FigW*9.5/20 FigH*10.25/20],...
                        'Title','',...
                        'visible','on',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3}); 
pannelsize=get(handles.uipanel_Select,'position');
pW=pannelsize(3);
pH=pannelsize(4);                       
%
set(handles.text1,      'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.5/10 pH*4/10 pW*3/10 pH*1.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Data type:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left',...
                        'visible','on');  
% ------------------------------
str{1} = ['Pressure perturbations'];
str{2} = ['Velocity fluctuations'];
if ~isempty(CI.CD.indexHP)
   numHP = length(CI.FM.indexFM);
   for ss = 1:numHP
      str{2+2*ss-1} = ['uRatio before flame ' num2str(ss)];
      str{2+2*ss}   = ['qRatio of flame ' num2str(ss)];
   end
end
% ------------------------------
                    
set(handles.pop1,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*3.5/10 pH*4/10 pW*6/10 pH*1.75/10],...
                        'fontsize',handles.FontSize(2),...
                        'string', str,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','left',...
                        'enable','on',...
                        'value',1);  
set(handles.text3,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.5/10 pH*7/10 pW*4/10 pH*1.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Axial position [m]:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left',...
                        'visible','on');  
set(handles.edit1,...
                        'units', 'points',...
                        'fontUnits','points',...
                        'position',[pW*5.5/10 pH*7.5/10 pW*4/10 pH*1.25/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',1,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right',...
                        'Enable','on');                    
                    
set(handles.text2,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.5/10 pH*1/10 pW*3/10 pH*1.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Plot type:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left',...
                        'visible','on');                   

set(handles.pop2,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*3.5/10 pH*1/10 pW*6/10 pH*1.75/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',{  'Time evolution';...
                                    'Power spectrum density'},...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','left',...
                        'enable','on',...
                        'value',1);  
%----------------------------------------
% pannel AOC                   
set(handles.uipanel_AOC,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[FigW*0.25/20 FigH*0/20 FigW*9.5/20 FigH*2.25/20],...
                        'Title','',...
                        'visible','on',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3}); 
pannelsize=get(handles.uipanel_AOC,'position');                    
pW=pannelsize(3);
pH=pannelsize(4);                
set(handles.pb_Plot,    'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*1.5/10 pH*2/10 pW*2.5/10 pH*6/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Plot',...
                        'backgroundcolor',handles.bgcolor{3});
set(handles.pb_Cancel,....
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*6/10 pH*2/10 pW*2.5/10 pH*6/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Cancel',...
                        'backgroundcolor',handles.bgcolor{3});
%
guidata(hObject, handles);  
%
% -------------------------------------------------------------------------
%
function Fcn_Plots(varargin)
hObject     = varargin{1};
handles     = guidata(hObject);
hAxes1      = handles.axes1;
fontSize1   = handles.FontSize(1);
global CI
popData     = get(handles.pop1,'Value');   % data type
popPlot     = get(handles.pop2,'Value');   % plot type
x           = str2double(get(handles.edit1,'string'));
if x > CI.CD.x_sample(end) || x < CI.CD.x_sample(1)
    StrWarning = ['The axial position is out of the chamber! Choose a value between '...
        num2str(CI.CD.x_sample(1)) ' m and ' num2str(CI.CD.x_sample(end)) ' m!' ];
    errordlg(StrWarning,'Error');
else
    % ----------------------------------------
    [pPrime, uPrime] = Fcn_calculate_u_p_perturbations_at_a_give_position(x);
    cla(hAxes1)
    axes(hAxes1)
    hold on
    switch popData
        case 1
            ylabelStr = ['$p^\prime $~[Pa]'];
            yData = pPrime;
        case 2
            ylabelStr = ['$u^\prime$~[m/s]'];
            yData = uPrime;
        case {3,5,7,9}
            ylabelStr = ['$\hat{u}/\bar{u}$~[-]'];
            yData = CI.TD.uRatio(1,CI.TD.nPadding+1:CI.TD.nTotal);
        case {4,6,8,10}
            ylabelStr = ['$\hat{\dot{q}}/\bar{\dot{q}}$~[-]'];
            yData = CI.TD.qRatio(1,CI.TD.nPadding+1:CI.TD.nTotal);
    end
    switch popPlot
        case 1  % time evolution
            plot(hAxes1,1*CI.TD.tSp,yData,'-k','linewidth',0.5);
            xlabel(hAxes1,'Time [s]','Color','k','Interpreter','LaTex','FontSize',fontSize1);
            ylabel(hAxes1,ylabelStr,'Color','k','Interpreter','LaTex','FontSize',fontSize1)
        case 2  % psd
            PSD_plot = calculate_psd(yData,CI.TD.fs);
            PSD_plot_noise = calculate_psd(CI.TD.pNoiseBG(CI.TD.nPadding+1:end),CI.TD.fs);
            plot(hAxes1, PSD_plot(1,:),PSD_plot(2,:),'-','color',0*[1 1 1],'Linewidth',0.5);
            xlabel(hAxes1,'$\rm Frequency~[Hz]$','Color','k','Interpreter','LaTex','FontSize',fontSize1);
            ylabel(hAxes1,'$\rm Power/Frequency ~ [dB/Hz]$','Color','k','Interpreter','LaTex','FontSize',fontSize1);
    end
    set(hAxes1,'YColor','k','Box','on','ygrid','on','xgrid','on');
    set(hAxes1,'FontName','Helvetica','FontSize',fontSize1,'LineWidth',1)
    hold off
end

function [pPrime, uPrime] = Fcn_calculate_u_p_perturbations_at_a_give_position(x)
global CI
% x is the input location. It is confirmed that x is inside the chamber.
% Firstly, we need to check which section it is in.

temp = find(CI.CD.x_sample >= x);
indexSection = temp(1)-1;
if x == CI.CD.x_sample(1)
    indexSection = 1;
end
tauPlus     = (x-CI.CD.x_sample(indexSection))./(CI.TP.c_mean(1,indexSection) + CI.TP.u_mean(1,indexSection));
tauMinus    = (CI.CD.x_sample(indexSection+1) - x)./(CI.TP.c_mean(1,indexSection) - CI.TP.u_mean(1,indexSection));
Var         = [CI.TD.nPadding+1,CI.TD.nTotal];
APlus       = Fcn_interp1_varied_td(CI.TD.AP(indexSection,:),Var,tauPlus,CI.TD.dt);
AMinus      = Fcn_interp1_varied_td(CI.TD.AM(indexSection,:),Var,tauMinus,CI.TD.dt);
pPrime      = APlus + AMinus;
uPrime      = (APlus - AMinus)./(CI.TP.c_mean(1,indexSection).*CI.TP.rho_mean(1,indexSection));


function PSD_plot=calculate_psd(xx,Fs)
% the signal xx
%Fs = 1e5;    % this is equal to the inverse of the sample time
nfft = 2^nextpow2(length(xx));
Pxx = abs(fft(xx,nfft)).^2/length(xx)/Fs;
PSD_plot(1,:)=linspace(0,Fs/2,length(Pxx)/2);   % the x axis values for the plot of PSD
PSD_plot(2,:)=10*log10(Pxx(1:length(Pxx)/2));                    % the y axis vaules for the plot of PSD

%
% -------------------------------------------------------------------------
%
function pop1_Callback(hObject, eventdata, handles)
% hObject    handle to pop1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
pop1Val = get(handles.pop1, 'value');
if pop1Val > 2
    set(handles.edit1,'enable','off','visible','off');
    set(handles.text3,'visible','off');
else
    set(handles.edit1,'enable','on','visible','on');
    set(handles.text3,'visible','on');
end
    

% -------------------------------------------------------------------------
%
% --- Outputs from this function are returned to the command line.
function varargout = GUI_TD_Plot_Results_OutputFcn(hObject, eventdata, handles) 
try
varargout{1} = handles.output;
end
%
% -------------------------------------------------------------------------
%
% --- Executes on button press in pb_OK.
function pb_OK_Callback(hObject, eventdata, handles)
% hObject    handle to pb_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Fcn_main_calculation_JLI_AMorgans(hObject)
%
% -------------------------------------------------------------------------
%
% --- Executes on button press in pb_Cancel.
function pb_Cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure);
%
% -------------------------------------------------------------------------
%
% --- Executes on button press in pb_SaveFig.
function pb_SaveFig_Callback(hObject, eventdata, handles)
handles         = guidata(hObject);
Fig             = figure;
copyobj(handles.axes1, Fig);
set(Fig,        'units','points')
posFig          = get(handles.figure,'position');
hAxes           = get(Fig,'children');
set(hAxes(1),       'units','points',...
                    'position',[60 60 400 400],...
                    'ActivePositionProperty','position')
posAxesOuter    = [0 0 500 500];
set(Fig,        'units','points',...
                'position', [   posFig(1)+0.5*posFig(3)-0.5*posAxesOuter(3),...
                                posFig(2)+0.5*posFig(4)-0.5*posAxesOuter(4),...
                                posAxesOuter(3:4)]) 
%
% -------------------------------------------------------------------------
%
% --- Executes during object creation, after setting all properties.
function pop1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
global CI
datEdit = str2double(get(hObject, 'String'));
ValDefault = CI.CD.x_sample(1); 
if isnan(datEdit) || ~isreal(datEdit) 
    set(hObject, 'String', ValDefault);
    errordlg('Input must be a real number','Error');
    % when the input is not a number, it is set to the default value
end
if datEdit < CI.CD.x_sample(1) || datEdit > CI.CD.x_sample(end)
    set(hObject, 'String', ValDefault);
    errordlg('The location must inside the chamber','Error'); 
end


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% -------------------------------------------------------------------------

% --- Executes when user attempts to close figure.
function figure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(hObject);
%

function Fcn_set_ui_enable(hObject,handles,indexValiable)
switch indexValiable
    case 0
        set(handles.pb_Config,      'enable','off');
        set(handles.pb_SaveFig,     'enable','off');
        set(handles.pb_OK,          'enable','off');
        set(handles.pb_Cancel,      'enable','off');
    case 1
        set(handles.pb_Config,      'enable','on');
        set(handles.pb_SaveFig,     'enable','on');
        set(handles.pb_OK,          'enable','on');
        set(handles.pb_Cancel,      'enable','on');
end
% --- Executes during object creation, after setting all properties.
function figure_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in listbox.
function listbox_Callback(hObject, eventdata, handles)
% hObject    handle to listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox


% --- Executes during object creation, after setting all properties.
function listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_Plot.
function pb_Plot_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Fcn_Plots(hObject)

% --- Executes on selection change in pop2.
function pop2_Callback(hObject, eventdata, handles)
% hObject    handle to pop2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop2


% --- Executes during object creation, after setting all properties.
function pop2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function handles = Fcn_GUI_default_configuration(handles)
% This function is used to set the default GUI parameters
handles.bgcolor{1} = [0.95, 0.95, 0.95];
handles.bgcolor{2} = [0, 0, 0];
handles.bgcolor{3} = [.75, .75, .75];
handles.bgcolor{4} = [0.90,0.90,1];
%
handles.sW  = 800;
handles.sH  = 600;
%
if ispc
    handles.FontSize(1)=11;                 % set the default fontsize
    handles.FontSize(2)=9;
else
    handles.FontSize(1)=12;                 % set the default fontsize
    handles.FontSize(2)=10;   
end


% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles         = guidata(hObject);
Fig             = figure;
copyobj(handles.axes1, Fig);
set(Fig,        'units','points')
posFig          = get(handles.figure,'position');
hAxes           = get(Fig,'children');
set(hAxes(1),       'units','points',...
                    'position',[60 60 300 300],...
                    'ActivePositionProperty','position')
posAxesOuter    = [0 0 500 500];
set(Fig,        'units','points',...
                'position', [   posFig(1)+0.5*posFig(3)-0.5*posAxesOuter(3),...
                                posFig(2)+0.5*posFig(4)-0.5*posAxesOuter(4),...
                                posAxesOuter(3:4)]) 

