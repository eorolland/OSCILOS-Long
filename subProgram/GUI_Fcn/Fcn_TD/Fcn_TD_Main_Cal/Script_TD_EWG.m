Script_TD_EWG
% Makes the interface behave as a compact entropy wave generator (EWG)- a
% heating grid with a time-dependent behaviour, which generates entropic
% and acoustic disturbances
% Created 2015-11-03 by Erwan Rollan(eor21@cam.ac.uk)

%% 1. Retrive temperature fluctuation due to EWG at current time step
Tprime=CI.TD.EWG.Tprofile(Var(1))-CI.TP.T_mean(2,ss+1); % Current temperature fluctuation at the EWG at the current time step

%% 2. Calculate the  corresponding disturbances generated, and add to current values

% CI.TD.AP(ss+1, Var(1):Var(2)) = CI.TD.AP(ss+1, Var(1):Var(2)) +  Tprime*CI.TD.EWG.APcoeff;  
% CI.TD.AM(ss, Var(1):Var(2)) = CI.TD.AM(ss, Var(1):Var(2))+   Tprime*CI.TD.EWG.AMcoeff;  
% CI.TD.E(ss+1, Var(1):Var(2)) = CI.TD.E(ss+1, Var(1):Var(2)) + Tprime*CI.TD.EWG.Ecoeff;  

x(1,:) = y(1,1:CI.TD.nGap) +  Tprime*CI.TD.EWG.APcoeff;  % AP
x(2,:) = y(2,1:CI.TD.nGap)+   Tprime*CI.TD.EWG.AMcoeff;  % AM
x(3,:) = y(3,1:CI.TD.nGap) + Tprime*CI.TD.EWG.Ecoeff;    % E
