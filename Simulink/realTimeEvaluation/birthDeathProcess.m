%% Markov Chain evolution
%Developed starting from:  Ingemar Kaj Raimundas Gaigalas (2021). Simulation of Stochastic Processes (https://www.mathworks.com/matlabcentral/fileexchange/2493-simulation-of-stochastic-processes), MATLAB Central File Exchange. Retrieved February 1, 2021.
function [tjump, state] = birthDeathProcess(npoints, flambda, fmu,maxArrivals,m,randomBehaviour)
% BIRTHDEATH generate a trajectory of a birth-death process 
%
% [tjump, state] = birthdeath(npoints[, flambda, fmu])
%
% Inputs: npoints - length of the trajectory ---> quanti time step devo
% considerare (per quanto tempo guardo la Markov Chain)
%         flambda - optional, an inline function to compute the
%           birth intensity at a point. Default
%           flambda = inline('5/(1+i)', 'i');
%         fmu - optional, an inline function to compute the
%           death intensity at a point. Default
%           fmu = inline('i', 'i');
%
% Outputs: tjump - jump times
%          state - states of the embedded Markov chain
% Authors: R.Gaigalas, I.Kaj
% v1.2 04-Oct-02

  % default parameter values if ommited
  if (nargin==1)
    flambda = inline('5/(1+i)', 'i');
    fmu = inline('i', 'i');    
  end
  
  i=round((maxArrivals/m));     %initial value, start on level i
  tjump(1)=0;  %start at time 0
  state(1)=i;  %at time 0: level i
    
  for k=2:npoints 
     lambda_i=flambda(i+1); 
     mu_i=fmu(i+1);     
     % 0.2 = simulationStepTime
     time=0.2*(k-1);      % Inter-step times:Exp(lambda_i+mu_i)-distributed
    %% Lower limit = 0; upper limit =maxArrivals
    if randomBehaviour(1,k-1)<=lambda_i./(lambda_i+mu_i)
       if(i<maxArrivals)  
         i=i+1;   
       end
    else
        if(i>0)  
            i=i-1; 
        end
    end          
     state(k)=i;
     tjump(k)=time;
  end              
  tjump=cumsum(tjump);     %cumulative jump times
     
