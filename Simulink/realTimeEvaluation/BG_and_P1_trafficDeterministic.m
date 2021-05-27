%% NO BG and P1 traffic
P1sTraffic=zeros(timeInstants+1,2);
P1sTraffic(:,1)=time;
P1sTraffic(:,2)=0;
P1sTraffic=round(P1sTraffic); 

valuesMatrixP1=zeros(timeInstants+1,2); 
valuesMatrixP1(:,1)=time;
valuesMatrixP1(:,2)=0;
valuesMatrixP1=round(valuesMatrixP1);

Link1sTraffic=zeros(timeInstants+1,2);
Link1sTraffic(:,1)=time;
Link1sTraffic(:,2)=0;
Link1sTraffic=round(Link1sTraffic);

Link2sTraffic=zeros(timeInstants+1,2);
Link2sTraffic(:,1)=time;
Link2sTraffic(:,2)=0;
Link2sTraffic=round(Link2sTraffic);

valuesMatrixBackGround=zeros(timeInstants+1,m+1);
valuesMatrixBackGround(:,1)=time;
valuesMatrixBackGround(:,2:m+1)=0;
valuesMatrixBackGround=round(valuesMatrixBackGround);

valuesMatrixLink1BG=zeros(timeInstants+1,2); 
valuesMatrixLink1BG(:,1)=time;
valuesMatrixLink1BG(:,2)=0;
valuesMatrixLink2BG=zeros(timeInstants+1,2); 
valuesMatrixLink2BG(:,1)=time;
valuesMatrixLink2BG(:,2)=0;