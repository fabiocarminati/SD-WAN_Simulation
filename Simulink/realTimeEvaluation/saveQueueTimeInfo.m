function saveQueueTimeInfo(ID,processQueueTime)
    if(strcmp(ID,'P1')==true)
        assignin('base','queueingTimeP1',processQueueTime);  
    else
        assignin('base','queueingTimeBG',processQueueTime);         
    end
end