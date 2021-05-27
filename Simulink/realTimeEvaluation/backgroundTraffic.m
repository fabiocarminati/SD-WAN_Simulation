%% Generate background traffic starting from (M,P,S) model described in https://ieeexplore.ieee.org/document/644399
%% Phase M
muLow=log((23.49^2)/sqrt(96.67+23.49^2)); 
sigmaLow = sqrt(log(96.67/(23.49^2)+1)); 

%% Traffic scenario
arrivedPackets = (0:1:140);
switch backgroundTrafficPattern
    case 1
        %% Low traffic scenario
        mu_=3.07586;
        sigma_=sqrt(0.161435);    
    case 2 
        %% Medium traffic scenario
        mu_=3.78867;
        sigma_=sqrt(0.0868934);
    case 3
        %% High traffic scenario
        mu_=4.07081;
        sigma_=sqrt(0.0712557);
end      
backgroundTrafficDist=makedist('Lognormal','mu',mu_,'sigma',sigma_);
backgroundTrafficPDF = pdf(backgroundTrafficDist,arrivedPackets);

%% Phase P 
tao=singleSimulationTime/2; %seconds
timeStepsTao = tao/simulationStepTime; %% number of iterations done by simulink within tao 
numberOfTimeInstantsOfWANArrivals=simTime/tao; 

rng('shuffle','twister'); %seed 
X = lognrnd(mu_,sigma_,[numberOfTimeInstantsOfWANArrivals 1]);
X=round(X);
Y = zeros(m,1); 
maxArrivals=140; 
lambda=zeros(m,maxArrivals+1);
mu=zeros(m,maxArrivals+1);
   
lambda(:,:)=0.6;
mu(:,:)=0.4;
%lambda(1,:)=0.5;
%mu(1,:)=0.5;
packetsStreams=zeros(numberOfTimeInstantsOfWANArrivals,m);
rng('shuffle','twister');
randomBehaviour=rand(1,(timeStepsTao-1)*numberOfTimeInstantsOfWANArrivals);
successProbabilityBackground=zeros(numberOfTimeInstantsOfWANArrivals,m); 

for j=1:numberOfTimeInstantsOfWANArrivals
    sij=zeros(m,1);
    for i=1:m
        %% Markov chain i
        [tjump, state]=birthDeathProcess(timeStepsTao,lambda(i,:),mu(i,:),maxArrivals,m,randomBehaviour(1,(j-1)*(timeStepsTao-1)+1:(j*(timeStepsTao-1))));
        sij(i,1)=state(1,timeStepsTao); 
    end    
    sumStates=sum(sij,1);
    residualPackets=X(j);
    for w=1:m
        packetsStreams(j,w)=X(j)*(sij(w,1)/sumStates);
        packetsStreams(j,w)= round(packetsStreams(j,w));
        successProbabilityBackground(j,w)=packetsStreams(j,w)/timeStepsTao;
    end
end