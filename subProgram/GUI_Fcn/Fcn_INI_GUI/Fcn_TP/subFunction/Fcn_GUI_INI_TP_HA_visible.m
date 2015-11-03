function Fcn_GUI_INI_TP_HA_visible(varargin)
% This function is to set the HA panel visible or not
% Modified to set wether the EWG panel is visible or not
% first created: 2014-12-04
% last modified: 2015-11-03
% author: Jingxuan LI (jingxuan.li@imperial.ac.uk)
%
global CI
hObject = varargin{1};
handles = guidata(hObject);
switch CI.CD.isHA
    case 0 
        set(handles.uipanel_HA_style,       'visible', 'off');
        set(handles.uipanel_Heat_Config,    'visible', 'off');
    case 1
        set(handles.uipanel_HA_style,       'visible', 'on');
        set(handles.uipanel_Heat_Config,    'visible', 'on');
end

switch CI.CD.isEWG
        case 0 
        set(handles.uipanel_EWG_Config,    'visible', 'off');
    case 1
        set(handles.uipanel_EWG_Config,    'visible', 'on');
end
guidata(hObject, handles);
%
% -----------------------------end-----------------------------------------