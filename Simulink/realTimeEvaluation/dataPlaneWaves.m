%% Packet forwarding evaluation 
function dataPlaneWaves()
    coder.extrinsic('evalin', 'assignin');
    %% Load variables and arrays
    valuesLink1Matrix=0;
    valuesLink1Matrix=evalin('base','valuesLink1Matrix');
    valuesLink2Matrix=0;
    valuesLink2Matrix=evalin('base','valuesLink2Matrix');    
    currentLink=0;
    currentLink=evalin('base','currentLink');
    currentLinkActive=0;
    currentLinkActive=evalin('base','currentLinkActive');    
    lossesDueToTransaction=0;
    lossesDueToTransaction=evalin('base','lossesDueToTransaction');    
    index=0;
    index=evalin('base','index');
    currentP1Traffic=0;
    currentP1Traffic=evalin('base','P1sTraffic(index,2)');     
    maxPayloadSize=0;
    maxPayloadSize=evalin('base','maxPayloadSize');
    queueMaxSize=0;
    queueMaxSize=evalin('base','queueMaxSize');
    currentBGTraffic=0;
    currentLinkCapacity=0;
    if(currentLink==1)
        currentBGTraffic=evalin('base','Link1sTraffic(index,2)');
        currentLinkCapacity=evalin('base','link1Capacity');
    else
        currentBGTraffic=evalin('base','Link2sTraffic(index,2)');
        currentLinkCapacity=evalin('base','link2Capacity');
    end
    
    currentLinkStats=0;
    currentLinkStats=evalin('base','linksStatisticsSingle');
    sentB=0;
    lostB=0;
    queueLengthP1=0;
    queueLengthBG=0;
    sentP1=0;
    extraLostB=0;
    extraLostB1=0;
    eml.extrinsic('evaluateTransmittedBytesWaves');            
    currentlySentPackets=0;
    
    if(currentLinkActive==true)   
        lostB=currentLinkStats(currentLink).lostBytes;
        [queueLengthP1,queueLengthBG,sentB,extraLostB,extraLostB1,sentP1,currentlySentPackets]=feval('evaluateTransmittedBytesWaves',queueMaxSize,currentLinkStats(currentLink).sentBytes,currentP1Traffic,currentBGTraffic,currentLinkStats(currentLink).queueP1,currentLinkStats(currentLink).queueBG,currentLinkCapacity,maxPayloadSize);
        if extraLostB>0      
            timeInstantsOfPathUnavailability=0;
            timeInstantsOfPathUnavailability=evalin('base','timeInstantsOfPathUnavailability');
            assignin('base','timeInstantsOfPathUnavailability',timeInstantsOfPathUnavailability+1);            
            extraPathLossesInstants=0;
            extraPathLossesInstants=evalin('base','extraPathLossesInstants');
            assignin('base','extraPathLossesInstants',extraPathLossesInstants+1);
            if(currentLink==1)
                valuesLink1Matrix=0;
                valuesLink1Matrix=evalin('base','valuesLink1Matrix');
                valuesLink1Matrix(index,2)=0;
                assignin('base','valuesLink1Matrix',valuesLink1Matrix);
            else
                valuesLink2Matrix=0;
                valuesLink2Matrix=evalin('base','valuesLink2Matrix');
                valuesLink2Matrix(index,2)=0;
                assignin('base','valuesLink2Matrix',valuesLink2Matrix);
            end
        end        
    else
        sentB=currentLinkStats(currentLink).sentBytes;
        [queueLengthP1,queueLengthBG,lostB,extraLostB,extraLostB1,sentP1,currentlySentPackets]=feval('evaluateTransmittedBytesWaves',queueMaxSize,currentLinkStats(currentLink).lostBytes,currentP1Traffic,currentBGTraffic,currentLinkStats(currentLink).queueP1,currentLinkStats(currentLink).queueBG,currentLinkCapacity,maxPayloadSize);
        currentlySentPackets=0;
    end
    
    lostB=lostB+extraLostB;

    %% After Transmission            
    currentLinkStats(currentLink).lostBytes=lostB;
    currentLinkStats(currentLink).sentBytes=sentB;
    currentLinkStats(currentLink).queueP1=queueLengthP1;
    currentLinkStats(currentLink).queueBG=queueLengthBG;
    currentLinkStats(currentLink).sentP1=sentP1+currentLinkStats(currentLink).sentP1; 
    assignin('base','linksStatisticsSingle',currentLinkStats);
    
    totTrafficP1BG=0;
    totTrafficP1BG=evalin('base','totTrafficP1BG');
    totTrafficP1BG=totTrafficP1BG+currentP1Traffic+currentBGTraffic;
    assignin('base','totTrafficP1BG',totTrafficP1BG);
    if(totTrafficP1BG~=currentLinkStats(1).queueBG+currentLinkStats(1).queueP1+currentLinkStats(1).lostBytes+currentLinkStats(1).sentBytes+currentLinkStats(2).lostBytes+currentLinkStats(2).sentBytes+currentLinkStats(2).queueBG+currentLinkStats(2).queueP1)
        error("LOST+SENT!=%f, total==%f",currentLinkStats(1).queueBG+currentLinkStats(1).queueP1+currentLinkStats(1).lostBytes+currentLinkStats(1).sentBytes+currentLinkStats(2).lostBytes+currentLinkStats(2).sentBytes+currentLinkStats(2).queueBG+currentLinkStats(2).queueP1,totTrafficP1BG);                
    end
    
%% E2E Delay adjustments               
    currentlySentPacketsArray=0;
    currentlySentPacketsArray=evalin('base','currentlySentPacketsArray');
    currentlySentPacketsArray(index,1)=currentlySentPackets;
    assignin('base','currentlySentPacketsArray',currentlySentPacketsArray);
    
    currentLinkVector=0;
    currentLinkVector=evalin('base','currentLinkVector');
    currentLinkVector(index,1)=currentLink;
    assignin('base','currentLinkVector',currentLinkVector);    
end