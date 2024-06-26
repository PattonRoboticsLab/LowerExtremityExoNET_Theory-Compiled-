% ***********************************************************************
% MAIN SCRIPT TO DO THE ExoNET FOR A RIGHT LEG:
% The torque generated by the ExoNET is given by the sum of all the
% torques generated by each one of the MARIONETs
% ***********************************************************************
clear;clc;close all;

% BEGIN
fprintf('\n\n\n\n MAIN SCRIPT~~\n')

disp('Choose from the menu...')
fieldType = menu('Choose a field to approximate:', ...
    'Knee-Ankle Gait Torques', ...
    'Hip-Knee Gait Torques',...
    'Gait Stabilization',...
    'Leg Design Optimization',...
    'EXIT');

close all
S.end = false; % when it is at the end of optimzation

switch fieldType
    case 1 
        S.case = 1.1; % Knee-Ankle
        S = setUpLeg(S); % set variables and plots
        S = robustOptoLeg(S);
        e = S.TAUsDESIRED - S.TAUs;
    case 2 
        S.case = 1.2; %Hip-Ankle
        S = setUpLeg(S); % set variables and plots
        S = robustOptoLeg(S);
        e = S.TAUsDESIRED - S.TAUs;
        
        AveragePercentError = 100*(1-(norm(e)/norm(S.TAUsDESIRED)));
        %showGraphTorquesLeg(S)
    case 3
        S.case = 2;  %Gait stabilize
        S = setUpLeg(S); % set variables and plots
        drawArrows
        S = robustOptoLeg(S);
        e = S.AllTAUsDESIRED - S.TAUs; %uses all TAUs desired.
        
    case 4
        S.case = 3;  %Leg Opto
        S = designOpto(S);
    otherwise
        disp('exiting...');
        close all
        
end % end switch

GitCommit('commit changes')

fprintf('\n END MAIN SCRIPT~~\n')

