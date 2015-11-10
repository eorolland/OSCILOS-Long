function Fcn_GUI_INI_TP_EWG_calculation(varargin)
% This function is used to calculate the EWG Characteristics (for use in
% the Time Domain simulation)
% Created 2015-11-03 by Erwan Rollan(eor21@cam.ac.uk)

hObject     = varargin{1};
handles     = guidata(hObject);
% ----------------------------
global CI

%% Script_TD_INI_EWG
% Makes the interface behave as a compact entropy wave generator (EWG)- a
% heating grid with a time-dependent behaviour, which generates entropic
% and acoustic disturbances

%% 1. Select the position of the EWG, and the types of disturbances it generates

% CI.TD.EWG.type=str2num(get(handles.pop_EWG_type,'string')); % Type of distrubances generated  (1 is acoustic, 2 is entropic, 3 is both)
%

CI.TD.EWG.shape=get(handles.pop_EWG_type,'Value'); % Shape of disturbances generated (1 is pulsed, 2 is sinusoidal)

%% 2. Select the parameters defining the EWG behaviour
% 2.1 Amplitude
CI.TD.EWG.Tprime=str2num(get(handles.edit_EWG_amp,'string')); % Maximum temperature fluctuation induced

% 2.2 Sinusoidal characteristics
CI.TD.EWG.f=str2num(get(handles.edit_EWG_tau,'string')); % Frequency in Hz

% 2.2 Pulse characteristics

CI.TD.EWG.tau=str2num(get(handles.edit_EWG_tau,'string')); % Characteristic time in s
CI.TD.EWG.t0=str2num(get(handles.edit_EWG_start_time,'string')); % Pulse start time (in s)
CI.TD.EWG.Tp=str2num(get(handles.edit_EWG_ON_time,'string')); % On-time (in s)



