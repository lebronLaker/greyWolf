function [J,pos,num] = timeChange20(J,processed_pro,N,p_text)
       pos=find(processed_pro~=0);
       j=1;
       for i=1:length(pos)
           if p_text(pos(i))==2
               num(j)=pos(i);
               j=j+1;
           end
       end
            
        for i=1:length(num)
            pro=processed_pro((num(i)));
            p_index=p_text((num(i)));
            n_index=N((num(i)));
              J(pro).t{p_index}(n_index)=J(pro).t{p_index}(n_index)+5;
        end
     
      
end

