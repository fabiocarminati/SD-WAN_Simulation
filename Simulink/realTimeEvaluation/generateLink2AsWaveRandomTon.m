%% Generate Link2 behaviour with random Ton and Toff but fixed dutyCycleLink2:
timeInstantsLink2=link2Period/simulationStepTime;
Ton=((dutyCycleLink2*link2Period)/100)/simulationStepTime; %not in seconds but in #multiples of 0.2s=simulationStepTime
Toff=timeInstantsLink2-Ton;
numberOfLink2Periods=simTime/link2Period;
rng('shuffle','twister');
displacement=Toff*rand(numberOfLink2Periods,1); 
displacement=round(displacement); 
displacement=int64(displacement); % 64 bit;

valuesLink2Matrix = zeros(timeInstants+1,2);
valuesLink2Matrix(:,1)=time;

index=0;
for i=1:numberOfLink2Periods 
    if(displacement(i,1)~=0) 
        valuesLink2Matrix((index+displacement(i,1)+1):(index+displacement(i,1)+Ton),2)=1;
    else 
         valuesLink2Matrix((index+1):(index+Ton),2)=1;
    end
  index=index+timeInstantsLink2;
end

check=sum( valuesLink2Matrix,1); 
if((check(1,2)/timeInstants)-(dutyCycleLink2/100)>=0.005)
    error("WRONG LINK2 definition")
end