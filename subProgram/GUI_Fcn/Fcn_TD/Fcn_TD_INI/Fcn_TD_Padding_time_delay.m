function tauPadding = Fcn_TD_Padding_time_delay
% This function is used to calculate the minimum padding time delay
global CI
% --------------------------------
% Convection time of the acoustic waves in different sections
tauPadding      = max(  max(CI.TP.tau_plus),...
                        max(CI.TP.tau_minus));
tauPadding      = max(tauPadding,max(CI.TP.tau_c));
%
% --------------------------------
% Boundary condition
% Inlet boundary:
tauPadding = max(tauPadding, CI.TP.tau_minus(1) + CI.BC.tau_d1);
% Outlet boundary:
tauPadding = max(tauPadding, CI.TP.tau_plus(1)  + CI.BC.tau_d2);
%
% --------------------------------
switch CI.FM.NL.style
    case 3
        % Flame describing function
% Herein, we only use the flame describing function model proposed by J.LI
% and A.Morgans JSV
% We must define a maximum velocity ratio value
        uRatioLimit     = [0 1];
        LfLimit         = interp1(  CI.FM.NL.Model3.uRatio,...
                                    CI.FM.NL.Model3.Lf,...
                                    uRatioLimit,'linear','extrap');
        taufNLimit      = CI.FM.NL.Model3.taufN.*(1 - LfLimit);
        taufLimit       = CI.FM.FTF.tauf + taufNLimit;
    case 4
        taufNLimit      = 0;
        taufLimit = CI.FM.NL.Model4.tau_f + taufNLimit;
    otherwise
        taufNLimit      = 0;
        taufLimit       = CI.FM.FTF.tauf + taufNLimit;
end

tauPadding      = max(tauPadding, max(taufLimit));

%
% ------------------------ end --------------------------------------------
