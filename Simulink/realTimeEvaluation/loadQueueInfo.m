function processQueueInfo=loadQueueInfo(ID)
    currentLink=0;
    currentLink=evalin('base','currentLink');
    processQueueInfo=0;
    if(strcmp(ID,'P1')==true)
        if(currentLink==1)
            processQueueInfo=evalin('base','P1Link1QueueInfo');  
        else
            processQueueInfo=evalin('base','P1Link2QueueInfo');  
        end
    else

        if(currentLink==1)
            processQueueInfo=evalin('base','BGLink1QueueInfo'); 
        else
            processQueueInfo=evalin('base','BGLink2QueueInfo');
        end
    end
end