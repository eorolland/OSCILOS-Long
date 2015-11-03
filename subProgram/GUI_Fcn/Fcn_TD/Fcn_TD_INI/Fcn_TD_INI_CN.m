function Fcn_TD_INI_CN
% This function is used to calculate the compact nozzle transfer functions
% Created 2015-11-03 by Erwan Rollan(eor21@cam.ac.uk)
%
global CI

if isempty(CI.CD.indexCN)==1 % There is no compact nozzle
return
end

ss=find(CI.CD.SectionIndex==1); % The section is the one at which there is a compact nozzle

CI.TD.CN.type=3; % Type of transfer functions enabled (1 is acoustic-acoustic, 2 is entropic-acoustic, 3 is both)

%% 2. Calculate the relevant transfer functions
% 2.1 Compute relevant mean flow variables
gamma   = CI.TP.gamma(1,ss-1);
M1      = CI.TP.M_mean(1,ss-1); % Mach Number Upstream
M2      = CI.TP.M_mean(1,ss); % Mach number Downstream

% 2.2 Entropic to Acoustic Transfer Functions
% Forward Entropy Wave (Upstream)  --> Backward Acoustic Wave (Upstream)
CI.BC.CN.num1m  = -0.5*M1*(M2-M1);
CI.BC.CN.den1m = (1-M1)*(1+0.5*(gamma-1)*M1*M2);
CI.BC.CN.tau_d1m = 0;
CI.TD.CN.GreensysEntropy1m=tf(CI.BC.CN.num1m,CI.BC.CN.den1m);

% Forward Entropy Wave (Upstream) --> Forward Acoustic Wave (Downstream)
CI.BC.CN.num2p  =  0.5*M2*(M2-M1);
CI.BC.CN.den2p = (1+M2)*(1+0.5*(gamma-1)*M1*M2);
CI.BC.CN.tau_d2p = 0;
CI.TD.CN.GreensysEntropy2p=tf(CI.BC.CN.num2p,CI.BC.CN.den2p);

% 2.3 Acoustic to Acoustic Transfer Functions

% Forward Acoustic Wave (Upstream) --> Backward Acoustic Wave (Upstream)
CI.BC.CN.numP1m  = (M2-M1)*(1+M1)*(1-0.5*(gamma-1)*M1*M2);
CI.BC.CN.denP1m = (1-M1)*(M2+M1)*(1 + 0.5*(gamma-1)*M1*M2);
CI.BC.CN.tau_dP1m = 0;
CI.TD.CN.GreensysEntropyP1m=tf(CI.BC.CN.numP1m,CI.BC.CN.denP1m);

% Forward Acoustic Wave (Upstream) --> Forward Acoustic Wave (Downstream)
CI.BC.CN.numP2p  = (2*M2)*(1+M1)*(1+0.5*(gamma-1)*M2*M2);
CI.BC.CN.denP2p = (1+M2)*(M2+M1)*(1 + 0.5*(gamma-1)*M1*M2);
CI.BC.CN.tau_dP2p = 0;
CI.TD.CN.GreensysEntropyP2p=tf(CI.BC.CN.numP2p,CI.BC.CN.denP2p);

% Backward Acoustic Wave (Downstream) --> Forward Acoustic Wave (Downstream)
CI.BC.CN.numP1mu  = (2*M1)*(1-M2)*(1+0.5*(gamma-1)*M1*M1);
CI.BC.CN.denP1mu = (1-M1)*(M2+M1)*(1 + 0.5*(gamma-1)*M1*M2);
CI.BC.CN.tau_dP1mu = 0;
CI.TD.CN.GreensysEntropyP1mu=tf(CI.BC.CN.numP1mu,CI.BC.CN.denP1mu);

% Backward Acoustic Wave (Downstream) --> Backward Acoustic Wave (Upstream)
CI.BC.CN.numP2pu  = (M1-M2)*(1-M2)*(1-0.5*(gamma-1)*M1*M2);
CI.BC.CN.denP2pu = (1+M2)*(M2+M1)*(1 + 0.5*(gamma-1)*M1*M2);
CI.BC.CN.tau_dP2pu = 0;
CI.TD.CN.GreensysEntropyP2pu=tf(CI.BC.CN.numP2pu,CI.BC.CN.denP2pu);






% -----------------------------end-----------------------------------------