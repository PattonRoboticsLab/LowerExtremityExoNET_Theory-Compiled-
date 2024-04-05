% ***********************************************************************
% Draw individual MARIONETs for the leg pose specified by phis
% ***********************************************************************
function S = drawExonetsLeg(p,S)
fprintf('\n\n\n\n Drawing MARIONETs~~\n')
legendLabels = cell(1, S.EXONET.nElements);  % Preallocate legendLabels cell array

% Loop through all MARIONETs
if S.case == 1.1
    %=======================should this be hard set?======================%
    %hip =   [0      0];
    knee =  [0     -0.4451];
    ankle = [0.02  -1.03];
    toe =   [0.30367  -1.129];
    %=====================================================================%
    
    ankleIndex = 1;
    kneeFootIndex = S.EXONET.nParameters*S.EXONET.nElements+1;
    
    for element = 1:S.EXONET.nElements
        for j = 1:length(S.flag)
            if S.flag(j) == 0
                strElement = ' Ankle element ';
                bodyPart = ankle;
                plotColor = S.ColorsC;
                plotNum = 1;
                S = findParameters(ankleIndex,p, element,S);
            elseif S.flag(j) == 1
                strElement = ' Knee element ';
                bodyPart = knee;
                plotColor = S.ColorsT;
                plotNum = 3;
                S = findParameters(kneeFootIndex,p,element,S);
            end
            fprintf(strElement, element);
            
            rPos = bodyPart + [S.Parameters(1)*sind(S.Parameters(2)) -S.Parameters(1)*cosd(S.Parameters(2))]; % R vector
            plot([rPos(1) toe(1)], [rPos(2) toe(2)], 'Color', plotColor, 'Linewidth', S.LWs); %bungee
            plot([bodyPart(1) rPos(1)], [bodyPart(2) rPos(2)], 'Color', S.ColorsS(plotNum,:), 'Linewidth', S.LWr); %rod
            
        end
        if S.end == true
            pp = p;
            for i = 1:3:length(pp)  % for loop to print the values of the optimal parameters
                if abs(pp(i+1))>360 % to adjust the angle theta if it's higher than 360 degrees
                    while abs(pp(i+1))>360
                        pp(i+1) = sign(pp(i+1))*(abs(pp(i+1))-360);
                    end
                end
                if pp(i)<0          % if r is negative
                    pp(i) = pp(i)*(-1);
                    pp(i+1) = pp(i+1)+180;
                end
            end
            ppp = pp;
            for i = 2:3:length(ppp)
                if abs(ppp(i))>360 % to adjust the angle theta if it's higher than 360 degrees
                    while abs(ppp(i))>360
                        ppp(i) = sign(ppp(i))*(abs(ppp(i))-360);
                    end
                end
            end
            
            fprintf('\n\n\n\n The Optimal Parameters for each Element are~~\n')
            n = 1;
            for i = 1:3:length(ppp)  % to print the values of the optimal parameters
                fprintf('\n Element %d\n',n)
                fprintf('\n r = %4.3f m   theta = %4.2f deg   L0 = %4.3f m\n',ppp(i),ppp(i+1),ppp(i+2))
                S.Parameters(n,:) = ppp(i:i+2);
                n = n+1;
            end
            lenElement = size(S.Parameters);
            i = 1;
            while i <= lenElement(1,1)
                if (mod(i, 2) == 0)
                    element_str = "Knee " + num2str(i);
                    labelColor{i} = S.ColorsT; 
                else
                    element_str = "Ankle " + num2str(i);
                    labelColor{i} =  S.ColorsC;                     
                end                    
                
                % Assuming S is a struct containing Parameters for each element
                Label = sprintf('%s: r=%.3f m, theta=%.2f deg, L=%.3f m', element_str, S.Parameters(i,1), S.Parameters(i,2), S.Parameters(i,3));
                % Combine bungee and rod labels with newline
                legendLabels{i} = [Label, newline];
                
                i = i + 1;
            end
            
            % Display legend
            %legend(legendLabels, 'TextColor', labelColor, 'Location', 'northwestoutside');
            legend(legendLabels, 'Location', 'northwestoutside');
        end
        
    end
