%��������깤ʱ�� part_tΪ���ȷ�������Ӧ�ļӹ�ʱ����Ϣ
function max_comp_time = cal_comp_time(mac_t)
    max_time=[];%��¼������������깤ʱ��
    for i=1:size(mac_t,2)
        m=size(mac_t{i},1);
        if(m~=0)
            for j=1:m
                max_time(i)=max(mac_t{i}(1:j,2));
            end
        else 
        max_time(i)=0;    
        end
    end
    max_comp_time=max(max_time);
end

