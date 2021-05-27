function saveQueueInfo(ID,processQueueInfo)
    currentLink=0;
    currentLink=evalin('base','currentLink');    
    if(strcmp(ID,'P1')==true)
        if(currentLink==1)
            assignin('base','P1Link1QueueInfo',processQueueInfo);  
        else
            assignin('base','P1Link2QueueInfo',processQueueInfo);  
        end
    else
        if(currentLink==1)
            assignin('base','BGLink1QueueInfo',processQueueInfo);  
        else
            assignin('base','BGLink2QueueInfo',processQueueInfo);  
        end
    end
end