elseif S.case == 1.2
    hip = [0, 0]; % HIP position
    knee = [S.BODY.Lengths(1)*sind(S.PHIs(1)), ... % KNEE position
        -(S.BODY.Lengths(1)*cosd(S.PHIs(1)))];
    ankle = [knee(1) + S.BODY.Lengths(2)*sind(S.PHIs(1)-S.PHIs(2)); ... % ANKLE position
        knee(2) - S.BODY.Lengths(2)*cosd(S.PHIs(1)-S.PHIs(2))];
    toe = [ankle(1) + S.BODY.Lengths(3)*sind(S.PHIs(3)), ... % TOE position
        ankle(2) - S.BODY.Lengths(3)*cosd(S.PHIs(3))];
    
    hipIndex = 1;
    kneeIndex = S.EXONET.nParameters*S.EXONET.nElements+1;
    hipKneeIndex = S.EXONET.nParameters*S.EXONET.nElements*2+1;
    
    
    % Loop thorough all MARIONETs
    for element = 1:S.EXONET.nElements
        fprintf(' Hip element %d..',element);
        
        r = p(hipIndex+(element-1)*S.EXONET.nParameters+0);
        theta = p(hipIndex+(element-1)*S.EXONET.nParameters+1);
        L0 = p(hipIndex+(element-1)*S.EXONET.nParameters+2);
        
        rPos = [r*sind(theta) -r*cosd(theta)];     % R vector
        knee = [S.BODY.Lengths(1)*sind(S.PHIs(1)), ... % KNEE position
            -(S.BODY.Lengths(1)*cosd(S.PHIs(1)))];
        plot([rPos(1) knee(1)],[rPos(2) knee(2)],'Color',S.ColorsS(1,:),'Linewidth',S.LWs);
        plot([hip(1) rPos(1)],[hip(2) rPos(2)],'Color',S.ColorsR(1,:),'Linewidth',S.LWr);
    end
    
    for element = 1:S.EXONET.nElements
        fprintf(' Knee element %d..',element);
        
        r = p(kneeIndex+(element-1)*S.EXONET.nParameters+0);
        theta = p(kneeIndex+(element-1)*S.EXONET.nParameters+1);
        L0 = p(kneeIndex+(element-1)*S.EXONET.nParameters+2);
        
        knee = [S.BODY.Lengths(1)*sind(S.PHIs(1)), ...    % KNEE position
            -(S.BODY.Lengths(1)*cosd(S.PHIs(1)))];
        rPos = knee + [r*sind(theta) -r*cosd(theta)]; % R vector
        ankle = [knee(1) + S.BODY.Lengths(2)*sind(S.PHIs(1)-S.PHIs(2)), ... % ANKLE position
            knee(2) - S.BODY.Lengths(2)*cosd(S.PHIs(1)-S.PHIs(2))];
        plot([rPos(1) ankle(1)],[rPos(2) ankle(2)],'Color',S.ColorsS(2,:),'Linewidth',S.LWs);
        plot([knee(1) rPos(1)],[knee(2) rPos(2)],'Color',S.ColorsR(2,:),'Linewidth',S.LWr);
    end
    
    if S.EXONET.nJoints == 3
        for element = 1:S.EXONET.nElements
            fprintf(' 2-joints element %d..',element);
            
            r = p(hipKneeIndex+(element-1)*S.EXONET.nParameters+0);
            theta = p(hipKneeIndex+(element-1)*S.EXONET.nParameters+1);
            L0 = p(hipKneeIndex+(element-1)*S.EXONET.nParameters+2);
            
            rPos = [r*sind(theta) -r*cosd(theta)];                        % R vector
            ankle = [knee(1) + S.BODY.Lengths(2)*sind(S.PHIs(1)-S.PHIs(2)); ... % ANKLE position
                knee(2) - S.BODY.Lengths(2)*cosd(S.PHIs(1)-S.PHIs(2))];
            plot([rPos(1) ankle(1)],[rPos(2) ankle(2)],'Color',S.ColorsS(3,:),'Linewidth',S.LWs);
            plot([hip(1) rPos(1)],[hip(2) rPos(2)],'Color',S.ColorsR(3,:),'Linewidth',S.LWr);
        end
    end
elseif S.case == 2
    hip =   [0      0];
    knee =  [0     -0.4451];
    ankle = [0.02  -1.03];
    toe =   [0.30367  -1.129];
    
    hipIndex = 1;
    kneeIndex = S.EXONET.nParameters*S.EXONET.nElements+1;
    hipKneeIndex = S.EXONET.nParameters*S.EXONET.nElements*2+1;
    
    
    % Loop through all MARIONETs
    for element = 1:S.EXONET.nElements
        fprintf(' Hip element %d..',element);
        
        r = p(hipIndex+(element-1)*S.EXONET.nParameters+0);
        theta = p(hipIndex+(element-1)*S.EXONET.nParameters+1);
        L0 = p(hipIndex+(element-1)*S.EXONET.nParameters+2);
        
        rPos = [r*sind(theta) -r*cosd(theta)]; % R vector
        plot([rPos(1) knee(1)],[rPos(2) knee(2)],'Color',S.ColorsS(3,:),'Linewidth',S.LWs);
        plot([hip(1) rPos(1)],[hip(2) rPos(2)],'Color',S.ColorsR(3,:),'Linewidth',S.LWr);
    end
    
    for element = 1:S.EXONET.nElements
        fprintf(' Knee element %d..',element);
        
        r = p(kneeIndex+(element-1)*S.EXONET.nParameters+0);
        theta = p(kneeIndex+(element-1)*S.EXONET.nParameters+1);
        L0 = p(kneeIndex+(element-1)*S.EXONET.nParameters+2);
        
        rPos = knee + [r*sind(theta) -r*cosd(theta)]; % R vector
        plot([rPos(1) ankle(1)],[rPos(2) ankle(2)],'Color',S.ColorsS(1,:),'Linewidth',S.LWs);
        plot([knee(1) rPos(1)],[knee(2) rPos(2)],'Color',S.ColorsR(1,:),'Linewidth',S.LWr);
    end
    
    if S.EXONET.nJoints == 3
        for element = 1:S.EXONET.nElements
            fprintf(' Hip-Knee element %d..',element);
            
            r = p(hipKneeIndex+(element-1)*S.EXONET.nParameters+0);
            theta = p(hipKneeIndex+(element-1)*S.EXONET.nParameters+1);
            L0 = p(hipKneeIndex+(element-1)*S.EXONET.nParameters+2);
            
            rPos = [r*sind(theta) -r*cosd(theta)]; % R vector
            plot([rPos(1) ankle(1)],[rPos(2) ankle(2)],'Color',S.ColorsS(2,:),'Linewidth',S.LWs);
            plot([hip(1) rPos(1)],[hip(2) rPos(2)],'Color',S.ColorsR(2,:),'Linewidth',S.LWr);
        end
    end
end
fprintf('\n\n\n\n Done drawing~~\n')

end