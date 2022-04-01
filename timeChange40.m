function  [J,pos] = timeChange40(J,processed_pro, processed_mac,N,p_text,pos,num)
        pos1=find(processed_pro~=0);
        m=1;
        for i=1:length(pos1)            %20~40时刻之间加工的工序位置
            if ~ismember(pos1(i),pos)
                canChange(m)=pos1(i);
                m=m+1;
            end
        end
        k=1;
        for i=1:length(num)
            m_index(k)=processed_mac(num(i));
            k=k+1;
        end
        n=1;
       for i=1:length(m_index)
           for j=1:length(canChange)
             if processed_mac(canChange(j))==m_index(i)
                   change_p_index(n)= canChange(j);
                   n=n+1;
             end
           end
       end
   
           
          
        for i=1:length(change_p_index)
            pro=processed_pro((change_p_index(i)));
            p_index=p_text((change_p_index(i)));
            n_index=N((change_p_index(i)));
              J(pro).t{p_index}(n_index)=J(pro).t{p_index}(n_index)+6;

        end
     
      
end

