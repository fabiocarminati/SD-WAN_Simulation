function convergenceIterations()
    %% Load variables and arrays
    timeInstants=0;
    timeInstants=evalin('base','timeInstants');
    minimumRepetitionsConsidered=0;
    minimumRepetitionsConsidered=evalin('base','minimumRepetitionsConsidered');
    numberOfRepetitions=0;
    numberOfRepetitions=evalin('base','numberOfRepetitions');
    firstValidSimulation=0;
    firstValidSimulation=evalin('base','firstValidSimulation');
    
    deterministicPathAvailabilityVector=0;
    deterministicPathAvailabilityVector=evalin('base','deterministicPathAvailabilityVector');
    deterministicTimeInstantsPathAvailability=0;
    deterministicTimeInstantsPathAvailability=evalin('base','deterministicTimeInstantsPathAvailability');
    deterministicTimeInstantsSystemAvailability=0;
    deterministicTimeInstantsSystemAvailability=evalin('base','deterministicTimeInstantsSystemAvailability');
    deterministicSystemAvailabilityVector=0;
    deterministicSystemAvailabilityVector=evalin('base','deterministicSystemAvailabilityVector');
    deterministicPercentageSentP1Bytes=0;
    deterministicPercentageSentP1Bytes=evalin('base','deterministicPercentageSentP1Bytes');
    deterministicSentP1Links=0;
    deterministicSentP1Links=evalin('base','deterministicSentP1Links');
    
    casualPathAvailabilityVector=0;
    casualPathAvailabilityVector=evalin('base','casualPathAvailabilityVector');
    casualTimeInstantsPathAvailability=0;
    casualTimeInstantsPathAvailability=evalin('base','casualTimeInstantsPathAvailability');
    casualTimeInstantsSystemAvailability=0;
    casualTimeInstantsSystemAvailability=evalin('base','casualTimeInstantsSystemAvailability');
    casualSystemAvailabilityVector=0;
    casualSystemAvailabilityVector=evalin('base','casualSystemAvailabilityVector');
    casualPercentageSentP1Bytes=0;
    casualPercentageSentP1Bytes=evalin('base','casualPercentageSentP1Bytes');
    casualSentP1Links=0;
    casualSentP1Links=evalin('base','casualSentP1Links');
    accurate=false;
    percentageAccuracy=0.1;
    simulationNumber=0;
    simulationNumber=evalin('base','simulationNumber');       
    j=minimumRepetitionsConsidered; 
    %% Compute vector of the differences in the availability
    while j<=simulationNumber-firstValidSimulation+1 && accurate==false      
        absDifferencePathAvailability=abs(deterministicPathAvailabilityVector(1:j,1)-casualPathAvailabilityVector(1:j,1));            
        absDifferencePathTimeAvailability=abs(deterministicTimeInstantsPathAvailability(1:j,1)-casualTimeInstantsPathAvailability(1:j,1));            
        absDifferenceSystemAvailability=abs(deterministicSystemAvailabilityVector(1:j,1)-casualSystemAvailabilityVector(1:j,1));
        absDifferenceSystemTimeAvailability=abs(deterministicTimeInstantsSystemAvailability(1:j,1)-casualTimeInstantsSystemAvailability(1:j,1));                   
        if(var(absDifferencePathAvailability)<=mean(absDifferencePathAvailability)*percentageAccuracy && var(absDifferenceSystemAvailability)<= mean(absDifferenceSystemAvailability)*percentageAccuracy )
            accurate=true;
            accurateRepetitions=j+firstValidSimulation-1; 
        end
        j=j+1;
    end
    fprintf("<strong> \n Mean path availability </strong> of the difference:%f \n",mean(absDifferencePathAvailability));
    fprintf("<strong> Path availability variance </strong> of the difference:%f \n",var(absDifferencePathAvailability));
    fprintf("<strong> Mean system availability </strong> of the difference:%f \n",mean(absDifferenceSystemAvailability));
    fprintf("<strong> System availability variance </strong> of the difference:%f \n",var(absDifferenceSystemAvailability));
    fprintf("\nTotal simulation INSTANTS:%f \n",timeInstants+1);
    fprintf("<strong>        Mean path availability INSTANTS </strong> of the difference:%f \n",mean(absDifferencePathTimeAvailability));
    fprintf("<strong>        Path availability INSTANTS variance </strong> of the difference:%f \n",var(absDifferencePathTimeAvailability));
    fprintf("<strong>        Mean system availability INSTANTS</strong> of the difference:%f \n",mean(absDifferenceSystemTimeAvailability));
    fprintf("<strong>        System availability INSTANTS variance  </strong> of the difference:%f \n",var(absDifferenceSystemTimeAvailability));

    fprintf("\n<strong> DETERMINISTIC </strong> SENT <strong> P1 </strong> bytes percentage:%f %% \n",deterministicPercentageSentP1Bytes(1,1));
    fprintf("-  <strong> Of this P1 Percentage </strong>:%f %% of  SENT bytes  a fraction of:%f %% has gone through link1, a fraction of:%f %% through link2 \n",deterministicPercentageSentP1Bytes(1,1),deterministicSentP1Links(1,1),deterministicSentP1Links(2,1));
    fprintf("\n<strong> CASUAL </strong> SENT <strong> P1 </strong> bytes percentage:%f %% \n",casualPercentageSentP1Bytes(1,1));
    fprintf("-  <strong> Of this P1 Percentage </strong>:%f %% of  SENT bytes  a fraction of:%f %% has gone through link1, a fraction of:%f %% through link2 \n",casualPercentageSentP1Bytes(1,1),casualSentP1Links(1,1),casualSentP1Links(2,1));
    if (accurate==true)
        accurateRepetitions=accurateRepetitions-firstValidSimulation+1;
        fprintf("\n<strong> DETERMINISTIC </strong> - from: %f to :%f repetition, the mean path availability is:%f and the variance is:%f \n",firstValidSimulation,accurateRepetitions+firstValidSimulation-1,mean(deterministicPathAvailabilityVector(1:accurateRepetitions,1)),var(deterministicPathAvailabilityVector(1:accurateRepetitions,1)));
        fprintf("<strong> CASUAL </strong> - from: %f to :%f repetition, the mean path availability:%f and the variance is:%f \n",firstValidSimulation,accurateRepetitions+firstValidSimulation-1,mean(casualPathAvailabilityVector(1:accurateRepetitions,1)),var(casualPathAvailabilityVector(1:accurateRepetitions,1)));
        fprintf("After <strong> N repetitions=%f </strong> we are accurate enough;stop convergence control; variance percentage w.r.t. mean is:%f %% \n",accurateRepetitions+firstValidSimulation-1,var(absDifferencePathAvailability)/mean(absDifferencePathAvailability)*100);
        assignin('base','anticipateEndingSimulation',true);
    else
        accurateRepetitions=simulationNumber-firstValidSimulation+1;
        fprintf("\n<strong> DETERMINISTIC </strong> - from: %f to :%f repetition, the mean path availability is:%f and the variance is:%f \n",firstValidSimulation,accurateRepetitions+firstValidSimulation-1,mean(deterministicPathAvailabilityVector(1:accurateRepetitions,1)),var(deterministicPathAvailabilityVector(1:accurateRepetitions,1)));
        fprintf("<strong> CASUAL </strong> - from: %f to :%f repetition, the mean path availability:%f and the variance is:%f \n",firstValidSimulation,accurateRepetitions+firstValidSimulation-1,mean(casualPathAvailabilityVector(1:accurateRepetitions,1)),var(casualPathAvailabilityVector(1:accurateRepetitions,1)));
        fprintf("Cannot find enough accurate after N repetitions:%f < N_max:%f; variance percentage w.r.t. mean is:%f %%\n",accurateRepetitions+firstValidSimulation-1,numberOfRepetitions,var(absDifferencePathAvailability)/mean(absDifferencePathAvailability)*100);
        fprintf("<strong>CONTINUE WITH NEW REPETITION </strong>\n");
    end
end