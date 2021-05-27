function processQueueTime=loadQueueTimeInfo(ID)
    processQueueTime=0;
    if(strcmp(ID,'P1')==true)
        processQueueTime=evalin('base','queueingTimeP1');  
    else
        processQueueTime=evalin('base','queueingTimeBG');        
    end
end