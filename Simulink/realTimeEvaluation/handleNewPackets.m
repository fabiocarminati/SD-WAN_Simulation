function [sentB,spareC,queueLengthTot,extraLostB,currentlySentPackets]=handleNewPackets(currentlySentPks,queueMaxSize,dataLength,maxPayloadSize,sentBytes,spareCapacity,queueLength,ID)
    queueLengthTot=queueLength;
    index=0;
    index=evalin('base','index');
    processQueueInfo=0;
    currentLink=0;
    currentLink=evalin('base','currentLink');
    %% Load the proper queueInfo
    processQueueInfo=loadQueueInfo(ID);        
    currentlySentPackets=currentlySentPks;
    sentB=sentBytes;
    numberOfPackets=0;
    extraLostB=0; 
    numberOfPackets=fix(dataLength/maxPayloadSize); 
    lastPacketSize=mod(dataLength,maxPayloadSize);
    if lastPacketSize~=0
        numberOfPackets=numberOfPackets+1;       
    end  

    for i=1:(numberOfPackets-1) 
        if(queueLengthTot==0) 
            if maxPayloadSize<=spareCapacity                    
                sentB=sentB+maxPayloadSize;                    
                spareCapacity=spareCapacity-maxPayloadSize;
                currentlySentPackets=currentlySentPackets+1;
            else
                vec=[processQueueInfo.startingTime];
                findElement=find(vec<0);
                processQueueInfo(findElement(1)).startingTime=index;
                queueLengthTot=maxPayloadSize;
            end
        else 
            if(queueLengthTot+maxPayloadSize<=queueMaxSize)
                vec=[processQueueInfo.startingTime];
                findElement=find(vec<0);
                queueLengthTot=queueLengthTot+maxPayloadSize;                
                processQueueInfo(findElement(1)).startingTime=index;
            else
                extraLostB=extraLostB+maxPayloadSize;
            end
        end
    end

    if(lastPacketSize~=0) 
        if(lastPacketSize<=spareCapacity)
            sentB=sentB+lastPacketSize;
            spareCapacity=spareCapacity-lastPacketSize;
            currentlySentPackets=currentlySentPackets+1;
        else
            if(queueLengthTot+lastPacketSize<=queueMaxSize)  
                queueLengthTot=queueLengthTot+lastPacketSize;
                vec=[processQueueInfo.startingTime];
                findElement=find(vec<0);
                processQueueInfo(findElement(1)).startingTime=index;
            else
                extraLostB=extraLostB+lastPacketSize;
            end
        end
    else 
        if(maxPayloadSize<=spareCapacity)
            sentB=sentB+maxPayloadSize; 
            spareCapacity=spareCapacity-maxPayloadSize;
            currentlySentPackets=currentlySentPackets+1;
        else
            if(queueLengthTot+maxPayloadSize<=queueMaxSize)
                queueLengthTot=queueLengthTot+maxPayloadSize;
                vec=[processQueueInfo.startingTime];
                findElement=find(vec<0);
                processQueueInfo(findElement(1)).startingTime=index;
            else
                extraLostB=extraLostB+maxPayloadSize;
            end
        end
    end   
    spareC=spareCapacity; 
    %% Save queueing computations
    saveQueueInfo(ID,processQueueInfo);           
end