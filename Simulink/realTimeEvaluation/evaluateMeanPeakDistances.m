%% Evaluate average distance between peaks
list1=find(valuesLink1Matrix(:,2)>=link1MaxThreshold);
avgDistance1=0;
if(size(list1,1)>1)
    avgDistance1=averageArray(list1,simulationStepTime);
end

list2=find(valuesLink2Matrix(:,2)>=link2MaxThreshold);
avgDistance2=0;
if(size(list2,1)>1)
    avgDistance2=averageArray(list2,simulationStepTime);
end