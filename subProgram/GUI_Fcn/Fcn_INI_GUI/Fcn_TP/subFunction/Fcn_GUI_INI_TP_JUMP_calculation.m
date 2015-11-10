function Fcn_GUI_INI_TP_JUMP_calculation(varargin)
% This function is used to calculate the Jump Interface Characteristics (for use in
% the Time Domain simulation)
% Created 2015-11-03 by Erwan Rolland(eor21@cam.ac.uk)

hObject     = varargin{1};
handles     = guidata(hObject);
% ----------------------------
global CI


%% 1. Determine the shape of the disturbances generated at the jump interface

CI.TD.JUMP.shape=get(handles.popupmenu_shape,'Value'); % Shape of disturbances generated (1 is pulsed, 2 is sinusoidal, 3 is constant)

% 1.1 Pulse Characteristics
CI.TD.JUMP.tau=str2num(get(handles.edit_JUMP_tau,'string')); % Characteristic time in s
CI.TD.JUMP.t0=str2num(get(handles.edit_JUMP_start_time,'string')); % Pulse start time (in s)
CI.TD.JUMP.Tp=str2num(get(handles.edit_JUMP_ON_time,'string')); % On-time (in s)

% 1.2 Sinusoidal Characterstics
CI.TD.JUMP.f=str2num(get(handles.edit_JUMP_tau,'string')); % Frequency in Hz



%% 2. Determine the amplitude of the disturbaces

CI.TD.JUMP.mass=str2num(get(handles.edit_mass,'string'));
CI.TD.JUMP.momentum=str2num(get(handles.edit_momentum,'string'));
CI.TD.JUMP.enthalpy=str2num(get(handles.edit_enthalpy,'string'));




