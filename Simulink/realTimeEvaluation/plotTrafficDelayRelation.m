%% Plot partial results of a simulation
startingTime=1050; 
endingTime=1300;
startingTimeInstants=startingTime/simulationStepTime;
endingTimeInstants=endingTime/simulationStepTime;
BGVector=zeros((endingTimeInstants-startingTimeInstants)+1,1);
originalBGVector=zeros(endingTimeInstants-startingTimeInstants+1,1);
originalPropagationTime=zeros(endingTimeInstants-startingTimeInstants+1,1);
overallTraffic=zeros((endingTimeInstants-startingTimeInstants)+1,1);

for i=startingTimeInstants:endingTimeInstants
    if(currentLinkVector(i,1)==1)
        BGVector(i-startingTimeInstants+1,1)=valuesLink1Matrix(i,2);
        overallTraffic(i-startingTimeInstants+1,1)=Link1sTraffic(i,2)+P1sTraffic(i,2);
        originalBGVector(i-startingTimeInstants+1,1)=(propagationDelayLink1+rand1(i,1))/1000;
        originalPropagationTime(i-startingTimeInstants+1,1)=propagationDelayLink1/1000;
    else
        BGVector(i-startingTimeInstants+1,1)=valuesLink2Matrix(i,2);
        overallTraffic(i-startingTimeInstants+1,1)=Link2sTraffic(i,2)+P1sTraffic(i,2);
        originalBGVector(i-startingTimeInstants+1,1)=(propagationDelayLink2+rand2(i,1))/1000;
        originalPropagationTime(i-startingTimeInstants+1,1)=propagationDelayLink2/1000;
    end        
end

timeInterval=zeros(endingTimeInstants-startingTimeInstants+1,1);
timeInterval(:,1)=linspace(startingTime,endingTime,endingTimeInstants-startingTimeInstants+1);
if ww==1
    name=channelNoiseBehaviour+" - " + filterType + " with No SD-WAN";
else
    name=channelNoiseBehaviour+" - " + filterType + " with SD-WAN";
end

figure('NumberTitle','off','Name','E2E delay contributions')
yline(link1MaxThreshold,'-r','Linewidth',2)
hold on;
plot(timeInterval(:,1),originalPropagationTime(:,1),'-b','Linewidth',2)
hold on;
plot(timeInterval(:,1),originalBGVector(:,1),'-m','Linewidth',2)
hold on;
plot(timeInterval(:,1),BGVector(:,1),'-g')
 xlabel('Simulation time (s)')
ylabel('E2E delay (s)');
grid on; 
grid minor;
legend('Max E2E delay threshold for VOIP','A','A+B','A+B+C','Location','northwest')

figure('Name',name,'NumberTitle','off');
subplot(4,1,1)
    plot(timeInterval(:,1),overallTraffic(:,1),'r-*');
    title('Current P1+BG Traffic ');
    grid on; 
    grid minor;
    xlim([startingTime-10, endingTime+10]);
    xlabel('Simulation time (s)')
    ylabel('Bytes');
    ylim([min(overallTraffic)-10 max(overallTraffic)+1000]);
subplot(4,1,2)    
    plot(timeInterval(:,1),BGVector(:,1),'g');
    hold on;
    plot(timeInterval(:,1),originalBGVector(:,1),'y');
    hold on;
    yline(link1MaxThreshold,'-r','Max VOIP E2E delay')    
    title('E2E delay')
    legend('A+B+C','A+B');
    grid on; 
    grid minor;
    xlim([startingTime-10, endingTime+10]);
    xlabel('Simulation time (s)')
    ylabel('seconds');
    ylim([min(BGVector) max(max(BGVector),link1MaxThreshold)+simulationStepTime]);
subplot(4,1,3)
    plot(timeInterval(:,1),averageQueueingTimeVector(startingTimeInstants:endingTimeInstants,1),'m-o');
    title('Average queueing time P1+BG ');
    grid on; 
    grid minor;
    xlim([startingTime-10, endingTime+10]);
    xlabel('Simulation time (s)')
    ylabel('seconds');
    ylim([min(averageQueueingTimeVector) max(averageQueueingTimeVector)+simulationStepTime]);
subplot(4,1,4)
    plot(timeInterval(:,1),currentlySentPacketsArray(startingTimeInstants:endingTimeInstants,1),'b-o');
    title('Delivered packets');
    grid on; 
    grid minor;
    xlim([startingTime-10, endingTime+10]);
    xlabel('Simulation time (s)')
    ylabel('Number of packets');
    ylim([-0.5 max(currentlySentPacketsArray)+1]);
    