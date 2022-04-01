function   [index]=select_best(re_p_matrix)
pos=find(re_p_matrix(:,size(re_p_matrix,2)-1)==1);
    for i=1:length(pos)
        sum(i)=re_p_matrix(i,size(re_p_matrix,2)-3)+re_p_matrix(i,size(re_p_matrix,2)-2);
    end
    index=find(min(sum)==sum);
    if length(index)>1
        index=index(1);
    end
end

