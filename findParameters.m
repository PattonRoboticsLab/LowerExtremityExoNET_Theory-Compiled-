function S = findParameters(ind,p,element,S)
r = p(ind+(element-1)*S.EXONET.nParameters+0);
theta = p(ind+(element-1)*S.EXONET.nParameters+1);
L0 = p(ind+(element-1)*S.EXONET.nParameters+2);
% if S.end == true
%     pp = p;
%     for i = 1:3:length(pp)  % for loop to print the values of the optimal parameters
%         if abs(pp(i+1))>360 % to adjust the angle theta if it's higher than 360 degrees
%             while abs(pp(i+1))>360
%                 pp(i+1) = sign(pp(i+1))*(abs(pp(i+1))-360);
%             end
%         end
%         if pp(i)<0          % if r is negative
%             pp(i) = pp(i)*(-1);
%             pp(i+1) = pp(i+1)+180;
%         end
%     end
%     ppp = pp;
%     for i = 2:3:length(ppp)
%         if abs(ppp(i))>360 % to adjust the angle theta if it's higher than 360 degrees
%             while abs(ppp(i))>360
%                 ppp(i) = sign(ppp(i))*(abs(ppp(i))-360);
%             end
%         end
%     end
%     
%     fprintf('\n\n\n\n The Optimal Parameters for each Element are~~\n')
%     n = 1;
%     for i = 1:3:length(ppp)  % to print the values of the optimal parameters
%         fprintf('\n Element %d\n',n)
%         fprintf('\n r = %4.3f m   theta = %4.2f deg   L0 = %4.3f m\n',ppp(i),ppp(i+1),ppp(i+2))
%         n = n+1;
%     end
%     S.Parameters = [ppp(i), ppp(i+1), ppp(i+2)];
% else
    S.Parameters = [r theta L0];
%end
end