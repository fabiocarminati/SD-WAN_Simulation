%% Define periodic monitoring function for E2E delay 
monitoringPeriod=CPE1SamplingInterval/simulationStepTime;
peakValue=1; 
stairFunction=[peakValue/monitoringPeriod];
for i=2:(monitoringPeriod)
    stairFunction =[stairFunction (i)*(peakValue/monitoringPeriod)]; 
end
stairMatrix=zeros(timeInstants+1,2); 
stairMatrix(:,1)=time;  
repetitionsStair=fix((timeInstants+1)/monitoringPeriod);
stairMatrix(1:size(stairFunction,2)*repetitionsStair,2)=repmat(stairFunction,1,repetitionsStair)'; 
if(mod(timeInstants+1,monitoringPeriod)~=0)
    stairMatrix(size(stairFunction,2)*repetitionsStair+1:timeInstants+1,2)=stairFunction(1,1:mod(timeInstants+1,monitoringPeriod));
end
