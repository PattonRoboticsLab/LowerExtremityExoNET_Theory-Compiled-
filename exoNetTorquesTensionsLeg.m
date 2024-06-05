% ***********************************************************************
% Calculate the torques and the tensions created by the ExoNET
% ***********************************************************************

function S = exoNetTorquesTensionsLeg(p,S,plotIt)

%% Setup
if ~exist('plotIt','var'); plotIt = 0; end   % if plotIt argument not passed
TAUs = zeros(size(S.PHIs,1),2); % initialization
%if plotIt; cf = gcf(); figure; end           % add cf and create another figure


%% Find torques
for i = 1:size(S.PHIs,1)

if S.EXONET.nJoints == 11
    tau = 0;
    for element = 1:S.EXONET.nElements
        S = findParameters(S.ankleIndex, p, element, S);
        S = tauMarionetLeg(S, i, 0);
        S.EXONET.tau(i,1,element) = S.tau;
        S.EXONET.T(i,1,element) = S.T;
        S.EXONET.Tdist(i,1,element) = S.Tdist;
        
        if plotIt
            plot(S.ColorsC, S.Tension1j, i, S, 1); 
        end
        tau = tau + S.tau; % + element's torque
    end
    TAUs(i,1) = tau; % torque created by the ankle MARIONET
end


if S.EXONET.nJoints == 22
    taus = [0 0];
    
        for element = 1:S.EXONET.nElements
        S = findParameters(S.ankleIndex, p, element, S);
        S = tauMarionetLeg(S, i, 1);
        S.EXONET.tau(i,1,element) = S.tau(2);
        S.EXONET.T(i,1,element) = S.T;
        S.EXONET.Tdist(i,1,element) = S.Tdist;
        
        if plotIt
            plot(S.ColorsT, S.Tension2j, i, S, 1);
        end
        taus = taus + S.tau; % + element's torque
        end
    TAUs(i,1) = TAUs(i,1) + taus(2); % torque created by the knee-toe MARIONET on the ankle
    TAUs(i,2) = taus(1); % torque created by the knee-toe MARIONET on the knee
end

if S.EXONET.nJoints == 2
    tau = 0;
    for element = 1:S.EXONET.nElements
        S = findParameters(S.ankleIndex,p, element, S);
        S = tauMarionetLeg(S, i, 0);
        S.EXONET.tau(i,1,element) = S.tau;
        S.EXONET.T(i,1,element) = S.T;
        S.EXONET.Tdist(i,1,element) = S.Tdist;
        
        if plotIt
            plot(S.ColorsC, S.Tension1j, i, S, 1);
        end
        tau = tau + S.tau;
    end
    TAUs(i,1) = tau; % torque created by the ankle MARIONET
    
    taus = [0 0];
    for element = 1:S.EXONET.nElements
        S = findParameters(S.kneeFootIndex,p, element, S);
        S = tauMarionetLeg(S, i, 1);
        S.EXONET.tau(i,2,element) = S.tau(2);
        S.EXONET.T(i,2,element) = S.T;
        S.EXONET.Tdist(i,2,element) = S.Tdist;
        
        if plotIt
            plot(S.ColorsT, S.Tension2j, i, S, 2);
        end
        
        taus = taus + S.tau;
    end
    TAUs(i,1) = TAUs(i,1) + taus(2); % torque created by the knee-toe MARIONET on the ankle
    TAUs(i,2) = taus(1); % torque created by the knee-toe MARIONET on the knee
end 

%if plotIt; figure(cf); end

end

end

function plot(Colors, y, i, S, n) %n is the second position in the tau, T, and Tdist 

if S.Spring == 1 %Compression
    stretch_min = min(S.EXONET.Tdist(i,n,element));
    x = stretch_min:0.001:S.EXONET.pConstraint(3,2)+0.1;
elseif S.Spring == 0 %Tension
    stretch_max = max(S.EXONET.Tdist(i,n,element));
    x = 0:0.001:stretch_max;
end

plot(x,y,'Color',Colors,'LineWidth',2.5)
hold on
yline(0)
plot(S.EXONET.Tdist(i,n,element),S.EXONET.T(i,n,element),'o','MarkerSize',...
    7,'MarkerFaceColor',Colors,'MarkerEdgeColor','w')
xlabel('L [m]')
ylabel('Tension [N]')
title('Tension exerted by each elastic element with respect to its length')
box off

end
