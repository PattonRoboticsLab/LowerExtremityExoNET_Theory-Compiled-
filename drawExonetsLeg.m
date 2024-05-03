% ***********************************************************************
% Draw individual MARIONETs for the leg pose specified by phis
% ***********************************************************************
function S = drawExonetsLeg(p,S)
fprintf('\n\n\n\n Drawing MARIONETs~~\n')
legendLabels = cell(1, S.EXONET.nElements);  % Preallocate legendLabels cell array

S = drawVars(S); %Determine the variables needed to draw exonets

if S.case == 1.1
    % Loop through all MARIONETs
    for element = 1:S.EXONET.nElements
        for j = 1:length(S.flag)
            if S.flag(j) == 0
                strElement = ' Ankle element ';
                bodyPart = S.ankle;
                plotColor = S.ColorsC;
                plotNum = 1;
                S = findParameters(S.ankleIndex,p, element,S);
            elseif S.flag(j) == 1
                strElement = ' Knee element ';
                bodyPart = S.knee;
                plotColor = S.ColorsT;
                plotNum = 3;
                if S.EXONET.nJoints == 22
                    S = findParameters(S.ankleIndex,p,element,S);
                else
                    S = findParameters(S.kneeToeIndex,p,element,S);
                end
            end
            fprintf(strElement, element);
            
            rPos = bodyPart + [S.p(1)*sind(S.p(2)) -S.p(1)*cosd(S.p(2))]; % R vector
            plot([rPos(1) S.toe(1)], [rPos(2) S.toe(2)], 'Color', plotColor, 'Linewidth', S.LWs); %bungee
            plot([bodyPart(1) rPos(1)], [bodyPart(2) rPos(2)], 'Color', S.ColorsS(plotNum,:), 'Linewidth', S.LWr); %rod
            
        end        
    end
elseif (S.case == 1.2) || (S.case == 2)
    % Loop thorough all MARIONETs
    for element = 1:S.EXONET.nElements
        fprintf(' Hip element %d..',element);
        S = findParameters(S.hipIndex,p, element,S);
        
        rPos = [S.p(1)*sind(S.p(2)) -S.p(1)*cosd(S.p(2))];     % R vector
        plot([rPos(1) S.knee(1)],[rPos(2) S.knee(2)],'Color',S.ColorsS1,'Linewidth',S.LWs);
        plot([S.hip(1) rPos(1)],[S.hip(2) rPos(2)],'Color',S.ColorsR1,'Linewidth',S.LWr);
        %=================================================================%
        fprintf(' Knee element %d..',element);
        S = findParameters(S.kneeIndex,p, element,S);
        
        rPos = S.knee + [S.p(1)*sind(S.p(2)) -S.p(1)*cosd(S.p(2))]; % R vector
        plot([rPos(1) S.ankle(1)],[rPos(2) S.ankle(2)],'Color',S.ColorsS2,'Linewidth',S.LWs);
        plot([S.knee(1) rPos(1)],[S.knee(2) rPos(2)],'Color',S.ColorsR2,'Linewidth',S.LWr);
        %=================================================================%
        fprintf(' 2-joints element %d..',element);
        S = findParameters(S.hipKneeIndex,p, element,S);
        
        rPos = [S.p(1)*sind(S.p(2)) -S.p(1)*cosd(S.p(2))]; % R vector
        plot([rPos(1) S.ankle(1)],[rPos(2) S.ankle(2)],'Color',S.ColorsS3,'Linewidth',S.LWs);
        plot([S.hip(1) rPos(1)],[S.hip(2) rPos(2)],'Color',S.ColorsR3,'Linewidth',S.LWr);
    end
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
        S.p(n,:) = ppp(i:i+2);
        n = n+1;
    end
    lenElement = size(S.p);
    i = 1;
    while i <= lenElement(1,1)      
        % Assuming S is a struct containing Parameters for each element
        Label = sprintf('%s: r = %.3f m, theta = %.2f deg, L = %.3f m', num2str(i), S.p(i,1), S.p(i,2), S.p(i,3));
        legendLabels{i} = [Label, newline]; % Combine labels with newline
        i = i + 1;
    end
    legend(legendLabels, 'Location', 'best'); % Display legend
end
        
fprintf('\n\n\n\n Done drawing~~\n')

end