%% Data plane evaluation for each time instant of the simulation    
function dataPlane()
    coder.extrinsic('evalin', 'assignin');
    valuesLink1Matrix=0;
    valuesLink1Matrix=evalin('base','valuesLink1Matrix');
    valuesLink2Matrix=0;
    valuesLink2Matrix=evalin('base','valuesLink2Matrix');   
    currentLink=0;
    currentLink=evalin('base','currentLink');
    currentLinkActive=0;
    currentLinkActive=evalin('base','currentLinkActive');    
    lossesDueToTransaction=0;
    lossesDueToTransaction=evalin('base','lossesDueToTransaction');    
    index=0;
    index=evalin('base','index');
    currentP1Traffic=0;
    currentP1Traffic=evalin('base','P1sTraffic(index,2)');     
    maxPayloadSize=0;
    maxPayloadSize=evalin('base','maxPayloadSize');
    queueMaxSize=0;
    queueMaxSize=evalin('base','queueMaxSize');
    currentBGTraffic=0;
    currentLinkCapacity=0;
    if(currentLink==1)
        currentBGTraffic=evalin('base','Link1sTraffic(index,2)');
        currentLinkCapacity=evalin('base','link1Capacity');
    else
        currentBGTraffic=evalin('base','Link2sTraffic(index,2)');
        currentLinkCapacity=evalin('base','link2Capacity');
    end
    currentLinkStats=0;
    currentLinkStats=evalin('base','linksStatisticsSingle');     
    sentB=0;
    lostB=0;
    queueLengthP1=0;
    queueLengthBG=0;
    sentP1=0;
    extraLostB=0;
    extraLostB1=0;
    eml.extrinsic('evaluateTransmittedBytes');
    
    %% Before Transmission    
    currentlySentPackets=0;
    if(lossesDueToTransaction==false)   
        lostB=currentLinkStats(currentLink).lostBytes;
        [queueLengthP1,queueLengthBG,sentB,extraLostB,extraLostB1,sentP1,currentlySentPackets]=feval('evaluateTransmittedBytes',queueMaxSize,currentLinkStats(currentLink).sentBytes,currentP1Traffic,currentBGTraffic,currentLinkStats(currentLink).queueP1,currentLinkStats(currentLink).queueBG,currentLinkCapacity,maxPayloadSize);
        if extraLostB>0 && currentLinkActive==true       
            timeInstantsOfPathUnavailability=0;
            timeInstantsOfPathUnavailability=evalin('base','timeInstantsOfPathUnavailability');
            assignin('base','timeInstantsOfPathUnavailability',timeInstantsOfPathUnavailability+1);
            extraPathLossesInstants=0;
            extraPathLossesInstants=evalin('base','extraPathLossesInstants');
            assignin('base','extraPathLossesInstants',extraPathLossesInstants+1);
        end        
    else
        sentB=currentLinkStats(currentLink).sentBytes;
        [queueLengthP1,queueLengthBG,lostB,extraLostB,extraLostB1,sentP1,currentlySentPackets]=feval('evaluateTransmittedBytes',queueMaxSize,currentLinkStats(currentLink).lostBytes,currentP1Traffic,currentBGTraffic,currentLinkStats(currentLink).queueP1,currentLinkStats(currentLink).queueBG,currentLinkCapacity,maxPayloadSize);
        currentlySentPackets=0;
    end    
    lostB=lostB+extraLostB;
    %% After Transmission
    currentLinkStats(currentLink).lostBytes=lostB;
    currentLinkStats(currentLink).sentBytes=sentB;
    currentLinkStats(currentLink).queueP1=queueLengthP1;
    currentLinkStats(currentLink).queueBG=queueLengthBG;
    currentLinkStats(currentLink).sentP1=sentP1+currentLinkStats(currentLink).sentP1; 
    assignin('base','linksStatisticsSingle',currentLinkStats);
    
    %% Store new incoming traffic and check that no bytes are missing somewhere in the simulation
    totTrafficP1BG=0;
    totTrafficP1BG=evalin('base','totTrafficP1BG');
    totTrafficP1BG=totTrafficP1BG+currentP1Traffic+currentBGTraffic;
    assignin('base','totTrafficP1BG',totTrafficP1BG);
    if(totTrafficP1BG~=currentLinkStats(1).queueBG+currentLinkStats(1).queueP1+currentLinkStats(1).lostBytes+currentLinkStats(1).sentBytes+currentLinkStats(2).lostBytes+currentLinkStats(2).sentBytes+currentLinkStats(2).queueBG+currentLinkStats(2).queueP1)
        error("LOST+SENT!=%f, total==%f",currentLinkStats(1).queueBG+currentLinkStats(1).queueP1+currentLinkStats(1).lostBytes+currentLinkStats(1).sentBytes+currentLinkStats(2).lostBytes+currentLinkStats(2).sentBytes+currentLinkStats(2).queueBG+currentLinkStats(2).queueP1,totTrafficP1BG);                
    end
    
