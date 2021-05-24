%
% Model HeatFlow
% Numerical solution of the 1D heat diffusion equation
% Jan, 2003 by Tessa van Wijnen and Willem Bouten
%
%%%%%%%%%%%%% INITIALISATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

clear all
% Constants
Omega = 2*pi;
% Control Constants
StartTime= 0; % [day]
EndTime = 1; % [day]
dt = 0.001; % [day]
PlotStep = 0.02; % [day]
StoreStep = 0.01; % [day]
ThickL = 0.02; % [m]
NrLayer = 25;
% System Parameters
HeatCap = 2.5e5; % [J/oC/m3]
Conduc = 8640; % [J/oC/m/dag]
SurfAvTp = 20; % [oC]
SurfAmp = 10; % [oC]
% Control Variables
NrStore = 1;
PlotTime = PlotStep;
StoreTime = StoreStep;
Time = StartTime;
% System Variables
SurfTp = SurfAvTp;
Flow = zeros(NrLayer+1,1);
Temp = ones(1,NrLayer)*SurfAvTp;
HeatCont(1:NrLayer) = Temp(1:NrLayer)*HeatCap*ThickL;
%%%%%%%%%%%%% DYNAMIC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while Time < EndTime
% Dynamic boundary conditions
SurfTp = SurfAvTp+(SurfAmp*sin(Omega*Time)) ;
Flow(1) = Conduc*(Temp(1)-SurfTp)/(0.5*ThickL);
Flow(NrLayer+1) = 0;
% Rates: Flow and net flow calculations
for k = 2 : NrLayer
Flow(k) = Conduc*(Temp(k)-Temp(k-1))/ThickL;
end
% this for-loop could also be replaced by:
% Flow(2:NrLayer) = (Temp(2:NrLayer)-Temp(1:NrLayer-1))*Conduc/ThickL;
for k = 1 : NrLayer
NFlow(k) = Flow(k+1) - Flow(k);
end
% States: Integration step
for k = 1 : NrLayer
HeatCont(k) = HeatCont(k) + NFlow(k)*dt;
Temp(k) = HeatCont(k)/(HeatCap*ThickL);
end
Time = Time+dt;
%%%%%%%%%%%%%%%% STORING AND VISUALIZATION %%%%%%%%%%%%%%%%%
StoreTime = StoreTime - dt;
if StoreTime <= 0
StoreTemp(NrStore,:) = [Time Temp];
NrStore = NrStore+1;
StoreTime = StoreStep;
end %if StoreTime <= 0
% These statements should be activated for dynamic visualization
% PlotTime = PlotTime-dt;
% if PlotTime <= 0
% ImTemp= rot90(Temp,3);
% imagesc(ImTemp,[10 30]),colorbar
% xlabel(Time)
% pause(0.2)
% PlotTime = PlotStep;
% end % if PlotTime <= 0
end %while Time < EndTime

plot(StoreTemp(:,2:26))

toc
% save the simulation results in a file
save storetemp.txt StoreTemp -ascii


