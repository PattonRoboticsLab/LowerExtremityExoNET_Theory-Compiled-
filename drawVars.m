% ***********************************************************************
% Determine the variables (body positions and indexes) needed to draw
% the exonets
% ***********************************************************************

function S = drawVars(S)
if S.case == 1.1 %knee-ankle
    S.knee =  [0     -0.4451];
    S.ankle = [0.02  -1.03];
    S.toe =   [0.30367  -1.129];    
    S.ankleIndex = 1;
    S.kneeToeIndex = S.EXONET.nParameters*S.EXONET.nElements+1;
elseif S.case == 1.2 %Hip-ankle
    S.hip = [0, 0]; % HIP position
    S.knee = [S.BODY.Lengths(1)*sind(S.PHIs(1)), ... % KNEE position
        -(S.BODY.Lengths(1)*cosd(S.PHIs(1)))];
    S.ankle = [S.knee(1) + S.BODY.Lengths(2)*sind(S.PHIs(1)-S.PHIs(2)); ... % ANKLE position
        S.knee(2) - S.BODY.Lengths(2)*cosd(S.PHIs(1)-S.PHIs(2))];
    S.toe = [S.ankle(1) + S.BODY.Lengths(3)*sind(S.PHIs(3)), ... % TOE position
        S.ankle(2) - S.BODY.Lengths(3)*cosd(S.PHIs(3))];
    
    S.hipIndex = 1;
    S.kneeIndex = S.EXONET.nParameters*S.EXONET.nElements+1;
    S.hipKneeIndex = S.EXONET.nParameters*S.EXONET.nElements*2+1;
    
    S.ColorsS1 = S.ColorsS(1,:);
    S.ColorsS2 = S.ColorsS(2,:);
    S.ColorsS3 = S.ColorsS(3,:);
    S.ColorsR1 = S.ColorsR(1,:);
    S.ColorsR2 = S.ColorsR(2,:);
    S.ColorsR3 = S.ColorsR(3,:);
    
elseif S.case == 2 %Gait Stabilize
    S.hip =   [0      0];
    S.knee =  [0     -0.4451];
    S.ankle = [0.02  -1.03];
    S.toe =   [0.30367  -1.129];
    
    S.hipIndex = 1;
    S.kneeIndex = S.EXONET.nParameters*S.EXONET.nElements+1;
    S.hipKneeIndex = S.EXONET.nParameters*S.EXONET.nElements*2+1;
    
    S.ColorsS1 = S.ColorsS(3,:);
    S.ColorsS2 = S.ColorsS(1,:);
    S.ColorsS3 = S.ColorsS(2,:);
    S.ColorsR1 = S.ColorsR(3,:);
    S.ColorsR2 = S.ColorsR(1,:);
    S.ColorsR3 = S.ColorsR(2,:);
end
end

