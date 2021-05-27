function sensitivityAvailability()
    %% Load variables and arrays
    pathAvailabilityVector=0;
    pathAvailabilityVector=evalin('base','pathAvailabilityVector');
    systemAvailabilityVector=0;
    systemAvailabilityVector=evalin('base','systemAvailabilityVector');
    firstValidSimulation=0;
    firstValidSimulation=evalin('base','firstValidSimulation');
    numberOfRepetitions=0;
    numberOfRepetitions=evalin('base','numberOfRepetitions');    
    timeInstantsSingleSimulation=0;
    timeInstantsSingleSimulation=evalin('base','timeInstantsSingleSimulation');    
    P1sTraffic=0;
    P1sTraffic=evalin('base','P1sTraffic');
    sentP1Array=0;
    sentP1Array=evalin('base','sentP1Array');
    lostBytesArray=0;
    lostBytesArray=evalin('base','lostBytesArray');
    sentBytesArray=0;
    sentBytesArray=evalin('base','sentBytesArray');
    totTrafficP1BGArray=0;
    totTrafficP1BGArray=evalin('base','totTrafficP1BGArray');
    linksStatisticsSingle=0;
    linksStatisticsSingle=evalin('base','linksStatisticsSingle');
    simulationNumber=0;
    simulationNumber=evalin('base','simulationNumber');
    m=0;
    m=evalin('base','m');    
    pathAvaVariance=var(pathAvailabilityVector(1:simulationNumber-firstValidSimulation+1));
    pathAvaMean=mean(pathAvailabilityVector(1:simulationNumber-firstValidSimulation+1));
    sysAvaVariance=var(systemAvailabilityVector(1:simulationNumber-firstValidSimulation+1));
    sysAvaMean=mean(systemAvailabilityVector(1:simulationNumber-firstValidSimulation+1));
    
    %% Stop sensitivity analysis if results are adeguate after minNumberOfRepetitions
    stop=0;
    fprintf("\n");
    fprintf("\n \n- <strong> Path availability variance </strong> :%f and <strong> mean </strong> :%f ;min:%f, MAX:%f \n",pathAvaVariance,pathAvaMean,min(pathAvailabilityVector),max(pathAvailabilityVector));
    if(pathAvaVariance<=(0.1*pathAvaMean))
        fprintf("The <strong> mean </strong> value after:%.0f repetitions of the Path availability computed is accurate enough \n",simulationNumber);
        stop=stop+1;
    else
       fprintf("GO AHEAD;The <strong> mean </strong> value after:%.0f repetitions of the App. availability computed is <strong> NOT </strong> accurate enough \n",simulationNumber);
    end
    fprintf("- <strong> System availability variance </strong>:%f and <strong> mean </strong> :%f ;min:%f, MAX:%f \n",sysAvaVariance,sysAvaMean,min(systemAvailabilityVector),max(systemAvailabilityVector));

    if(sysAvaVariance<=(0.1*sysAvaMean))
        fprintf("The <strong> mean </strong> value after:%.0f repetitions of the System availability computed is accurate enough;but this is convergence analysis \n",simulationNumber);
        stop=stop+1;
    else
       fprintf("GO AHEAD;The <strong> mean </strong> value after:%.0f repetitions of the System availability computed is <strong> NOT </strong> accurate enough \n",simulationNumber);
    end

    if(sum(P1sTraffic((firstValidSimulation-1)*timeInstantsSingleSimulation+1:simulationNumber*timeInstantsSingleSimulation,2))>0)
        percentageSentP1=sum(sum(sentP1Array(firstValidSimulation:simulationNumber,1:m)))/sum(P1sTraffic((firstValidSimulation-1)*timeInstantsSingleSimulation+1:(simulationNumber)*timeInstantsSingleSimulation,2))*100;
    else
        percentageSentP1=100;
    end
    fprintf("<strong> Total sent percentage </strong> P1 traffic either through link1 or link 2 is:%f %% \n",percentageSentP1);
    sentP1Links=zeros(m,1);
    totalPercentageLostBytesLinks=zeros(1,m);
    for i=1:m
        sentP1Links(i,1)=(sum(sum(sentP1Array(firstValidSimulation:simulationNumber,i)))/sum(sum(sentP1Array(firstValidSimulation:simulationNumber,1:m)))*100);
        fprintf("\n <strong> Link %f </strong>",i);
        fprintf("\n - <strong> Tot lostBytes: </strong>%f,Tot sentBytes:%f, Tot generated traffic link1 e link 2:%f \n",sum(lostBytesArray(firstValidSimulation:simulationNumber,i)),sum(sentBytesArray(firstValidSimulation:simulationNumber,i)),sum(totTrafficP1BGArray));
        fprintf("<strong> - Of the SENT fraction: %f %% a Percentage </strong> has gone through Link %f  is:%f %% for whole simulation \n",percentageSentP1,i,sentP1Links(i,1));
        totalPercentageLostBytesLinks(1,i)=(sum(lostBytesArray(firstValidSimulation:simulationNumber,i))/sum(totTrafficP1BGArray))*100;
    end
    
    assignin('base','totalPercentageLostBytesLinks',totalPercentageLostBytesLinks);
    if(sum(totTrafficP1BGArray)~=sum(lostBytesArray,'all')+sum(sentBytesArray,'all'))
        error("ERROR SUMMATION TOT:%f VS LOST+SENT+QUEUEs:%f \n",sum(totTrafficP1BGArray),sum(lostBytesArray,'all')+sum(sentBytesArray,'all')+linksStatisticsSingle(1).queueP1+linksStatisticsSingle(2).queueP1+linksStatisticsSingle(1).queueBG+linksStatisticsSingle(2).queueBG);
    end
        
    assignin('base','sentP1Links',sentP1Links);
    assignin('base','percentageSentP1',percentageSentP1);
    assignin('base','pathAvaVariance',pathAvaVariance);
    assignin('base','pathAvaVariance',pathAvaMean);
    assignin('base','pathAvaVariance',sysAvaVariance);
    assignin('base','pathAvaVariance',sysAvaMean);    
    if(stop==2)
        fprintf("STOP simulation since results are accurate enough after:%.0f\n",simulationNumber);
        assignin('base','anticipateEndingSimulation',true);
    end    
end