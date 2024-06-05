% ***********************************************************************
% Find the parameters for the Element
% ***********************************************************************

function S = findParameters(ind,p,element,S)
r = p(ind+(element-1)*S.EXONET.nParameters+0);
theta = p(ind+(element-1)*S.EXONET.nParameters+1);
L0 = p(ind+(element-1)*S.EXONET.nParameters+2);

S.p = [r theta L0];
end