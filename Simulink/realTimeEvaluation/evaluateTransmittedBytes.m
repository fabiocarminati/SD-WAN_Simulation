function[queueLP1,queueLBG,sentB,extraLostB,extraLostB1,sentP1,currentlySentPackets]= evaluateTransmittedBytes(queueMaxSize,sentBytes,P1Traffic,BGTraffic,queueLengthTotP1,queueLengthTotBG,linkCapacity,maxPayloadSize)
    extraLostBytes=0; 
    extraLostB1=0;
    extraLostBG=0;
    sentP1=0;        
    %% Evaluate queueing time
    queueingTimeP1=0;
    queueingTimeP1=evalin('base','queueingTimeP1');
    queueingTimeBG=0;
    queueingTimeBG=evalin('base','queueingTimeBG');        
    sentB1=0; 
    sentBG=0;
    sentB=sentBytes; 
    sentB1Tot=0; 
    sentBGTot=0;
    spareCapacity=linkCapacity;
    queueLP1=queueLengthTotP1;
    queueLBG=queueLengthTotBG;
    queueLBackground=queueLengthTotBG;    
    currentlySentPackets=0;
    currentlySentPkts=0;
    [sentB1,spareCapacity,queueLProcess1,currentlySentPkts]=txQueuePackets(currentlySentPackets,spareCapacity,queueLengthTotP1,maxPayloadSize,'P1');
    currentlySentPackets=currentlySentPkts;
    [sentBG,spareCapacity,queueLBackground,currentlySentPkts]=txQueuePackets(currentlySentPackets,spareCapacity,queueLengthTotBG,maxPayloadSize,'BG');
    currentlySentPackets=currentlySentPkts;
    if(P1Traffic>0)
        [sentB1Tot,spareCapacity,queueLP1,extraLostB1,currentlySentPkts]=handleNewPackets(currentlySentPackets,queueMaxSize,P1Traffic,maxPayloadSize,sentB1,spareCapacity,queueLProcess1,'P1');
    else
        queueLP1=queueLProcess1;
    end
    currentlySentPackets=currentlySentPkts;
    if(BGTraffic>0)
        [sentBGTot,spareCapacity,queueLBG,extraLostBG,currentlySentPkts]=handleNewPackets(currentlySentPackets,queueMaxSize,BGTraffic,maxPayloadSize,sentBG,spareCapacity,queueLBackground,'BG');        
    else
        queueLBG=queueLBackground;
    end
    currentlySentPackets=currentlySentPkts;
    extraLostB=extraLostB1+extraLostBG; 
    if(P1Traffic==0 && BGTraffic==0) 
        sentB=sentB+sentB1+sentBG;
        sentP1=sentB1;
    else
        if(P1Traffic==0 && BGTraffic>0)
            sentP1=sentB1;
            sentB=sentB+sentB1+sentBGTot;
        else
            if(P1Traffic>0 && BGTraffic==0)
                sentP1=sentB1Tot;
                sentB=sentB+sentB1Tot+sentBG;
            else
                sentP1=sentB1Tot;
                sentB=sentB+sentB1Tot+sentBGTot;
            end
        end            
    end
end