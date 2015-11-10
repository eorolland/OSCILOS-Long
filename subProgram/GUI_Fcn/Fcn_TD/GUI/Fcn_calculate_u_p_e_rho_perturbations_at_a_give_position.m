function [pPrime, uPrime, ePrime, rhoPrime, APlus, AMinus, EPlus, HPwave, HVwave] = Fcn_calculate_u_p_e_rho_perturbations_at_a_give_position(x)
% Calculates the pressure, velocity, entropy, density perturbations as well
% as wave amplitudes at a given combustor position
% Created 2015-11-03 by Erwan Rollan(eor21@cam.ac.uk)
global CI
% x is the input location. It is confirmed that x is inside the chamber.
% Firstly, we need to check which section it is in.

temp = find(CI.CD.x_sample >= x);
indexSection = temp(1)-1;
if x == CI.CD.x_sample(1)
    indexSection = 1; % First section
end


tauPlus     = (x-CI.CD.x_sample(indexSection))./(CI.TP.c_mean(1,indexSection) + CI.TP.u_mean(1,indexSection));
tauMinus    = (CI.CD.x_sample(indexSection+1) - x)./(CI.TP.c_mean(1,indexSection) - CI.TP.u_mean(1,indexSection));
tauc        = (x-CI.CD.x_sample(indexSection))./(CI.TP.u_mean(1,indexSection));
Var         = [CI.TD.nPadding+1,CI.TD.nTotal];
APlus       = Fcn_interp1_varied_td(CI.TD.AP(indexSection,:),Var,tauPlus,CI.TD.dt);
AMinus      = Fcn_interp1_varied_td(CI.TD.AM(indexSection,:),Var,tauMinus,CI.TD.dt);
HPwave      = Fcn_interp1_varied_td(CI.TD.HP(indexSection,:),Var,tauc,CI.TD.dt);
HVwave      = Fcn_interp1_varied_td(CI.TD.HV(indexSection,:),Var,tauc,CI.TD.dt);
EPlus       = Fcn_interp1_varied_td(CI.TD.E(indexSection,:),Var,tauc,CI.TD.dt);
pPrime      = APlus + AMinus + HPwave; % Pressure fluct (Pa)
uPrime      = (APlus - AMinus + HVwave)./(CI.TP.c_mean(1,indexSection).*CI.TP.rho_mean(1,indexSection)); % Velocity fluct (m/s)
ePrime1      = EPlus/(CI.TP.p_mean(1,indexSection)*CI.TP.gamma(1,indexSection)); % Entropy fluct (s'/Cp) % Changed from gamma squared
ePrime      = (exp(ePrime1)-1)*CI.TP.T_mean(1,indexSection); % Entropy fluct (K)
rhoPrime= (1/CI.TP.c_mean(1,indexSection)^2)*(APlus+AMinus-EPlus);

end