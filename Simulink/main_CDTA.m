%% C.D.T.A.- Combined Delay and Traffic Analysis
clc;
clear all;
close all; 
CPE1SamplingInterval=1; %s
delayScenario=2; %delays greater than  0
typeOfAnalysis=2;%"convergence";
deltaNegative=0;
link1Behaviour=1; % E2E as a rectangular wave
%% Load data for all the simulations
standardSetup();

%% Define BG traffic pattern and number of destinations in the network
backgroundTrafficPattern=3; 
m=2;
   
%% Vectors for evaluation of the results
deterministicPathAvailabilityVector=zeros(numberOfRepetitions-firstValidSimulation+1,1);
deterministicSystemAvailabilityVector=zeros(numberOfRepetitions-firstValidSimulation+1,1);
deterministicTimeInstantsPathAvailability=zeros(numberOfRepetitions-firstValidSimulation+1,1);
deterministicTimeInstantsSystemAvailability=zeros(numberOfRepetitions-firstValidSimulation+1,1);
deterministicSentP1Links=zeros(2,1);
deterministicPercentageSentP1Bytes=zeros(1,1);

%% Traffic behaviour    
trafficTypeP1=2; 
trafficTypeBG=2;

thresholdType=1; 
%% Simulations
for ww=1:2 
    %% Deterministic
    if(ww==1)
        %% Reset flags:status link1,2 and rerouting flags
        flagsReset();
        realTimeSetup();
        currentlySentPacketsArray=zeros(timeInstants+1,1);
        %% E2E over link1 as rectangula wave
        link1Period=20; %seconds
        dutyCycleLink1=80; 
        generateLink1AsWaveFixedTon_samePhaseDelay();
        %% E2E over link2 as rectangula wave                                                                 
        link2Period=20; %seconds
        dutyCycleLink2=96; 
        generateLink2AsWaveFixedTon_samePhaseDelay();                                                                           
        %% Set processes as idle for whole simulation
        successProbabilityP1=0;        
        %% Generate processes P1 and BG1,BG2 with 0 value and 0 traffic for each time instant in the whole simulation
        BG_and_P1_trafficDeterministic();
        %% Define min and max thresholds        
        link1MaxThreshold=0; 
        link1MinThreshold=1;
        link2MaxThreshold=0; 
        link2MinThreshold=1;
        valuesLink1Matrix=valuesLink1Matrix(1:timeInstants+1,:);
        valuesLink2Matrix=valuesLink2Matrix(1:timeInstants+1,:);
        %% Run the simulation
        sim('simulink_main_square_waves');
        %% Evaluate availability
        convergenceDeterministicAvailability();
        %% Save results
        deterministicPathAvailabilityVector(:,1)=pathAvailabilityVector(1:simulationNumber-firstValidSimulation+1);
        deterministicSystemAvailabilityVector(:,1)=systemAvailabilityVector(1:simulationNumber-firstValidSimulation+1);
        deterministicTimeInstantsPathAvailability(:,1)=timeInstantsPathAvailabilityVector(1:simulationNumber-firstValidSimulation+1);
        deterministicTimeInstantsSystemAvailability(:,1)=timeInstantsSystemAvailabilityVector(1:simulationNumber-firstValidSimulation+1);
        deterministicLink1Statistics(:,1)=link1StatisticsCumulative(firstValidSimulation:numberOfRepetitions);
        deterministicLink2Statistics(:,1)=link2StatisticsCumulative(firstValidSimulation:numberOfRepetitions);
        deterministicSentP1Links(:,1)=sentP1Links(:,1);
        deterministicPercentageSentP1Bytes(1,1)=percentageSentP1;
    %% Second simulation
    else         
        fileID = fopen('logFile.txt','w');
        fprintf(fileID, 'LOG FILE with queueing time details only for delivered packets that had to wait in queue during simulation\n');
        fclose(fileID);        
        close all;
        %% Reset flags:status link1,2 and rerouting flags
        flagsReset();
        realTimeSetup();
        currentlySentPacketsArray=zeros(timeInstants+1,1);
        
        %% E2E over link1 as rectangula wave
        link1Period=20; %seconds
        dutyCycleLink1=80; 
        generateLink1AsWaveRandomTon();
        %generateLink1AsWaveFixedTon_samePhaseDelay();
        %% E2E over link2 as rectangula wave                                                                 
        link2Period=20; %seconds
        dutyCycleLink2=96; 
        generateLink2AsWaveFixedTon_samePhaseDelay(); 
        %generateLink2AsWaveRandomTon();
                                                                                                                                                                           
        %% Set processes P1 success probability(useful only for uncorrelated traffic)
        successProbabilityP1=0.5;
        %% Start to generate BG traffic (M,P)
        backgroundTraffic(); 
        %% Phase S 
        P1Behaviour_and_Traffic();
        BGBehaviour_and_Traffic();  
        %BG_and_P1_trafficDeterministic();             
        %% Define min and max thresholds    
        link1MaxThreshold=0; 
        link1MinThreshold=1;
        link2MaxThreshold=0; 
        link2MinThreshold=1;
        valuesLink1Matrix=valuesLink1Matrix(1:timeInstants+1,:);
        valuesLink2Matrix=valuesLink2Matrix(1:timeInstants+1,:);
        %% Run the simulation
        sim('simulink_main_square_waves');       
    end    
end
%plotTrafficDelayRelation();

%% C.D.T.A. status     
if(anticipateEndingSimulation==false)
    error("After all repetitions:%.0f the results are not enough accurate\n",numberOfRepetitions);
else
    fprintf("Despite the fact that we can have up to:%.0f repetitions we can stop after:%.0f since results are already accurate enough \n",numberOfRepetitions,simulationNumber-1);
end 
%% Save the results
pathWorkspace="";
save(pathWorkspace)