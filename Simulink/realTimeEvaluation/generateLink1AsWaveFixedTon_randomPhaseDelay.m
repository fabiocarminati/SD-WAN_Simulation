%% Generate Link1 behaviour with fixed Ton and Toff placement and fixed dutyCycleLink1:
timeInstantsLink1=link1Period/simulationStepTime;
Ton=((dutyCycleLink1*link1Period)/100)/simulationStepTime; %not in seconds but in #multiples of 0.2s=simulationStepTime
Toff=timeInstantsLink1-Ton;
numberOfLink1Periods=simTime/link1Period;
rng('shuffle','twister');
displacement=Toff*rand; 
displacement=round(displacement); 
displacement=int64(displacement); % 64 bit;
valuesLink1Matrix = zeros(timeInstants+1,2);
valuesLink1Matrix(:,1)=time;
index=0;
for i=1:numberOfLink1Periods 
    if(displacement~=0) 
        valuesLink1Matrix((index+displacement+1):(index+displacement+Ton),2)=1;
    else 
        valuesLink1Matrix((index+1):(index+Ton),2)=1;
    end
  index=index+timeInstantsLink1;
end

check=sum( valuesLink1Matrix,1);
if((check(1,2)/timeInstants)-(dutyCycleLink1/100)>=0.005)
    error("WRONG LINK1 definition")
end