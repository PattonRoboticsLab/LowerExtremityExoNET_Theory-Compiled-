% ***********************************************************************
% Plot the ExoNET torques superimposed on the desired torques
% ***********************************************************************

function plotAngleTorque(S,exOn)
subplot(1,2,2)
plot(S.PHIs(:,3),S.TAUsDESIRED(:,1),'^','MarkerSize',5,'MarkerFaceColor','r','MarkerEdgeColor','r');
hold on
plot(S.PHIs(:,3),S.TAUsDESIRED(:,1),'r','LineWidth',2); %Desired
plot(S.PHIs(:,3),S.TAUs(:,1),'^','MarkerSize',5,'MarkerFaceColor','b','MarkerEdgeColor','b');
plot(S.PHIs(:,3),S.TAUs(:,1),'b','LineWidth',2); %ExoNET
xlabel({'Ankle Angle [deg]';'plantarflexion    dorsiflexion'}); ylabel({'Ankle Torque [Nm]';'plantarflexion    dorsiflexion'});
plot(S.PHIs(end,3),S.TAUsDESIRED(end,1),'.k'); % TOR
text(S.PHIs(end,3)+0.2,S.TAUsDESIRED(end,1)+0.6,'TOR');
xlim([min(S.PHIs(:,3)) max(S.PHIs(:,3))])

subplot(1,2,1); axis(); % to reframe the window
subplot(1,2,2); axis(); % to reframe the window

if exist('exOn','var')
    for element = 1:S.EXONET.nElements
        
        if S.EXONET.nJoints == 11
            plotColor = S.ColorsC;
        elseif S.EXONET.nJoints == 22
            plotColor = S.ColorsT; %2-joint element
        elseif S.EXONET.nJoints == 2
            plotColor = [S.ColorsC; S.ColorsT];
        end
        
        n = size(plotColor);
        
        for j = 1:n(1)
            plot(S.PHIs(:,3),S.EXONET.tau(:,1,element),'--','Color',plotColor(j,:),'LineWidth',1);
            plot(S.PHIs(:,3),S.TAUs(:,1),'b','LineWidth',2);
        end
    end
    
    box off
    title('Final Gait Torques Field for Late Stance')
    
end
if S.end == false
    title('Initial Guess')
end
end