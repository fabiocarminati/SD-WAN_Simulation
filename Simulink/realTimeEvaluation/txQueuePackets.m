function [sentB,spareC,queueL,currentlySentPackets] = txQueuePackets(currentlySentPks,spareCapacity,queueLengthTot,maxPayloadSize,ID)
    emptyQueue=false;
    sentB=0;
    queueL=queueLengthTot;
    currentlySentPackets=currentlySentPks;    
    index=0;
    index=evalin('base','index');
    processQueueInfo=0;
    
    %% Load the proper queueInfo and sort it such that new packets are placed in the tail of the queue
    processQueueInfo=loadQueueInfo(ID);     
    %% Load queueing time vector
    processQueueTimeInfo=0;
    processQueueTimeInfo=loadQueueTimeInfo(ID);
    currentLink=0;
    currentLink=evalin('base','currentLink');
    currentLinkActive=0;
    currentLinkActive=evalin('base','currentLinkActive');
    if(queueL~=0)
        while emptyQueue==false
            if(queueL==0)
                emptyQueue=true;
            else
                if(queueL-maxPayloadSize<0) 
                    if(queueL<=spareCapacity)
                        sentB=sentB+queueL;
                        spareCapacity=spareCapacity-queueL;     
                        currentlySentPackets=currentlySentPackets+1;                      
                        processQueueInfo=loadQueueInfo(ID); 
                        %% Load first queue element (FIFO logic)
                        vec=[processQueueInfo.startingTime];
                        vec(vec<=0) = NaN;
                        [findElement,findIndex]=min(vec);
                        %% Check link status
                        if currentLinkActive==true
                            %% Set ending time only if packet isn t lost
                            processQueueInfo(findIndex).endingTime=index;
                            %% Save queueing time as ending-starting time (as number of consecutive timeInstants)
                            findElementTime=find(processQueueTimeInfo==0);
                            processQueueTimeInfo(findElementTime(1))=processQueueInfo(findIndex).endingTime-processQueueInfo(findIndex).startingTime;
                            logFileDefinition(processQueueInfo(findIndex).startingTime,index,ID,currentLink);                             
                        end                        
                        %% Reset to -1 the values
                        processQueueInfo(findIndex).startingTime=-1;
                        processQueueInfo(findIndex).endingTime=-1;                                                
                        %% Save queueing computations
                        saveQueueInfo(ID,processQueueInfo);                                                                        
                        queueL=0;
                    else
                        emptyQueue=true; 
                    end
                else
                    if(maxPayloadSize<=spareCapacity)
                        sentB=sentB+maxPayloadSize; 
                        spareCapacity=spareCapacity-maxPayloadSize;
                        currentlySentPackets=currentlySentPackets+1;
                        queueL=queueL-maxPayloadSize;
                                                                                                
                    %% Load first queue element (FIFO logic)
                        processQueueInfo=loadQueueInfo(ID); 
                        vec=[processQueueInfo.startingTime];
                        vec(vec<=0) = NaN;
                        [findElement,findIndex]=min(vec);
                        %% Check link status
                        if currentLinkActive==true 
                            %% Set ending time only if packet isn t lost
                            processQueueInfo(findIndex).endingTime=index;
                            %% Save queueing time as ending-starting time (as number of consecutive timeInstants)
                            findElementTime=find(processQueueTimeInfo==0);
                            processQueueTimeInfo(findElementTime(1))=processQueueInfo(findIndex).endingTime-processQueueInfo(findIndex).startingTime;
                            logFileDefinition(processQueueInfo(findIndex).startingTime,index,ID,currentLink);                           
                        end                        
                        %% Reset to -1 the values
                        processQueueInfo(findIndex).startingTime=-1;
                        processQueueInfo(findIndex).endingTime=-1;                                              
                        %% Save queueing computations
                        saveQueueInfo(ID,processQueueInfo);
                    else
                        emptyQueue=true;
                    end
                end
            end
        end
    end
    spareC=spareCapacity;        
    %% Save queueing computations
    saveQueueInfo(ID,processQueueInfo);
    
    %% Save queueing time
    saveQueueTimeInfo(ID,processQueueTimeInfo);    
end