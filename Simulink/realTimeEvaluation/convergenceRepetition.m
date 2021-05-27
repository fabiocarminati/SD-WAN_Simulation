function convergenceRepetition() 
    coder.extrinsic('evalin', 'assignin');
    m=0;
    m=evalin('base','m');
    index=0;
    index=evalin('base','index');
    timeInstantsSingleSimulation=0;
    timeInstantsSingleSimulation=evalin('base','timeInstantsSingleSimulation');
    if(mod(index-1,timeInstantsSingleSimulation)==0) 
        simulationNumber=0;
        simulationNumber=evalin('base','simulationNumber');
        if(index~=1) 
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
            
            firstValidSimulation=0;
            firstValidSimulation=evalin('base','firstValidSimulation');
            if(index>firstValidSimulation*timeInstantsSingleSimulation)
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
            end
            %% Other vector storage
            totTrafficP1BGArray=0;
            totTrafficP1BGArray=evalin('base','totTrafficP1BGArray');
            totTrafficP1BG=0;
            totTrafficP1BG=evalin('base','totTrafficP1BG');
            oldQueuesLength=evalin('base','oldQueuesLength');
            totTrafficP1BG=totTrafficP1BG-oldQueuesLength;
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
            ww=0;
            ww=evalin('base','ww');            
            %% Only for second simulation simulation
            if ww==2
                minimumRepetitionsConsidered=0;
                minimumRepetitionsConsidered=evalin('base','minimumRepetitionsConsidered');
                firstValidSimulation=0;
                firstValidSimulation=evalin('base','firstValidSimulation');
                anticipateEndingSimulation=0;
                anticipateEndingSimulation=evalin('base','anticipateEndingSimulation');                                 
                if(simulationNumber>=minimumRepetitionsConsidered+firstValidSimulation-1)
                    eml.extrinsic('convergenceAvailability');
                    feval('convergenceAvailability');
                    pathAvailabilityVector=0;
                    pathAvailabilityVector=evalin('base','pathAvailabilityVector');
                    systemAvailabilityVector=0;
                    systemAvailabilityVector=evalin('base','systemAvailabilityVector');
                    timeInstantsPathAvailabilityVector=0;
                    timeInstantsPathAvailabilityVector=evalin('base','timeInstantsPathAvailabilityVector');
                    timeInstantsSystemAvailabilityVector=0;
                    timeInstantsSystemAvailabilityVector=evalin('base','timeInstantsSystemAvailabilityVector');
                    link1StatisticsCumulative=0;
                    link1StatisticsCumulative=evalin('base','link1StatisticsCumulative');
                    link2StatisticsCumulative=0;
                    link2StatisticsCumulative=evalin('base','link2StatisticsCumulative');
                    sentP1Links=0;
                    sentP1Links=evalin('base','sentP1Links');
                    percentageSentP1=0;
                    percentageSentP1=evalin('base','percentageSentP1');
                    
                    casualPathAvailabilityVector(1:simulationNumber-firstValidSimulation+1,1)=pathAvailabilityVector(1:simulationNumber-firstValidSimulation+1);
                    assignin('base','casualPathAvailabilityVector',casualPathAvailabilityVector);
                    casualSystemAvailabilityVector(1:simulationNumber-firstValidSimulation+1,1)=systemAvailabilityVector(1:simulationNumber-firstValidSimulation+1);
                    assignin('base','casualSystemAvailabilityVector',casualSystemAvailabilityVector);
                    casualTimeInstantsPathAvailability(1:simulationNumber-firstValidSimulation+1,1)=timeInstantsPathAvailabilityVector(1:simulationNumber-firstValidSimulation+1);
                    assignin('base','casualTimeInstantsPathAvailability',casualTimeInstantsPathAvailability);
                    casualTimeInstantsSystemAvailability(1:simulationNumber-firstValidSimulation+1,1)=timeInstantsSystemAvailabilityVector(1:simulationNumber-firstValidSimulation+1);
                    assignin('base','casualTimeInstantsSystemAvailability',casualTimeInstantsSystemAvailability);
                    
                    %% LINK STATISTICS 
                    casualLink1Statistics(1:simulationNumber-firstValidSimulation+1,1)=link1StatisticsCumulative(firstValidSimulation:simulationNumber);
                    assignin('base','casualLink1Statistics',casualLink1Statistics);
                    casualLink2Statistics(1:simulationNumber-firstValidSimulation+1,1)=link2StatisticsCumulative(firstValidSimulation:simulationNumber);
                    assignin('base','casualLink2Statistics',casualLink2Statistics);                    
                    casualSentP1Links(:,1)=sentP1Links(:,1);           
                    assignin('base','casualSentP1Links',casualSentP1Links);
                    casualPercentageSentP1Bytes(1,1)=percentageSentP1;
                    assignin('base','casualPercentageSentP1Bytes',casualPercentageSentP1Bytes);
                    eml.extrinsic('convergenceIterations');
                    feval('convergenceIterations');
                end
            end            
            assignin('base','simulationNumber',simulationNumber+1); 
        end
        %% Reset statistics
        assignin('base','timeInstantsOfSystemUnavailability',0);
        assignin('base','timeInstantsOfPathUnavailability',0); 
        if index~=1
            oldQueuesLength=currentLinkStats(1).queueP1+currentLinkStats(2).queueP1+currentLinkStats(1).queueBG+currentLinkStats(2).queueBG;        
        else
            oldQueuesLength=0;
        end
        assignin('base','totTrafficP1BG',oldQueuesLength);
        assignin('base','oldQueuesLength',oldQueuesLength);
        
        linksStatisticsStruct=struct('lostBytes',0,'queueP1',0,'queueBG',0,'sentBytes',0,'sentP1',0);
        linksStatisticsSingle=repmat(linksStatisticsStruct,1,m);
        simulationNumber=evalin('base','simulationNumber');
        if(simulationNumber>1) 
            link1StatisticsCumulative=0;
            link1StatisticsCumulative=evalin('base','link1StatisticsCumulative');
            link2StatisticsCumulative=0;
            link2StatisticsCumulative=evalin('base','link2StatisticsCumulative');
            linksStatisticsSingle(1).queueP1=currentLinkStats(1).queueP1;
            linksStatisticsSingle(1).queueBG=currentLinkStats(1).queueBG;
            linksStatisticsSingle(2).queueP1=currentLinkStats(2).queueP1;
            linksStatisticsSingle(2).queueBG=currentLinkStats(2).queueBG;
        end                
        assignin('base','linksStatisticsSingle',linksStatisticsSingle);
    end    
end