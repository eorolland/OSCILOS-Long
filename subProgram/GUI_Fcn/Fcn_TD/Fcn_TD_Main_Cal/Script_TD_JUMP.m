%% Script_TD_JUMP

% Created 2015-11-03 by Erwan Rollan(eor21@cam.ac.uk)


%% 1. Determining the jump terms at the interface at this time step
% Euler Equation 1: Mass
MassTerm=CI.TD.JUMP.massprofile(Var(1)); % Must be divided by rho*u wrt to Euler eqs.
% Euler Equation 2: Momentum
MomentumTerm=CI.TD.JUMP.momentumprofile(Var(1)); % Must be divided by rho*u^2 wrt to Euler eqs.
% Euler Equation 3: Energy
EnthalpyTerm= CI.TD.JUMP.enthalpyprofile(Var(1)); % Must be divided by rho*u wrt to Euler eqs.

% Additional term in matrix form
FTerm      =[MassTerm; MomentumTerm; EnthalpyTerm]; % This is the additional term (scaled)


%% 2. Calculating the outgoing acoustic and entropy waves
x = (CI.TD.EWG.X2\CI.TD.EWG.X1)*y + gamma2*p2*(CI.TD.EWG.X2\FTerm);

