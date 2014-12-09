function GUI_FREQ_EigCal_Eigenvalues_calculation(varargin)
% This function is used to calculate the eigenvalues
hObject = varargin{1};
handles = guidata(hObject);
global CI
% ------------------------split the scan domain and contour domain --------
%
GUI_FREQ_EigCal_Scan_domain_Contour_domain_splitting
%
% ------------------------Initialize some nonlinear parameters --------
%
Fcn_Para_initialization
%
% -------------------------% calculation depend on nonlinearities----------
% 
switch CI.EIG.APP_style
    case {11,12}  
        Fcn_calculation_APP_1(hObject)
    case {21,22}                             % nonlinear flame model
        Fcn_calculation_APP_2(hObject)
end
handles = guidata(hObject);
guidata(hObject, handles);
set(handles.pop_numMode,        'enable','on');  
set(handles.pop_PlotType,       'enable','on');
set(handles.pb_AOC_Plot,        'enable','on');
set(handles.pb_AOC_SaveFig,     'enable','on');
set(handles.pb_AOC_OK,          'enable','on');
% --
eigenvalue = CI.EIG.Scan.EigValCol{1};
for k = 1:length(eigenvalue)
   StringMode{k} = ['Mode number: ' num2str(k)]; 
end
set(handles.pop_numMode,    'string',StringMode);
%
guidata(hObject, handles);
%
% -------------------------------------------------------------------------
%
function Fcn_calculation_APP_1(varargin)
% CI.EIG.APP_style = {11, 12} 
% linear
hObject = varargin{1};
handles = guidata(hObject);
global CI
hWaitBar = waitbar(0,'The calculation may take several minutes, please wait...');
for ss =1:CI.EIG.FDF.uRatioNum    
    CI.EIG.Scan.EigValCol{ss}   = Fcn_calculation_eigenvalues(1);
    CI.EIG.Cont.ValCol{ss}      = Fcn_calculation_contour(1);
    waitbar(ss/CI.EIG.FDF.uRatioNum);
    drawnow
end
close(hWaitBar)
% ---------------update the table---------------
data_num(:,1)   = abs(imag(CI.EIG.Scan.EigValCol{1})./2./pi);
data_num(:,2)   = real(CI.EIG.Scan.EigValCol{1});
data_cell       = num2cell(data_num);
set(handles.uitable,'data',data_cell);         % Update the table
% ---------------update the table---------------
% ---------------update popup plot -------------
 set(handles.pop_PlotType,...
                'string',{'Map of eigenvalues';'Modeshape'},...
                'enable','on'); 
% ---------------update popup plot -------------
assignin('base','CI',CI);
guidata(hObject, handles);
% -------------------------------------------------------------------------
%
function Fcn_calculation_APP_2(varargin)
% CI.EIG.APP_style = {21, 22} 
% nonlinear
hObject = varargin{1};
handles = guidata(hObject);
global CI
global FDF
% -----------------------get flame describing function --------------------
%
if  CI.indexFM == 0      % From flame model
    uRatioMin           = str2double(get(handles.edit_uRatio_min,'string'));
    uRatioMax           = str2double(get(handles.edit_uRatio_max,'string'));
    uRatioNum           = str2double(get(handles.edit_uRatio_SampNum,'string'));
    CI.EIG.FDF.uRatioSp = linspace(uRatioMin,uRatioMax,uRatioNum);
    switch CI.FM.NL.style
    case 1
        for ss = 1:uRatioNum
            CI.EIG.FDF.num{ss}   = CI.FM.FTF.num;
            CI.EIG.FDF.den{ss}   = CI.FM.FTF.den;
            CI.EIG.FDF.tauf(ss)  = CI.FM.FTF.tauf;     
        end  
    case 2
        for ss = 1:uRatioNum
            CI.EIG.FDF.num{ss}   = CI.FM.FTF.num;
            CI.EIG.FDF.den{ss}   = CI.FM.FTF.den;
            CI.EIG.FDF.tauf(ss)  = CI.FM.FTF.tauf;     
            % something must be done to include the nonlinear in the Fcn_DetEqn.m
        end  
    case 3      
        CI.EIG.FDF.Lf       = interp1(  CI.FM.NL.Model3.uRatio,...
                                        CI.FM.NL.Model3.Lf,...
                                        CI.EIG.FDF.uRatioSp,'linear','extrap');         % Nonlinear ratio
        CI.EIG.FDF.taufNSp  = CI.FM.NL.Model3.taufN.*(1-CI.EIG.FDF.Lf);                % Nonlinear time delay
        for ss = 1:uRatioNum
            CI.EIG.FDF.num{ss}   = CI.EIG.FDF.Lf(ss).*CI.FM.FTF.num;
            CI.EIG.FDF.den{ss}   = CI.FM.FTF.den;
            CI.EIG.FDF.tauf(ss)  = CI.FM.FTF.tauf + CI.EIG.FDF.taufNSp(ss);     % Time delay of the FDF model
        end    
    end
