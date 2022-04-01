function [unprocessed_pro,unprocessed_mac,processed_pro, processed_mac,p_text1,p_text2,m_info1,m_info2,N1,N2]= reschedule_pro(J,P_chromosome,M,mac_t,T,N)
P=P_chromosome(1,1:size(P_chromosome,2)-4);
    m_info=[];%记录设备的加工信息
    for i=1:J(1).num_mac
        m_index=find(M==i);
        if size(m_index,1)>=1 && size(m_index,2)>=1
            for j=1:size(m_index,2)
                m_var=m_index(j);
                m_info(m_var)=j;
            end
        end
    end
    for i=1:size(J,2)
        p_index=find(P==i);
       
        for j=1:size(p_index,2)
            p_var=p_index(j);
            p_text(p_var)=j;
           
        end
    end
%     n_bay_nb=J(1).num_mac;%total bays  //机器数目
  n_task_nb=length(P);
  for i =1:n_task_nb

              if mac_t{M(i)}(m_info(i),1)<T&&length( mac_t{M(i)})~=0
                  processed_pro(i)=P(i);
                  processed_mac(i)=M(i);
                   processed_pro(length(processed_pro)+1:n_task_nb)=0;%%q[]为动态事件发生之前已加工的工序
              end
  end
             for a=1:n_task_nb
                 if processed_pro(a)==0
                unprocessed_pro(a)=P(a);      %n[]为动态事件发生后未加工工序
                 unprocessed_mac(a)=M(a);
                 p_text1(a)=p_text(a);
                 m_info1(a)=m_info(a);
                 N1(a)=N(a);
                 else
                      p_text2(a)=p_text(a);        %已加工工序的工序及机器信息
                      m_info2(a)=m_info(a);
                      N2(a)=N(a);
                 end
             end
%              j=1;
%              for i=1:length(p_text2)
%                  if  p_text2(i)~=0
%                      p_info2(j)=p_text2(i);
%                      m_info2(j)=m_info(i);
%                      j++;
%                  end 
%              end 
end

