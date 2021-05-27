function sensitivityRepetition()
    coder.extrinsic('evalin', 'assignin');
    m=0;
    m=evalin('base','m');
    index=0;
    index=evalin('base','index');
    timeInstantsSingleSimulation=0;
    timeInstantsSingleSimulation=evalin('base','timeInstantsSingleSimulation');
    timeInstants=0;
    timeInstants=evalin('base','timeInstants');
    firstValidSimulation=0;
    firstValidSimulation=evalin('base','firstValidSimulation');
    if(mod(index-1,timeInstantsSingleSimulation)==0 )  
        %% Repetition is over, save results and compute availability
        simulationNumber=0;
        simulationNumber=evalin('base','simulationNumber');
        if(index~=1 && index>firstValidSimulation*timeInstantsSingleSimulation)             
            currentLinkStats=0;
            currentLinkStats=evalin('base','linksStatisticsSingle');
            link1StatisticsCumulative=0;
            link1StatisticsCumulative=evalin('base','link1StatisticsCumulative');
            link2StatisticsCumulative=0;
            link2StatisticsCumulative=evalin('base','link2StatisticsCumulative');
            link1StatisticsCumulative(simulationNumber)=currentLinkStats(1);
            link2StatisticsCumulative(simulationNumber)=currentLinkStats(2); 
            
            assignin('base','link1StatisticsCumulative',link1StatisticsCumulative);
            assignin('base','link2StatisticsCumulative',link2StatisticsCumulative);

            timeInstantsOfSystemUnavailability=0;
            timeInstantsOfSystemUnavailability =evalin('base','timeInstantsOfSystemUnavailability');
            systemAvailabilityVector=0;
            systemAvailabilityVector=evalin('base','systemAvailabilityVector');
            systemUnavailability=(timeInstantsOfSystemUnavailability/timeInstantsSingleSimulation)*100;
            systemAvailability=100-systemUnavailability;
            systemAvailabilityVector=[systemAvailabilityVector systemAvailability];
            assignin('base','systemAvailabilityVector',systemAvailabilityVector);
            timeInstantsSystemAvailabilityVector=0;
            timeInstantsSystemAvailabilityVector=evalin('base','timeInstantsSystemAvailabilityVector');
            timeInstantsSystemAvailabilityVector=[timeInstantsSystemAvailabilityVector (timeInstantsSingleSimulation-timeInstantsOfSystemUnavailability)];
            assignin('base','timeInstantsSystemAvailabilityVector',timeInstantsSystemAvailabilityVector);

            timeInstantsOfPathUnavailability=0;
            timeInstantsOfPathUnavailability =evalin('base','timeInstantsOfPathUnavailability');
            pathUnavailability=(timeInstantsOfPathUnavailability/timeInstantsSingleSimulation)*100;
            pathAvailability=100-pathUnavailability;
            pathAvailabilityVector=0;
            pathAvailabilityVector=evalin('base','pathAvailabilityVector');
            pathAvailabilityVector=[pathAvailabilityVector pathAvailability];
            assignin('base','pathAvailabilityVector',pathAvailabilityVector);
            timeInstantsPathAvailabilityVector=0;
            timeInstantsPathAvailabilityVector=evalin('base','timeInstantsPathAvailabilityVector');
            timeInstantsPathAvailabilityVector=[timeInstantsPathAvailabilityVector (timeInstantsSingleSimulation-timeInstantsOfPathUnavailability)];
            assignin('base','timeInstantsPathAvailabilityVector',timeInstantsPathAvailabilityVector);

            %% Other vector storage
            totTrafficP1BGArray=0;
            totTrafficP1BGArray=evalin('base','totTrafficP1BGArray');
            totTrafficP1BG=0;
            totTrafficP1BG=evalin('base','totTrafficP1BG');
            totTrafficP1BG=totTrafficP1BG-(currentLinkStats(1).queueP1+currentLinkStats(2).queueP1+currentLinkStats(1).queueBG+currentLinkStats(2).queueBG); 
            totTrafficP1BGArray=[totTrafficP1BGArray totTrafficP1BG];
            assignin('base','totTrafficP1BGArray',totTrafficP1BGArray);
            
            for i=1:m 
                lostBytesArray=evalin('base','lostBytesArray');
                lostBytesArray(simulationNumber,i)=currentLinkStats(i).lostBytes;
                assignin('base','lostBytesArray',lostBytesArray);
                sentBytesArray=evalin('base','sentBytesArray');
                sentBytesArray(simulationNumber,i)=currentLinkStats(i).sentBytes;
                assignin('base','sentBytesArray',sentBytesArray);
                sentP1Array=evalin('base','sentP1Array');
                sentP1Array(simulationNumber,i)=currentLinkStats(i).sentP1;
                assignin('base','sentP1Array',sentP1Array); 
            end
                                          
                firstValidSimulation=0;
                firstValidSimulation=evalin('base','firstValidSimulation');
                minimumRepetitionsConsidered=0;
                minimumRepetitionsConsidered=evalin('base','minimumRepetitionsConsidered');
                if(simulationNumber>=minimumRepetitionsConsidered+firstValidSimulation-1)
                    eml.extrinsic('sensitivityAvailability');
                    feval('sensitivityAvailability');                
                end                            
        end
    
        if(index~=1)
            assignin('base','simulationNumber',simulationNumber+1);
        end
        %% Reset statistics
        assignin('base','timeInstantsOfSystemUnavailability',0);
        assignin('base','timeInstantsOfPathUnavailability',0);
        assignin('base','totTrafficP1BG',0);
        linksStatisticsStruct=struct('lostBytes',0,'queueP1',0,'queueBG',0,'sentBytes',0,'sentP1',0);
        linksStatisticsSingle=repmat(linksStatisticsStruct,1,m);                       
        assignin('base','linksStatisticsSingle',linksStatisticsSingle);
        
        packetStruct=struct('startingTime',-1,'endingTime',-1);
        queuePacketSize=0;
        queuePacketSize=evalin('base','queuePacketSize');
        P1Link1QueueInfo=repmat(packetStruct,1,queuePacketSize);
        P1Link2QueueInfo=repmat(packetStruct,1,queuePacketSize);
        BGLink1QueueInfo=repmat(packetStruct,1,queuePacketSize);
        BGLink2QueueInfo=repmat(packetStruct,1,queuePacketSize);
        assignin('base','P1Link1QueueInfo',P1Link1QueueInfo);
        assignin('base','P1Link2QueueInfo',P1Link2QueueInfo);
        assignin('base','BGLink1QueueInfo',BGLink1QueueInfo);
        assignin('base','BGLink2QueueInfo',BGLink2QueueInfo);    
    end    
end