%% BG Traffic and Behaviour for m destinations

valuesMatrixBackGround=zeros(timeInstants+1,m+1);
valuesMatrixBackGround(:,1)=time;
%% Traffic    
trafficMatrixBackGround=zeros(timeInstants+1,m+1); 
trafficMatrixBackGround(:,1)=time;
switch trafficTypeBG
    %% Uncorrelated traffic scenario 
    case 1
        rng('shuffle','twister');
        values=rand((timeInstants+1)*m,1);
        for i=1:m
            valuesMatrixBackGround(:,i+1)=values((i-1)*(timeInstants+1)+1:(i)*(timeInstants+1));
        end        
        for w=1:m
            for j=1:numberOfTimeInstantsOfWANArrivals
                for k=1:timeStepsTao
                    if(valuesMatrixBackGround(k+(j-1)*timeStepsTao,w+1)<=successProbabilityBackground(j,w))       
                        valuesMatrixBackGround(k+(j-1)*timeStepsTao,w+1)=1;                        
                        trafficMatrixBackGround(k+(j-1)*timeStepsTao,w+1)=maxPayloadSize; 
                    else
                        trafficMatrixBackGround(k+(j-1)*timeStepsTao,w+1)=0;
                        valuesMatrixBackGround(k+(j-1)*timeStepsTao,w+1)=0;
                    end
                end
            end
        end

    %% Bursts (Poisson processes) traffic
    case 2        
        %% Mean burst length of the background traffic
        meanBGTrainSize=zeros(numberOfTimeInstantsOfWANArrivals,m);
        meanBGTrainSize(:,:)=4; 
        %% Mean of the Poisson process (Ti,j)
        meanNumberOfTrainsBG=zeros(numberOfTimeInstantsOfWANArrivals,m);
        realNumberOfTrainsBG=zeros(numberOfTimeInstantsOfWANArrivals,m);
        realBGTrainSize=zeros(numberOfTimeInstantsOfWANArrivals,m);
        %% Trains interarrival time 
        interArrivalTimeBG=zeros(numberOfTimeInstantsOfWANArrivals,m);
        %% Poisson probabilities
        for w=1:m
            for j=1:numberOfTimeInstantsOfWANArrivals
                meanNumberOfTrainsBG(j,w)=round(packetsStreams(j,w)/meanBGTrainSize(j,w));               
                %% REAL NUMBER OF TRAINS (OF SIZE AVERAGE=meanP1Burst)
                rng('shuffle','twister');
                realNumberOfTrainsBG(j,w)=poissrnd(meanNumberOfTrainsBG(j,w));
                realBGTrainSize(j,w)=round(packetsStreams(j,w)/realNumberOfTrainsBG(j,w));                
                %% Trains interarrival time 
                interArrivalTimeBG(j,w)=(timeStepsTao)/meanNumberOfTrainsBG(j,w);        
                %% REAL INTERARRIVAL TIME (from a mean of interArrivalTimeP1)                
                realBGInterArrivalTime=zeros(realNumberOfTrainsBG(j,w),1);
                rng('shuffle','twister');
                realBGInterArrivalTime(:,1)=round(poissrnd(interArrivalTimeBG(j,w),realNumberOfTrainsBG(j,w),1));
                indexIATime=1;
                timeStepsInterarrivalTime=1;
                for k=1:timeStepsTao
                    if indexIATime<realNumberOfTrainsBG(j,w)+1                       
                        if(timeStepsInterarrivalTime==realBGInterArrivalTime(indexIATime,1))
                            valuesMatrixBackGround(k+(j-1)*timeStepsTao,w+1)=1;
                            trafficMatrixBackGround(k+(j-1)*timeStepsTao,w+1)=realBGTrainSize(j,w)*maxPayloadSize;
                            indexIATime=indexIATime+1;
                            timeStepsInterarrivalTime=1;
                        else
                            trafficMatrixBackGround(k+(j-1)*timeStepsTao,w+1)=0;
                            valuesMatrixBackGround(k+(j-1)*timeStepsTao,w+1)=0;
                            timeStepsInterarrivalTime=timeStepsInterarrivalTime+1;
                        end                        
                    else 
                        trafficMatrixBackGround(k+(j-1)*timeStepsTao,w+1)=0;
                        valuesMatrixBackGround(k+(j-1)*timeStepsTao,w+1)=0;
                    end
                end                
            end
        end
end
for w=1:m
    if(size(find(trafficMatrixBackGround(:,w+1)<1)) ~= size(find(valuesMatrixBackGround(:,w+1)<1))')
        error("BG Link:%f wrong TRAFFIC VS VALUE instants",w);
    end
end
%% Send to workspace generated BG traffic
trafficMatrixBackGround=round(trafficMatrixBackGround);
Link1sTraffic=zeros(timeInstants+1,2);
Link1sTraffic(:,1)=time;
Link1sTraffic(:,2)=round(trafficMatrixBackGround(:,2));
Link2sTraffic=zeros(timeInstants+1,2);
Link2sTraffic(:,1)=time;
Link2sTraffic(:,2)=round(trafficMatrixBackGround(:,3));

%% Round the BG process values
valuesMatrixBackGround=round(valuesMatrixBackGround);
valuesMatrixLink1BG=zeros(timeInstants+1,2); 
valuesMatrixLink1BG(:,1)=time;
valuesMatrixLink1BG(:,2)=valuesMatrixBackGround(1:timeInstants+1,2);
valuesMatrixLink2BG=zeros(timeInstants+1,2); 
valuesMatrixLink2BG(:,1)=time;
valuesMatrixLink2BG(:,2)=valuesMatrixBackGround(1:timeInstants+1,3);