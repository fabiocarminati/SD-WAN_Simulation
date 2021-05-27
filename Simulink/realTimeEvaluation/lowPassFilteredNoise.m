%% Define B contribution as low-pass filtered Noise
fSampling=1/simulationStepTime; 
TResponse=CPE1SamplingInterval+delayCPE1Controller1+processTimeCPE1MonitoringInfo+processTimeController1+max(delayCPE1Controller1,delayCPE2Controller1)+processingTimeCPEUpdate;
if ww==1
    nameNoise1="No SD-WAN:Path 1-Noise";
    nameNoise2="No SD-WAN:Path 2-Noise";
else
    nameNoise1="With SD-WAN:Path 1-Noise";
    nameNoise2="With SD-WAN:Path 2-Noise";
end

switch filterType
    case "Lowpass"
        y1=lowpass(rand1,fPass,fSampling);
        y2=lowpass(rand2,fPass,fSampling);
    case "Highpass"
        y1=highpass(rand1,fPass,fSampling);
        y2=highpass(rand2,fPass,fSampling);
end

%% Evaluate white noise power spectral density (PSD) over link1
[pWhite1,wWHite1] = periodogram(rand1,[],length(rand1),fSampling,'one-side');
[p1,w1] = periodogram(y1,[],length(y1),fSampling,'one-side');
figure('NumberTitle','off','Name',nameNoise1)
    plot(wWHite1,10*log10(pWhite1))
    xlabel('Hz')
    ylabel('dB/Hz')
    hold on;
    plot(w1,10*log10(p1))
    hold on;
    xline(fPass,'-','fPass','LineWidth',1)
    xline(1/TResponse,'-','fReaction','LineWidth',1)
    title('Power spectral density')
    grid on;
    grid minor;
    legend('White Noise 1',string("Filtered Noise 1 up to: " +fPass+"Hz"))


%% Evaluate white noise power spectral density (PSD) over link2
[pWhite2,wWHite2] = periodogram(rand2,[],length(rand2),fSampling,'one-side');
[p2,w2] = periodogram(y2,[],length(y2),fSampling,'one-side');
figure('NumberTitle','off','Name',nameNoise2)
    plot(wWHite2,10*log10(pWhite2))
    xlabel('Hz')
    ylabel('dB/Hz')
    hold on;
    plot(w2,10*log10(p2))
    hold on;
    xline(fPass,'-','fPass','LineWidth',1)
    xline(1/TResponse,'-','fReaction','LineWidth',1)
    title('Power spectral density')
    legend('White Noise 2',string("Colored Noise 2 up to: " +fPass+"Hz"))
        grid on;
    grid minor;


%% Modify low-pass filtered noise in order to have same mean and same variance of the original white noise    
%% Step 1: Scaling to have same variance of the white noise
scaleValue1=sqrt(var(rand1)/var(y1));
scaleValue2=sqrt(var(rand2)/var(y2));
rand1Old=rand1;
rand2Old=rand2;
rand1=y1*scaleValue1;
rand2=y2*scaleValue2;

%% Step 2: shifting to have also same mean of the white noise
shiftValue1=mean(rand1Old)-mean(rand1);
shiftValue2=mean(rand2Old)-mean(rand2);
rand1=rand1+shiftValue1;
rand2=rand2+shiftValue2;

%% B contributions over link1
figure('NumberTitle','off','Name',"Path 1 noise contributions")
    plot(time(100/simulationStepTime:200/simulationStepTime),rand1Old(100/simulationStepTime:200/simulationStepTime))
    hold on;
    plot(time(100/simulationStepTime:200/simulationStepTime),rand1(100/simulationStepTime:200/simulationStepTime),'LineWidth',2)
    grid on;
    grid minor;
    xlabel('Simulation time (s)')
    ylabel('E2E delay in ms added')
    legend('White noise','Filtered noise')
    
%% B contributions over link2
figure('NumberTitle','off','Name',"Path 2 noise contributions")
    plot(time,rand2Old)
    hold on;
    plot(time,rand2)
    grid on;
    grid minor;
    xlabel('Simulation time (s)')
    ylabel('E2E delay in ms added')
    legend('White noise','Filtered noise') 