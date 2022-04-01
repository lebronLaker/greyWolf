function [n]=n_recode(P,M,J,p_text22)
 for i=1:length(P)
     pos=find(M(i)==J(P(i)).m{p_text22(i)});
     n(i)=pos;
 end
end

