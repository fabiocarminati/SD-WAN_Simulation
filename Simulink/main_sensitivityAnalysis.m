%% MAIN FOR SENSITIVITY ANALYSIS
clc;
clear all;
close all; 

busyFractionP1=0.2; 
totalPeriodP1=2; 
busyPeriodP1=busyFractionP1*totalPeriodP1; 
idlePeriodP1=totalPeriodP1-busyPeriodP1; 
successProbabilityP1=busyFractionP1/totalPeriodP1;
CPE1SamplingInterval=1; %seconds
delayScenario=2; %delays are greater than 0
typeOfAnalysis=1;%"sensitivity";
deltaNegative=0;
link1Behaviour=2; % E2E as A+B+C contributions
%% Load data for both the simulations
standardSetup();

%% Define BG traffic pattern and number of destinations in the network
backgroundTrafficPattern=3;
m=2;

%% Define type of channel noise B contribution
channelNoiseBehaviour="Low-pass noise";
filterType="";
fPass=0.1;%Hz 
if(channelNoiseBehaviour=="Low-pass noise") 
    filterType="Lowpass"; %Lowpass e Highpass
else
    fPass=inf;
end

%% Sensitivity vectors for results of both the simulations
sensitivityPathAvailabilityVector=zeros(numberOfRepetitions-firstValidSimulation+1,2);
sensitivitySystemAvailabilityVector=zeros(numberOfRepetitions-firstValidSimulation+1,2);
sensitivityPercentageSentP1Bytes=zeros(1,2);
sensitivitySentP1Links=zeros(2,2); 
sensitivityTimePathAvailability=zeros(numberOfRepetitions-firstValidSimulation+1,2);
sensitivityTimeSystemAvailability=zeros(numberOfRepetitions-firstValidSimulation+1,2);
sensitivityExtraPathQueueInstants=zeros(1,2);
sensitivityExtraNoiseLossesInstants=zeros(1,2);
sensitivityAverageQueueTimeComplete=zeros(1,2);
sensitivityAverageQueueTimePartial=zeros(1,2);
sensitivityAveragePeakDistances=zeros(2,2);
sensitivityPercentageLostBytesArray=zeros(2,2);
stoppedSimulation=zeros(1,2);

thresholdType=2;
%% Create logFile
fileID = fopen('logFile.txt','w');
fprintf(fileID, 'LOG FILE for SENSITIVITY ANALYSIS with queueing time details only for delivered packets that had to wait in queue during simulation\n');
fclose(fileID);
%% Simulations
for ww=1:2
    fileID = fopen('logFile.txt','a');
    fprintf(fileID, '\n                                SIMULATION:%f \n',ww);
    fclose(fileID);
    %% Reset flags:status link1,2 and rerouting flags
    flagsReset();    
    realTimeSetup();
        
    %% Define E2E A+B delay contributions for link1 and link2
    trafficImpactOverDelay();
                                                                                               
    %% Compute BG traffic successProbabilities (again for next run)   
    backgroundTraffic();
    %% Traffic pattern definition       
    trafficTypeP1=1;
    trafficTypeBG=2;     
    P1Behaviour_and_Traffic();
    BGBehaviour_and_Traffic();        
    %% Run the simulation  
    if(ww==1)
        sim('simulink_No_SD_WAN');       
    else
        sim('simulink_main');    
    end
    
    %% Store results of the simulation
    sensitivityPathAvailabilityVector(1:simulationNumber-firstValidSimulation,ww)=pathAvailabilityVector(1:simulationNumber-firstValidSimulation);
    sensitivitySystemAvailabilityVector(1:simulationNumber-firstValidSimulation,ww)=systemAvailabilityVector(1:simulationNumber-firstValidSimulation);
    sensitivityLink1Statistics(1:simulationNumber-firstValidSimulation,ww)=link1StatisticsCumulative(firstValidSimulation:simulationNumber-1);
    sensitivityLink2Statistics(1:simulationNumber-firstValidSimulation,ww)=link2StatisticsCumulative(firstValidSimulation:simulationNumber-1);
    sensitivityPercentageSentP1Bytes(1,ww)=percentageSentP1;
    sensitivitySentP1Links(:,ww)=sentP1Links(:,1);
    sensitivityTimePathAvailability(1:simulationNumber-firstValidSimulation,ww)=timeInstantsPathAvailabilityVector(1:simulationNumber-firstValidSimulation);
    sensitivityTimeSystemAvailability(1:simulationNumber-firstValidSimulation,ww)=timeInstantsSystemAvailabilityVector(1:simulationNumber-firstValidSimulation);
    sensitivityExtraPathQueueInstants(1,ww)=extraPathQueueInstants;
    sensitivityExtraNoiseLossesInstants(1,ww)=lossesDueToNoise;
    sensitivityAverageQueueTimeComplete(1,ww)=mean(averageQueueingTimeVector(:,1));
    sensitivityAverageQueueTimePartial(1,ww)=mean(nonzeros(averageQueueingTimeVector(:,1)));
    %evaluateMeanPeakDistances();
    %sensitivityAveragePeakDistances(1,ww)=avgDistance1;
    %sensitivityAveragePeakDistances(2,ww)=avgDistance2;
    sensitivityPercentageLostBytesArray(1,ww)=totalPercentageLostBytesLinks(1,1);
    sensitivityPercentageLostBytesArray(2,ww)=totalPercentageLostBytesLinks(1,2);
    stoppedSimulation(1,ww)=simulationNumber-1;
    plotTrafficDelayRelation(); 
end
%% Save the results
pathWorkspace="";
save(pathWorkspace)
%% Compare the results of the two simulations 
sensitivityResults();
