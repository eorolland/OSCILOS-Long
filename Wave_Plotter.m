%% My calulation and plotting script
set(0,'DefaultAxesXGrid','on','DefaultAxesYGrid','on')
%for x=0:0.2:1 % Axial locations
xarray=[-200 -90 100 1150 2100]/1000; % DLR Geometry
% xarray=[0 0.67 0.71 0.9 1.2];
xnum=length(xarray);

%% Obtianing axes limits
clear pM uM eM PM MM
for index=1:xnum
    x=xarray(index);
    [pPrime, uPrime, ePrime,rhoPrime, APlus, AMinus, EPlus] = Fcn_calculate_u_p_e_rho_perturbations_at_a_give_position(x); % Calculates the fluctuations
    pM(index)=max([abs(max(pPrime)) abs(min(pPrime))]);
    eM(index)=max([abs(max(ePrime)) abs(min(ePrime))]);
    uM(index)=max([abs(max(uPrime)) abs(min(uPrime))]);    
    rM(index)=max([abs(max(rhoPrime)) abs(min(rhoPrime))]);
    PM(index)=max([abs(max(APlus)) abs(min(APlus))]);
    MM(index)=max([abs(max(AMinus)) abs(min(AMinus))]);
    EM(index)=max([abs(max(EPlus)) abs(min(EPlus))]);
end

ylimp=[-max(pM) max(pM)];
ylime=[-max(eM) max(eM)];
ylimu=[-max(uM) max(uM)];
ylimr=[-max(rM) max(rM)];
ylimAPlus=[-max(PM) max(PM)];
ylimAMinus=[-max(MM) max(MM)];
ylimEPlus=[-max(EM) max(EM)];
xlimit=[CI.TD.tSp(1) CI.TD.tSpTotal(end)];


%% Calculating Quantities and Plotting
for index=1:xnum
    x=xarray(index);
    
% 1 : Calculate quantities of interest
[pPrime, uPrime, ePrime, rhoPrime, APlus, AMinus, EPlus] = Fcn_calculate_u_p_e_rho_perturbations_at_a_give_position(x); % Calculates the fluctuations

% 2. Plot the Waves used to calculate results
figure(1)
hfig1=figure(1);
set(hfig1,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); 
set(hfig1,'color',[0.99 1 1])

subplot(3,xnum,index)
plot(CI.TD.tSp,EPlus,'Color','r','LineWidth',1) % Plotting the entropy wave in time
title(strcat('Position:' , num2str(x), ' m'))
xlabel('Time (s)')
ylabel('E Plus (Entropy Wave) (Pa)')
ylim(ylimEPlus+[-1 1])
xlim(xlimit)

subplot(3,xnum,index+xnum)
plot(CI.TD.tSp,APlus,'Color','blue','LineWidth',1) % Plotting the forward wave
title(strcat('Position:' , num2str(x), ' m'))
xlabel('Time (s)')
ylabel('APlus (Forward Wave) (Pa)')
ylim(ylimAPlus+[-1 1])
xlim(xlimit)

subplot(3,xnum,index+2*xnum)
plot(CI.TD.tSp,AMinus,'Color','blue','LineWidth',1) % Plotting the backward wave in time
title(strcat('Position:' , num2str(x), ' m'))
xlabel('Time (s)')
ylabel('A Minus (Backward Wave) (Pa)')
ylim(ylimAMinus+[-1 1])
xlim(xlimit)

% 2 Plotting the results obtained from the waves

figure(2)
hfig2=figure(2);
set(hfig2,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); 
set(hfig2,'color',[1 0.99 1])

subplot(4,xnum,index)
plot(CI.TD.tSp,ePrime,'Color','red','LineWidth',1) % Plotting the pressure fluct
title(strcat('Position:' , num2str(x), ' m'))
xlabel('Time (s)')
ylabel('Entropy Fluctuation ePrime (K)')
ylim(ylime+[-1 1])
xlim(xlimit)

subplot(4,xnum,index+xnum)
plot(CI.TD.tSp,pPrime,'Color','black','LineWidth',1) % Plotting the pressure fluct
title(strcat('Position:' , num2str(x), ' m'))
xlabel('Time (s)')
ylabel('Pressure Fluctuation pPrime (Pa)')
ylim(ylimp+[-0.1 0.1])
xlim(xlimit)

subplot(4,xnum,index+2*xnum)
plot(CI.TD.tSp,uPrime,'Color','black','LineWidth',1) % Plotting the pressure fluct
title(strcat('Position:' , num2str(x), ' m'))
xlabel('Time (s)')
ylabel('Velocity Fluctuation uPrime  (m/s)')
ylim(ylimu+[-0.1 0.1])
xlim(xlimit)

subplot(4,xnum,index+3*xnum)
plot(CI.TD.tSp,rhoPrime,'Color','black','LineWidth',1) % Plotting the pressure fluct
title(strcat('Position:' , num2str(x), ' m'))
xlabel('Time (s)')
ylabel('Density Fluctuation rhoPrime  (kg/m3)')
ylim(ylimr+[-0.1 0.1])
xlim(xlimit)

% 
% % 2 Plotting in frequency domain
% subplot(3,2,2)
% plot(ePrimePSDx,ePrimePSDy) % Plotting the entropy wave in freq
% title('Entropy Wave (-)')
% xlabel('Frequency (Hz)')
% ylabel('Power/Frequency (dB/Hz)')
% 
% 
% subplot(3,2,4)
% plot(pPrimePSDx,pPrimePSDy) % Plotting the entropy wave in freq
% title('Pressure Fluctuation')
% xlabel('Frequency (Hz)')
% ylabel('Power/Frequency (dB/Hz)')
% 
% 
% subplot(3,2,6)
% plot(uPrimePSDx,uPrimePSDy) % Plotting the entropy wave in freq
% title('Velocity Fluctuation')
% xlabel('Frequency (Hz)')
% ylabel('Power/Frequency (dB/Hz)')
% 
% figure(21)
% set(gcf,'color','white')
% % 2 Plotting in time domain
% subplot(3,xnum,index)
% plot(CI.TD.tSp,ePrime,'Color','red','LineWidth',1) % Plotting the entropy wave in time
% title(strcat('Position:' , num2str(x), ' m'))
% xlabel('Time (s)')
% ylabel('Entropy Wave TPrime')
% ylim(ylime)
% 
% subplot(3,xnum,index+xnum)
% plot(CI.TD.tSp,pPrime,'Color','black','LineWidth',1) % Plotting the pressure fluct
% title(strcat('Position:' , num2str(x), ' m'))
% xlabel('Time (s)')
% ylabel('Pressure Fluctuation pPrime (Pa)')
% ylim(ylimp)
% 
% subplot(3,xnum,index+2*xnum)
% plot(CI.TD.tSp,uPrime,'Color','b','LineWidth',1) % Plotting the pressure fluct
% title(strcat('Position:' , num2str(x), ' m'))
% xlabel('Time (s)')
% ylabel('Velocity Fluctuation uPrime  (m/s)')
% ylim(ylimu)

end
figure(1)
suptitle('Wave Strengths (Entropy, Acoustic Forward and Backward)')
figure(2)
suptitle('Flow Fluctuations (Entropy, Pressure, Velocity)')

% Save the file to a picture
%  export_fig Case1-9interfaces-tstep1e-5-1spl-3Hz-1bar

