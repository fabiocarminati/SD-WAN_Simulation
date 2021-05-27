%% Simulation time parameters
singleSimulationTime=100; %seconds
numberOfRepetitions=20; 
firstValidSimulation=5;
simTime=singleSimulationTime*numberOfRepetitions;
simulationStepTime=0.05; 
timeInstants=simTime/simulationStepTime;
timeInstantsSingleSimulation=(singleSimulationTime/simulationStepTime);
time=linspace(0,simTime,timeInstants+1);

%% Compute in stairMatrix the monitoring function throughout the simulation 
monitoringFunction();

%% Packet forwarding configuration
link1Capacity=1600;
maxPayloadSize=800;
link2Capacity=link1Capacity;
queueMaxSize=3200; 
processTimeFeedbackCPE2 = 2;
packetLossProbabilityThresholdP1=2; 
processRateScenario=3;
       
%% Delays
switch delayScenario
    case 1
        delayCPE1Controller1=0;
        delayCPE2Controller1=0;
        processTimeController1=0.4;
        processingTimeCPEUpdate=0.2;
        processTimeCPE1MonitoringInfo=0;
    case 2
        processTimeCPE1MonitoringInfo=0.2;
        delayCPE1Controller1=0.4;
        delayCPE2Controller1=0.8;
        processTimeController1=0.4;
        processingTimeCPEUpdate=0.2;
end