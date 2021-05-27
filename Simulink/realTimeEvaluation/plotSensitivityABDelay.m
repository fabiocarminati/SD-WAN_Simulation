%% plotSensitivityABDelay
if ww==1
    name=" with No SD-WAN--"+channelNoiseBehaviour+" - " + filterType;
else
    name=" with SD-WAN--"+channelNoiseBehaviour+" - " + filterType;
end

figure('Name',"Link1"+name,'NumberTitle','off')
    yline(propagationDelayLink1/1000,'-g');
    hold on;
    plot(time,valuesLink1Matrix(:,2))
    legend('E2E-A','E2E-A+B','Location','northwest');
    xlabel('Simulation time (s)')
    ylabel('seconds')
    grid on;
    grid minor;
           
figure('Name',"Link2"+name,'NumberTitle','off')
    plot(time,valuesLink2Matrix(:,2))
    yline(propagationDelayLink2/1000,'-g');
    yline(0.05,'--','0.1s','LabelVerticalAlignment','bottom');
    yline(0.1,'--','0.05s');
    yline(0.15,'--r','Max E2E delay threshold');
    legend('E2E delay-Path2-A+B','E2E delay-Path2-A','Location','northwest');
    xlabel('Simulation time (s)')
    ylabel('seconds')
    grid on;
    grid minor;