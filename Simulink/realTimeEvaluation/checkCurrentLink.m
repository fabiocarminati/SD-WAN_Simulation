function checkCurrentLink()
    coder.extrinsic('evalin', 'assignin');  
    ControllerLink1Status=0; 
    ControllerLink1Status= evalin('base','ControllerLink1Status'); 
    ControllerLink2Status=0; 
    ControllerLink2Status= evalin('base','ControllerLink2Status');    
    CPE1link1Status=0; 
    CPE1link1Status= evalin('base','CPE1link1Status'); 
    CPE1link2Status=0; 
    CPE1link2Status= evalin('base','CPE1link2Status');    
    CPE2link1Status=0; 
    CPE2link1Status= evalin('base','CPE2link1Status'); 
    CPE2link2Status=0; 
    CPE2link2Status= evalin('base','CPE2link2Status');             
    indexValuesLink1=0;
    indexValuesLink1=evalin('base','indexValuesLink1');
    link1Status=0;
    link1Status=evalin('base','valuesLink1Matrix(indexValuesLink1,2)');
    assignin('base','indexValuesLink1',indexValuesLink1+1);
    link1MaxThreshold=0;
    link1MaxThreshold=evalin('base','link1MaxThreshold');
    indexValuesLink2=0;
    indexValuesLink2=evalin('base','indexValuesLink2');
    link2Status=0;
    link2Status=evalin('base','valuesLink2Matrix(indexValuesLink2,2)');
    assignin('base','indexValuesLink2',indexValuesLink2+1);
    link2MaxThreshold=0;
    link2MaxThreshold=evalin('base','link2MaxThreshold');    
    assignin('base','index',indexValuesLink2);     
    currentLink=0;
    currentLinkActive=true;
    checkLink1=true;  
    lossesDueToTransaction=false;
    if(link1Status<link1MaxThreshold)
        checkLink1=false;
    else
        lossesDueToNoise=0;
        lossesDueToNoise=evalin('base','lossesDueToNoise');
        assignin('base','lossesDueToNoise',lossesDueToNoise+1);
    end
    
    if(checkLink1==false) 
        if(ControllerLink1Status==1 && CPE1link1Status==1 && CPE2link1Status==1)
            currentLink=1;
            currentLinkActive=true;            
        else 
            if(ControllerLink2Status==1 && CPE1link2Status==1 && CPE2link2Status==1)                
                if(link2Status>link2MaxThreshold) 
                    currentLink=2;
                    currentLinkActive=false;
                else 
                    currentLink=2;
                    currentLinkActive=true;                   
                end
            else     
                currentLink=2;
                currentLinkActive=false;
                lossesDueToTransaction=true;
            end
        end
    else 
        if(ControllerLink2Status==1)
            if(CPE1link2Status==1 && CPE2link2Status==1)             
                if(link2Status>link2MaxThreshold)
                    currentLink=2;
                    currentLinkActive=false;
                else 
                    currentLink=2;
                    currentLinkActive=true;
                end
            else                
                currentLink=2;
                currentLinkActive=false;
                lossesDueToTransaction=true;
            end
        else            
            currentLink=1;
            currentLinkActive=false;
        end
    end
       
   %% Evaluate system unAvailability
   if((ControllerLink1Status==CPE1link1Status && ControllerLink1Status==CPE2link1Status) || (ControllerLink2Status==CPE1link2Status && ControllerLink2Status==CPE2link2Status))
        fprintf("");
   else
        timeInstantsOfSystemUnavailability=0;
        timeInstantsOfSystemUnavailability =evalin('base','timeInstantsOfSystemUnavailability');
        assignin('base','timeInstantsOfSystemUnavailability',timeInstantsOfSystemUnavailability+1);
   end
   %% Evaluate path unAvailability 
    if(currentLinkActive==false)
        timeInstantsOfPathUnavailability=0;
        timeInstantsOfPathUnavailability =evalin('base','timeInstantsOfPathUnavailability');
        assignin('base','timeInstantsOfPathUnavailability',timeInstantsOfPathUnavailability+1);
    end
    assignin('base','currentLink',currentLink);
    assignin('base','currentLinkActive',currentLinkActive);
    assignin('base','lossesDueToTransaction',lossesDueToTransaction);
end