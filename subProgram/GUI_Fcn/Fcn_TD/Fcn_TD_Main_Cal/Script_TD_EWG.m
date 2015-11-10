%% Script_TD_EWG
% Makes the interface behave as a compact entropy wave generator (EWG)- a
% heating grid with a time-dependent behaviour, which generates entropic
% and acoustic disturbances
% Created 2015-11-03 by Erwan Rollan(eor21@cam.ac.uk)
global CI
%% 1. Retrive temperature fluctuation due to EWG at current time step
Tprime=pulse*30;
% Tprime=CI.TD.EWG.Tprofile(Var(1))-CI.TP.T_mean(2,ss+1); % Current temperature fluctuation at the EWG at the current time step

%% Coefficients
gamma  = CI.TP.gamma(1,ss); % Gamma (Upstream)
M1     = CI.TP.M_mean(1,ss); % Mach Number Upstream
M2     = CI.TP.M_mean(1,ss+1); % Mach number Downstream
p      = CI.TP.p_mean(1,ss); % Mean pressure Upstream
T      = CI.TP.T_mean(1,ss); % Mean temperature Upstream

CI.TD.EWG.APcoeff=(0.5*gamma*p*M1/(M1+1))/T;

CI.TD.EWG.AMcoeff=(0.5*gamma*p*M1/(1-M1))/T;

CI.TD.EWG.Ecoeff= (gamma*p)/T;
%% 2. Calculate the  corresponding disturbances generated, and add to current values

x(1,:) = y(1,1:CI.TD.nGap) +  Tprime*CI.TD.EWG.APcoeff;  % AP
x(2,:) = y(2,1:CI.TD.nGap)+   Tprime*CI.TD.EWG.AMcoeff;  % AM
x(3,:) = y(3,1:CI.TD.nGap) + Tprime*CI.TD.EWG.Ecoeff;    % E
