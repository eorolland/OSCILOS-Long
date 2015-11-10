function Fcn_TD_INI_JUMP
% This function is used to calculate the transfer matrix for the term added at the Jump Interface
% Created 2015-11-03 by Erwan Rollan(eor21@cam.ac.uk)
%
global CI

if isempty(CI.CD.indexJUMP)==1 % There is no Jump Interface
    return
end

ss=find(CI.CD.SectionIndex==40); % The section is the one at which there is an Jump Interface

%% 1. Defining Required Quantities
cRatio  = CI.TP.c_mean(1,ss)./CI.TP.c_mean(2,ss);
c1  = CI.TP.c_mean(1,ss-1);
c2  = CI.TP.c_mean(1,ss);
M1      = CI.TP.M_mean(1,ss-1);
M2      = CI.TP.M_mean(1,ss);
gamma1  = CI.TP.gamma(1,ss-1);
gamma2  = CI.TP.gamma(1,ss);
p2=CI.TP.p_mean(1,ss);
rho2=CI.TP.rho_mean(1,ss);
T1=CI.TP.T_mean(1,ss-1);
T2=CI.TP.T_mean(1,ss);
Cp=CI.TP.Cp(1,ss);
u1=CI.TP.u_mean(1,ss-1);
u2=CI.TP.u_mean(1,ss);
H2=Cp*T2+0.5*u2*u2;


%%  2. Generates the disturbance profile corresponding to the jump interface
Phi=zeros(1,length(CI.TD.tSpTotal)); % Initialisation of the disturbance profile

switch CI.TD.JUMP.shape
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
        
        
    case 2 % Sinusoidal waves are generated
        f=3;
        Phi = sin(2*pi*f.*(CI.TD.tSpTotal));
        
    case 3 % Constant perturbation
        Phi=ones(1,length(CI.TD.tSpTotal));        
end


CI.TD.JUMP.massprofile =CI.TD.JUMP.mass.*Phi;
CI.TD.JUMP.momentumprofile =CI.TD.JUMP.momentum.*Phi;
CI.TD.JUMP.enthalpyprofile =CI.TD.JUMP.enthalpy.*Phi;


%% 3. Determing the Linearised Euler Wave Relations (Matrix Form)
% X2 * x = X1 *y + Jump Terms
% Mass flux term normalised by rho*u, momentum flux
% normalised bu rho*u^2 and enthalpy flux normalised by rho*u

X2(1,1) =   1 + (1/M2);
X2(1,2) =   -(1 - (1/M1));
X2(1,3) =   -1;
X2(2,1) =   (1/(M2*M2) + 1 + 2/M2) ;
X2(2,2) =  -(1/(M1*M1) + 1 - 2/M1);
X2(2,3) =   -1;
X2(3,1) =  (Cp*T2*(gamma2 + (1/M2)) + 0.5*u2*u2 +1.5*u2*c2 );
X2(3,2) =  -(Cp*T1*(gamma1 - (1/M1)) + 0.5*u1*u1 -1.5*u1*c1 );
X2(3,3) =  -0.5*u2*u2;

X1(1,1) =   1 + (1/M1);
X1(1,2) =   -(1 - (1/M2));
X1(1,3) =   -1;
X1(2,1) =   (1/(M1*M1) + 1 + 2/M1) ;
X1(2,2) = -(1/(M2*M2) + 1 - 2/M2);
X1(2,3) =   -1;
X1(3,1) =   (Cp*T1*(gamma1 + (1/M1)) + 0.5*u1*u1 +1.5*u1*c1 );
X1(3,2) =   -(Cp*T2*(gamma2 - (1/M2)) + 0.5*u2*u2 -1.5*u2*c2 );
X1(3,3) =  -0.5*u1*u1;

CI.TD.EWG.X2=X2;
CI.TD.EWG.X1=X1;
end





% -----------------------------end-----------------------------------------