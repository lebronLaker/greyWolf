%̰�������㷨  JΪ������ȵĹ�����������Ϣ  PΪ���ȷ����Ļ��ڹ�������Ⱦɫ�� 
% MΪ���ȷ����Ļ��ڻ��������Ⱦɫ��  NΪ��ѡ�豸�ڶ�Ӧ��ѡ�豸���е����к�
%part_tΪ��Ӧ����������ӹ�ʱ����Ϣ  mac_tΪ��Ӧ�豸������ӹ�ʱ����Ϣ
function [part_t,mac_t]= decode(J,P,M,N)

    part_t=cell(size(J,2));%�ӹ�����ļӹ�ʱ��
    mac_t=cell(J(1).num_mac);%��Ӧ�豸�ӹ�ʱ��
    total_n=size(P,2);%total_nΪ�ܹ�����
    part_n=size(J,2);
    k_part=zeros(1,part_n);%��¼��ǰ��������й����Ĺ����
    k_mac=zeros(1,J(1).num_mac);%��¼��ǰ��������иõ������ڸ��豸�д��ӹ����
    t_span=cell(1);%��¼�������豸�ӹ���϶
%     k_N=zeros(1,part_n);
    for i=1:total_n
        p_var=P(i);
        m_var=M(i);%Ⱦɫ���е�i����������Ӧ�ļӹ��豸
        n_var=N(i);%�û�����ѡ�豸�ڿ�ѡ�豸���е����
        k_part(p_var)=k_part(p_var)+1;
        k_mac(m_var)=k_mac(m_var)+1;
%       m_span{m_var}  %��m_var̨�豸��ǰ�����ڵļӹ���϶
        pro_time=J(p_var).t{k_part(p_var)}(n_var);%�õ���������ӹ�ʱ��
        %ȷ���ù���ʼ�ļӹ�ʱ��
        %���ڹ�����Լ��
        if k_part(p_var)>1
            start_t_p=part_t{p_var}(k_part(p_var)-1,2);
        else
            start_t_p=0;
        end
        %���ڼӹ��豸��Լ��
        if k_mac(m_var)>1
            start_t_m=mac_t1{m_var}(k_mac(m_var)-1,2);
        else
            start_t_m=0;
        end
        %�ж�����Լ��
        if start_t_p>=start_t_m
            start_t=start_t_p;
            %������ǰ��ʱ�ģ��豸��϶����
            if k_mac(m_var)>1
                t_span{m_var}(k_mac(m_var),:)=[mac_t1{m_var}(k_mac(m_var)-1,2),start_t];
            else
                t_span{m_var}(k_mac(m_var),:)=[0,start_t];
            end
        else 
              span=t_span{m_var}(:,2)-t_span{m_var}(:,1);
            req_span=intersect(find(span>=pro_time),find(t_span{m_var}(:,2)>=start_t_p+pro_time)); %���Խ��в����λ��
            if size(req_span,1)>=1&&size(req_span,2)
                var=req_span(1);       
                start_t=max(start_t_p,t_span{m_var}(var,1));
                t_span{m_var}(k_mac(m_var),:)=[start_t+pro_time,t_span{m_var}(var,2)];%���²���������¼�϶
                t_span{m_var}(var,2)=start_t;%���²��������м�϶��Ӱ��
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

