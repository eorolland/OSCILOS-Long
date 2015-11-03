function Fcn_TD_INI_EWG
% This function is used to calculate the EWG behaviour
% Created 2015-11-03 by Erwan Rollan(eor21@cam.ac.uk)
%
global CI

if isempty(CI.CD.indexEWG)==1 % There is no Entropy Wave Generator
return
end


ss=find(CI.CD.SectionIndex==12); % The section is the one at which there is an EWG
%%  Generates the temperature profile corresponding to the EWG behavioue

switch CI.TD.EWG.shape
    case 1 % A pulse is generated
        t=CI.TD.tSpTotal;
        for i=1:length(t) % Cycles over each time point
            if  (CI.TD.EWG.t0<=t(i)) && (t(i)<CI.TD.EWG.t0+CI.TD.EWG.Tp)
                Phi(i)=1-exp(-(t(i)-CI.TD.EWG.t0)/CI.TD.EWG.tau);
                
            end
            if (CI.TD.EWG.t0+CI.TD.EWG.Tp<=t(i))  && t(i)<= CI.TD.tSpTotal(end) % added for looping
                Phi(i)=exp(-(t(i)-CI.TD.EWG.t0-CI.TD.EWG.Tp)/CI.TD.EWG.tau);
            end
        end
        
        CI.TD.EWG.Tprofile=CI.TP.T_mean(2,ss+1)+(CI.TD.EWG.Tprime.*Phi);
        
    case 2 % Sinusoidal waves are generated
        
        CI.TD.EWG.Tprofile = CI.TP.T_mean(2,ss+1) + CI.TD.EWG.Tprime.*sin(2*pi*f.*(CI.TD.tSpTotal));
        
end
%% 4. Computes the coefficients used to calculate the disturbance amplitudes
% Calculates the coefficient relating the temperature fluctuation induced
% by the EWG to AP, AM and E

gamma  = CI.TP.gamma(1,ss-1); % Gamma (Upstream)
M1     = CI.TP.M_mean(1,ss-1); % Mach Number Upstream
M2     = CI.TP.M_mean(1,ss); % Mach number Downstream
p      = CI.TP.p_mean(1,ss-1); % Mean pressure Upstream
T      = CI.TP.T_mean(1,ss-1); % Mean temperature Upstream

CI.TD.EWG.APcoeff=(0.5*gamma*p*M1/(M1+1))/T;

CI.TD.EWG.AMcoeff=(0.5*gamma*p*M1/(1-M1))/T;

CI.TD.EWG.Ecoeff= (gamma*p)/T;




% -----------------------------end-----------------------------------------