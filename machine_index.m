function N = machine_index(J,P,M)
for i=1:size(P,1)
p1(i,:)=P(i,1:size(P,2));
end
    N=zeros(1,size(p1,2));
    for i=1:size(J,2)
        pi_index=find(p1==i);
        for j=1:size(pi_index,2)
             var=find(J(i).m{j}==M(pi_index(j)));
             if length(var)==0
                 var(1)=1;
             end
             N(pi_index(j))=var;
             
        end
    end
end

