%% P1 Traffic and Behaviour 

valuesMatrixP1=zeros(timeInstants+1,2); 
valuesMatrixP1(:,1)=time;
%% Traffic
P1sTraffic=zeros(timeInstants+1,2);
P1sTraffic(:,1)=time;
switch trafficTypeP1
    %% Uncorrelated traffic scenario
    case 1
        rng('shuffle','twister');
        valuesMatrixP1(:,2)=rand((timeInstants+1),1);
        for i=1:timeInstants+1 
            if(valuesMatrixP1(i,2)<=successProbabilityP1)                
                valuesMatrixP1(i,2)=1;                
                P1sTraffic(i,2)=maxPayloadSize; 
            else
                P1sTraffic(i,2)=0;
                valuesMatrixP1(i,2)=0;
            end
        end

    %% Bursts (Poisson processes) traffic
    case 2
        meanP1TrainSize=7; 
        %% Total number of generated packets during the whole simulation 
        packetStream=successProbabilityP1*(timeInstants+1);
        %% Mean of the Poisson process (Ti,j)
        meanNumberOfTrainsP1=round(packetStream/meanP1TrainSize);                
        %% REAL NUMBER OF TRAINS (OF SIZE AVERAGE=meanP1Burst)
        rng('shuffle','twister');
        realNumberOfTrainsP1=poissrnd(meanNumberOfTrainsP1);
        realP1TrainSize=round(packetStream/realNumberOfTrainsP1);
        %% Trains interarrival time 
        interArrivalTimeP1=(timeInstants+1)/meanNumberOfTrainsP1;        
        %% REAL INTERARRIVAL TIME (from a mean of interArrivalTimeP1)
        realP1InterArrivalTime=zeros(realNumberOfTrainsP1,1);
        rng('shuffle','twister');
        realP1InterArrivalTime(:,1)=round(poissrnd(interArrivalTimeP1,realNumberOfTrainsP1,1));
        indexIATime=1;
        timeStepsInterarrivalTime=1;
        %% Poisson probabilities
        for k=1:(timeInstants+1)
            if indexIATime<realNumberOfTrainsP1+1 
                if(timeStepsInterarrivalTime==realP1InterArrivalTime(indexIATime,1))                                            
                    valuesMatrixP1(k,2)=1;               
                    P1sTraffic(k,2)=realP1TrainSize*maxPayloadSize;
                    indexIATime=indexIATime+1;
                    timeStepsInterarrivalTime=1;
                else
                    P1sTraffic(k,2)=0;
                    valuesMatrixP1(k,2)=0;
                    timeStepsInterarrivalTime=timeStepsInterarrivalTime+1;
                end
            else 
                P1sTraffic(k,2)=0;
                valuesMatrixP1(k,2)=0;
            end
        end        
end
if(size(find(P1sTraffic(:,2)<1)) ~= size(find(valuesMatrixP1(:,2)<1))')
    error("P1 TRAFFIC VS VALUES");
end
P1sTraffic=round(P1sTraffic); 
valuesMatrixP1=round(valuesMatrixP1);