%% Delay adjustments
    %% 1)Load after tx queue elements 
    queueingTimeP1=0;
    queueingTimeP1=evalin('base','queueingTimeP1');
    queueingTimeBG=0;
    queueingTimeBG=evalin('base','queueingTimeBG');
    simulationStepTime=0;
    simulationStepTime=evalin('base','simulationStepTime');
    
    %% 2)Use this info to adjust delays
    sumDelays=sum(queueingTimeP1)+sum(queueingTimeBG); % expressed as number of timeSteps
    sumDelays=sumDelays*simulationStepTime; 
    timeInstants=0;
    timeInstants=evalin('base','timeInstants');       
    if(currentlySentPackets~=0)
        addPathUnava=false;
        if(currentLink==1)
            valuesLink1Matrix=0;
            valuesLink1Matrix=evalin('base','valuesLink1Matrix');
            oldLink1=valuesLink1Matrix(index,2);
            link1MaxThreshold=0;
            link1MaxThreshold=evalin('base','link1MaxThreshold');            
            valuesLink1Matrix(index,2)=valuesLink1Matrix(index,2) + sumDelays/currentlySentPackets;
            assignin('base','valuesLink1Matrix',valuesLink1Matrix);
            if(oldLink1<link1MaxThreshold && valuesLink1Matrix(index,2)>=link1MaxThreshold)
                addPathUnava=true;
            end            
        else
            valuesLink2Matrix=0;
            valuesLink2Matrix=evalin('base','valuesLink2Matrix');
            oldLink2=valuesLink2Matrix(index,2);
            link2MaxThreshold=0;
            link2MaxThreshold=evalin('base','link2MaxThreshold');            
            valuesLink2Matrix(index,2)=valuesLink2Matrix(index,2) + sumDelays/currentlySentPackets;
            assignin('base','valuesLink2Matrix',valuesLink2Matrix);
            if(oldLink2<link2MaxThreshold && valuesLink2Matrix(index,2)>=link2MaxThreshold)
                addPathUnava=true;
            end
        end 
        if(addPathUnava==true)
            timeInstantsOfPathUnavailability=0;
            timeInstantsOfPathUnavailability =evalin('base','timeInstantsOfPathUnavailability');
            assignin('base','timeInstantsOfPathUnavailability',timeInstantsOfPathUnavailability+1);
            extraPathQueueInstants=0;
            extraPathQueueInstants=evalin('base','extraPathQueueInstants');
            assignin('base','extraPathQueueInstants',extraPathQueueInstants+1);
        end                                           
        fid = fopen('logFile.txt', 'a'); 
        if fid == -1
            error('Cannot open log file.');
        end
        fprintf(fid,"Total sent packets during this step is:%.0f; therefore average queue delay is:%.2f sec \n\n",currentlySentPackets,sumDelays/currentlySentPackets);
        fclose(fid);
        
        averageQueueingTimeVector=0;
        averageQueueingTimeVector=evalin('base','averageQueueingTimeVector'); 
        averageQueueingTimeVector(index,1)=sumDelays/currentlySentPackets;
        assignin('base','averageQueueingTimeVector',averageQueueingTimeVector);
    end

    %% 3)In the end reset also these queues 
    queuePacketSize=0; 
    queuePacketSize=evalin('base','queuePacketSize');    
    queueingTimeVectorP1=0;
    queueingTimeVectorP1=evalin('base','queueingTimeVectorP1');
    queueingTimeVectorP1(index,1)=sum(queueingTimeP1);
    assignin('base','queueingTimeVectorP1',queueingTimeVectorP1);    
    queueingTimeVectorBG=0;
    queueingTimeVectorBG=evalin('base','queueingTimeVectorBG');
    queueingTimeVectorBG(index,1)=sum(queueingTimeBG);
    assignin('base','queueingTimeVectorBG',queueingTimeVectorBG);    
    queueingTimeP1=zeros(queuePacketSize,1);
    queueingTimeBG=zeros(queuePacketSize,1);
    assignin('base','queueingTimeP1',queueingTimeP1);
    assignin('base','queueingTimeBG',queueingTimeBG);
    
%% End delay adjustment
    currentlySentPacketsArray=0;
    currentlySentPacketsArray=evalin('base','currentlySentPacketsArray');
    currentlySentPacketsArray(index,1)=currentlySentPackets;
    assignin('base','currentlySentPacketsArray',currentlySentPacketsArray);    
    currentLinkVector=0;
    currentLinkVector=evalin('base','currentLinkVector');
    currentLinkVector(index,1)=currentLink;
    assignin('base','currentLinkVector',currentLinkVector);    
end