%% Before the actual run of the simulation
numberOfReroutings=0;
systemAvailabilityVector=[]; 
pathAvailabilityVector=[];
timeInstantsSystemAvailabilityVector=[];
timeInstantsPathAvailabilityVector=[];
simulationNumber=1;
timeInstantsOfPathUnavailability=0;
timeInstantsOfSystemUnavailability=0;
    
%% Struct for the results
linkStatisticsCumulativeStruct=struct('lostBytes',0,'queueP1',0,'queueBG',0,'sentBytes',0,'sentP1',0);
link1StatisticsCumulative=repmat(linkStatisticsCumulativeStruct,1,numberOfRepetitions);
link2StatisticsCumulative=repmat(linkStatisticsCumulativeStruct,1,numberOfRepetitions);
lostBytesArray=zeros(numberOfRepetitions,m); 
sentBytesArray=zeros(numberOfRepetitions,m);
sentP1Array=zeros(numberOfRepetitions,m);
totTrafficP1BGArray=[];

minimumRepetitionsConsidered=10; % for convergence evaluation
anticipateEndingSimulation=false; 

switch typeOfAnalysis
    case 2 %only for convergence
        casualPathAvailabilityVector=zeros(numberOfRepetitions-firstValidSimulation+1,1);
        casualSystemAvailabilityVector=zeros(numberOfRepetitions-firstValidSimulation+1,1);
        casualTimeInstantsPathAvailability=zeros(numberOfRepetitions-firstValidSimulation+1,1);
        casualTimeInstantsSystemAvailability=zeros(numberOfRepetitions-firstValidSimulation+1,1);
        casualLink1Statistics=zeros(numberOfRepetitions-firstValidSimulation+1,1);
        casualLink2Statistics=zeros(numberOfRepetitions-firstValidSimulation+1,1);
        casualSentP1Links=zeros(2,1);
        casualPercentageSentP1Bytes=zeros(1,1);
end

currentLinkVector=zeros(timeInstants+1,1);
queueingTimeVectorP1=zeros(timeInstants+1,1);
queueingTimeVectorBG=zeros(timeInstants+1,1);

%% Time instants of Path unAvailabilities due to traffic
extraPathQueueInstants=0; %due to queueing time
extraPathLossesInstants=0; %due to extra lost bytes
