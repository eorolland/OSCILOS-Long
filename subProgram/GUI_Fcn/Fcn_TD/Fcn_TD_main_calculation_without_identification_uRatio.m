function Fcn_TD_main_calculation_without_identification_uRatio
global CI
%
% --------------------------------------
hWaitBar = waitbar(0,'Time domain calculations, please wait...');
%
%
for nn = 1:CI.TD.nRound
    Var(1:2)     = CI.TD.nPadding + [(nn-1)*CI.TD.nGap + 1,...
                                 nn*CI.TD.nGap];
    
    Fcn_TD_calculation_one_gap(Var)
    waitbar(nn/CI.TD.nRound);
    drawnow
end
close(hWaitBar)
assignin('base','CI',CI);

% --------------------------  PLOT  ---------------------------------------
h=figure
scrsz = get(0,'ScreenSize');
set(h,'Position',[scrsz(4).*(1/8) scrsz(4).*(1/20) scrsz(3)*2/5 scrsz(4).*(4/5)])
%************
hAxes(1)=axes('Unit','pixels','position',[100 80 400 400]);
hold on
plot(CI.TD.tSpTotal,CI.TD.uRatio,'-k','linewidth',0.5)
set(hAxes(1),'YColor','k','Box','on');
set(hAxes(1),'FontName','Helvetica','FontSize',20,'LineWidth',0.5,...
    'xcolor','k','ycolor','k','gridlinestyle','-.')
xlabel(hAxes(1),'Time [s]','Color','k','Interpreter','LaTex','FontSize',20);
ylabel(hAxes(1),'$u^\prime/\bar{u}$ [-]','Color','k','Interpreter','LaTex','FontSize',20);
set(hAxes(1),'xlim',[0 1],'xTick',0:0.2:1,...
    'YAxisLocation','left','Color','w');
grid on
title('evolution of velocity ratio before the flame','interpreter','latex')

% ----------------------------end------------------------------------------