elseif CI.indexFM == 1  % From experimental FDF
    CI.EIG.FDF.uRatioSp = CI.FMEXP.uRatio;
    uRatioNum = length(CI.EIG.FDF.uRatioSp);
    for ss = 1:uRatioNum
        FTF = CI.FMEXP.FTF{ss};
        CI.EIG.FDF.num{ss}  = FTF.num;
        CI.EIG.FDF.den{ss}  = FTF.den;
        CI.EIG.FDF.tauf(ss) =-FTF.tau_correction;  % Be careful: we always use a = a0 exp(-a*tau)
    end
end
CI.EIG.FDF.uRatioNum = uRatioNum;
assignin('base','CI',CI);
%
% ---------------calculate the eigenvalues---------------
%
hWaitBar = waitbar(0,'The calculation may take several minutes, please wait...');
for ss =1:CI.EIG.FDF.uRatioNum
    FDF.uRatio  = CI.EIG.FDF.uRatioSp(ss);
    FDF.num     = CI.EIG.FDF.num{ss};
    FDF.den     = CI.EIG.FDF.den{ss};
    FDF.tauf    = CI.EIG.FDF.tauf(ss);
    assignin('base','FDF',FDF);
    CI.EIG.Scan.EigValCol{ss}   = Fcn_calculation_eigenvalues(2);
    CI.EIG.Cont.ValCol{ss}      = Fcn_calculation_contour(2);
    waitbar(ss/CI.EIG.FDF.uRatioNum);
    drawnow
end
close(hWaitBar)
assignin('base','CI',CI);
% ---------------update the table---------------
data_num(:,1)   = abs(imag(CI.EIG.Scan.EigValCol{1})./2./pi);
data_num(:,2)   = real(CI.EIG.Scan.EigValCol{1});
data_cell       = num2cell(data_num);
set(handles.uitable,'data',data_cell);         % Update the table
% ---------------update the table---------------
%
% ---------------update the slider---------------
if CI.EIG.FDF.uRatioNum == 1
    set(handles.slider_uRatio,'visible','off')
else
set(handles.slider_uRatio,...
                        'Enable','on',...
                        'min',1,...
                        'max',CI.EIG.FDF.uRatioNum,...
                        'value',1,...
                        'SliderStep',[1/(CI.EIG.FDF.uRatioNum-1), 1/(CI.EIG.FDF.uRatioNum-1)]);
end
set(handles.edit_uRatio,'string',num2str(CI.EIG.FDF.uRatioSp(1)));
% ---------------update the slider---------------
% ---------------update popup plot -------------
set(handles.pop_PlotType,...
                'string',{'Map of eigenvalues';'Modeshape'; 'Evolution of eigenvalue with velocity ratio'},...
                'enable','on'); 
% ---------------update popup plot -------------
guidata(hObject, handles);

%
% -------------------------------------------------------------------------
%
function Fcn_Para_initialization
global CI
CI.EIG.FDF.uRatioNum    = 1;
CI.EIG.FDF.uRatioSp(1)  = 0;
CI.EIG.FDF.num{1}       = [];
CI.EIG.FDF.den{1}       = [];
CI.EIG.FDF.tauf(1)      = 0;
assignin('base','CI',CI);
%
% -------------------------------------------------------------------------
%
