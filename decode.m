%贪婪解码算法  J为参与调度的工件的所有信息  P为调度方案的基于工序编码的染色体 
% M为调度方案的基于机器编码的染色体  N为所选设备在对应可选设备集中的序列号
%part_t为对应工件各工序加工时间信息  mac_t为对应设备各工序加工时间信息
function [part_t,mac_t]= decode(J,P,M,N)

    part_t=cell(size(J,2));%加工零件的加工时间
    mac_t=cell(J(1).num_mac);%对应设备加工时间
    total_n=size(P,2);%total_n为总工序数
    part_n=size(J,2);
    k_part=zeros(1,part_n);%记录当前解码过程中工件的工序号
    k_mac=zeros(1,J(1).num_mac);%记录当前解码过程中该到工序在该设备中待加工序号
    t_span=cell(1);%记录该所有设备加工间隙
%     k_N=zeros(1,part_n);
    for i=1:total_n
        p_var=P(i);
        m_var=M(i);%染色体中第i个基因所对应的加工设备
        n_var=N(i);%该基因所选设备在可选设备集中的序号
        k_part(p_var)=k_part(p_var)+1;
        k_mac(m_var)=k_mac(m_var)+1;
%       m_span{m_var}  %第m_var台设备当前所存在的加工间隙
        pro_time=J(p_var).t{k_part(p_var)}(n_var);%该道工序所需加工时间
        %确定该工序开始的加工时间
        %基于工件的约束
        if k_part(p_var)>1
            start_t_p=part_t{p_var}(k_part(p_var)-1,2);
        else
            start_t_p=0;
        end
        %基于加工设备的约束
        if k_mac(m_var)>1
            start_t_m=mac_t1{m_var}(k_mac(m_var)-1,2);
        else
            start_t_m=0;
        end
        %判断最终约束
        if start_t_p>=start_t_m
            start_t=start_t_p;
            %不发生前插时的，设备间隙矩阵
            if k_mac(m_var)>1
                t_span{m_var}(k_mac(m_var),:)=[mac_t1{m_var}(k_mac(m_var)-1,2),start_t];
            else
                t_span{m_var}(k_mac(m_var),:)=[0,start_t];
            end
        else 
              span=t_span{m_var}(:,2)-t_span{m_var}(:,1);
            req_span=intersect(find(span>=pro_time),find(t_span{m_var}(:,2)>=start_t_p+pro_time)); %可以进行插入的位置
            if size(req_span,1)>=1&&size(req_span,2)
                var=req_span(1);       
                start_t=max(start_t_p,t_span{m_var}(var,1));
                t_span{m_var}(k_mac(m_var),:)=[start_t+pro_time,t_span{m_var}(var,2)];%更新插入产生的新间隙
                t_span{m_var}(var,2)=start_t;%更新插入后对已有间隙的影响
                t_span{m_var}=sortrows(t_span{m_var},1);
            else
                start_t=start_t_m;
                t_span{m_var}(k_mac(m_var),:)=[mac_t1{m_var}(k_mac(m_var)-1,2),start_t];
            end
        end  
        stop_t=start_t+pro_time;
        part_t{p_var}(k_part(p_var),:)=[start_t,stop_t];
        mac_t{m_var}(k_mac(m_var),:)=[start_t,stop_t];
        for i=1:size(mac_t,2)
             if size( mac_t{i,1})~=0;
           mac_t1{i,1}= sort(mac_t{i,1},'ascend');
             end
        end
    end
%     for i=1:size(mac_t,2)
%         mac_t{i,1}= sort(mac_t{i,1},'ascend');   
%     end
%     for i=1:size(mac_t,1)
%       for j=1:size(mac_t{i},1)
%         if j>1
%             if mac_t{i}(j,1)<mac_t{i}(j-1,2)
%                 time=mac_t{i}(j,2)-mac_t{i}(j,1);
%                 mac_t{i}(j,1)=mac_t{i}(j-1,2);
%                 mac_t{i}(j,2)=mac_t{i}(j,1)+time;
%             end
%         end
%       end 
%     end
%    
end

