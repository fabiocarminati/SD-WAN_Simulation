%% Pre-define E2E delay as A+B contributions

%% Basic delay contribution A 
propagationDelayLink1=136.36; %ms
propagationDelayLink2=31.36; %ms

%% Define E2E delay thresholds (150ms for VOIP)
link1MaxThreshold=150/1000; 
link2MaxThreshold=link1MaxThreshold;
link1MinThreshold=110/1000; 
link2MinThreshold=link1MinThreshold;

valuesLink1Matrix=zeros(timeInstants+1,2);
valuesLink1Matrix(:,1)=time;
valuesLink2Matrix=zeros(timeInstants+1,2);
valuesLink2Matrix(:,1)=time;


%% Gaussian casual noise contribution
currentlySentPacketsArray=zeros(timeInstants+1,1);

switch typeOfAnalysis
    case 1 %"sensitivity"
        rand1=zeros(timeInstants+1,1);
        radn2=zeros(timeInstants+1,1);
        %% Starting point: white noise
        rng('shuffle','twister');
        rand1=normrnd(0,12,timeInstants+1,1);  
        rng('shuffle','twister');
        rand2=normrnd(0,12,timeInstants+1,1);
    
        switch channelNoiseBehaviour
            case "White noise"                
                fprintf("White noise \n");                 
            case "Low-pass noise"
                lowPassFilteredNoise();
        end
        valuesLink1Matrix(:,2)=propagationDelayLink1+rand1(:,1);
        valuesLink2Matrix(:,2)=propagationDelayLink2+rand2(:,1);
        
        %% Reset statistics
        assignin('base','timeInstantsOfSystemUnavailability',0);
        assignin('base','timeInstantsOfPathUnavailability',0);
        assignin('base','totTrafficP1BG',0);
        linksStatisticsStruct=struct('lostBytes',0,'queueP1',0,'queueBG',0,'sentBytes',0,'sentP1',0);
        linksStatisticsSingle=repmat(linksStatisticsStruct,1,m);                       
        assignin('base','linksStatisticsSingle',linksStatisticsSingle);
        plotSensitivityABDelay();     
        
    case 2 % "convergence"
        switch ww
            case 1 %% Deterministic simulation
                valuesLink1Matrix(:,2)=propagationDelayLink1;
                valuesLink2Matrix(:,2)=propagationDelayLink2;
            case 2 %% Random simulation
                rng('shuffle','twister');
                randomDelayContribution=randn(2*(timeInstants+1),1);
                rand1=zeros(timeInstants+1,1);
                rand1=randomDelayContribution(1:timeInstants+1,1);
                radn2=zeros(timeInstants+1,1);
                rand2=randomDelayContribution(timeInstants+2:2*(timeInstants+1),1);
                valuesLink1Matrix(:,2)=propagationDelayLink1+rand1(:,1);
                valuesLink2Matrix(:,2)=propagationDelayLink1+rand2(:,1);
        end
end

% From ms to seconds
valuesLink1Matrix(:,2)=valuesLink1Matrix(:,2)/1000;
valuesLink2Matrix(:,2)=valuesLink2Matrix(:,2)/1000;
requiredDelayForReRouteLink1=ceil((propagationDelayLink1/1000)/simulationStepTime);

queuePacketSize=queueMaxSize/maxPayloadSize;
packetStruct=struct('startingTime',-1,'endingTime',-1);
%% Queues
P1Link1QueueInfo=repmat(packetStruct,1,queuePacketSize);
P1Link2QueueInfo=repmat(packetStruct,1,queuePacketSize);
BGLink1QueueInfo=repmat(packetStruct,1,queuePacketSize);
BGLink2QueueInfo=repmat(packetStruct,1,queuePacketSize);
%% Queueing time for currently transmitted packet
queueingTimeP1=zeros(queuePacketSize,1);
queueingTimeBG=zeros(queuePacketSize,1);

averageQueueingTimeVector=zeros(timeInstants+1,1);
lossesDueToNoise=0;