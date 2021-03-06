function Fcn_Interface_location
global CI
% This function is used to locate the required interfaces
%
% first created: 2014-12-03
% last modified: 2014-12-08
% author: Jingxuan Li (jingxuan.li@imperial.ac.uk)
%
disp('Running Interface Location')
CI.CD.indexHA     = find(CI.CD.SectionIndex == 10 | CI.CD.SectionIndex == 11);           % heat addition
CI.CD.indexHP     = find(CI.CD.SectionIndex == 11);                                      % heat perturbations
CI.CD.indexLiner  = find(CI.CD.SectionIndex == 30);                                      % left side of a liner
CI.CD.indexHR = find(CI.CD.SectionIndex == 2);                                       % damper
CI.CD.indexEWG = find(CI.CD.SectionIndex == 12);                                    % Entropy Wave generator
CI.CD.indexCN = find(CI.CD.SectionIndex == 1);                                    % Compact Nozzle
CI.CD.indexJUMP = find(CI.CD.SectionIndex == 40);                                    % Compact Nozzle
%
if ~isempty(CI.CD.indexHA) == 1                    % There a type of heat addition
    CI.CD.isHA = 1;                                % with heat addition
else
    CI.CD.isHA = 0;                                % without heat addition
end
if ~isempty(CI.CD.indexHP) == 1                    % There a type of heat perturbation
    CI.CD.isHP = 1;                                % with heat perturbations
else
    CI.CD.isHP = 0;                                % without heat addition
end
if ~isempty(CI.CD.indexLiner) == 1
    CI.CD.isLiner = 1;                             % with liner
else
    CI.CD.isLiner = 0;                             % without liner
end
if ~isempty(CI.CD.indexHR) == 1
    CI.CD.isHR = 1;                            % with dampers
else
    CI.CD.isHR = 0;                            % without damper
end
if ~isempty(CI.CD.indexEWG) == 1
    CI.CD.isEWG = 1;                            % with EWG
else
    CI.CD.isEWG = 0;                            % without EWG
end

if ~isempty(CI.CD.indexCN) == 1
    CI.CD.isCN = 1;                            % with EWG
else
    CI.CD.isCN = 0;                            % without EWG
end

if ~isempty(CI.CD.indexJUMP) == 1
    CI.CD.isJUMP = 1;                            % with EWG
else
    CI.CD.isJUMP = 0;                            % without EWG
end
%
assignin('base','CI',CI);
%
% -------------------------------end---------------------------------------