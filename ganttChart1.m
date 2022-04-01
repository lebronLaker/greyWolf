%���Ƹ���ͼ
function f = ganttChart1(J,P_chromosome,M,mac_t1,mac_t2)
   P=P_chromosome(1,1:size(M,2));
    p_text=[];%��¼�����Ĺ�����Ϣ
    m_info=[];%��¼�豸�ļӹ���Ϣ
    p_color=[];%��ɫ��Ϣ
    color=['r','g','b','c','m','y','w'];
    for i=1:size(J,2)

        p_index=find(P==i);
        color_i=mod(i,7)+1;
        for j=1:size(p_index,2)
            p_var=p_index(j);
            p_text(p_var)=j;
            p_color(p_var)=color_i;
        end
    end
   for i=1:J(1).num_mac 
        m_index=find(M==i);
        if size(m_index,1)>=1 && size(m_index,2)>=1
            for j=1:size(m_index,2)
                m_var=m_index(j);
                m_info(m_var)=j;
            end
        end
    end
    n_bay_nb=J(1).num_mac;%total bays  //������Ŀ
    n_task_nb=length(P);
    c_time=P_chromosome(size(P,2)+1);%���������ʱ��
%     d_time=P_chromosome(size(P,2)+2);%����ʱ��
%      e_load=P_chromosome(size(P,2)+3);%�豸����
%     e_cons=P_chromosome(size(P,2)+2);%��������
    stability=rescheduling_statibility(mac_t1,mac_t2);
    axis([0,140,0,n_bay_nb+0.5]);%x�� y��ķ�Χ
    set(gca,'xtick',0:10:120) ;%x�����������
    set(gca,'ytick',0:1:n_bay_nb+0.5) ;%y�����������
    xlabel('�ӹ�ʱ��'),ylabel('������');%x�� y�������
%      sche_info=sprintf('����깤ʱ��:%d  �ܺ�����:%.2fKw/h',c_time, stability)
%     title("����깤ʱ��:%d  ������:%d  �ܺ�����:%.2fKw/h',c_time,d_time,e_cons");%ͼ�εı���
    if stability~=0
        txt1=sprintf('����깤ʱ��:%d  ƫ���:%d',c_time,stability);
        text(15,9,txt1,'FontWeight','Bold','FontSize',10);
    else
        txt1=sprintf('����깤ʱ��:%d ',c_time);
        text(15,9,txt1,'FontWeight','Bold','FontSize',10);
    end
    rec=[0,0,0,0];
    for i =1:n_task_nb 
       if  mac_t2{M(i)}(m_info(i),2)~=0
        rec(1) = mac_t2{M(i)}(m_info(i),1);%���εĺ�����
        rec(2) = M(i)-0.3;%���ε�������
        rec(3) = mac_t2{M(i)}(m_info(i),2)-mac_t2{M(i)}(m_info(i),1);%���ε�x�᷽��ĳ���
        rec(4) = 0.6;
        x=mac_t2{M(i)}(m_info(i),2)-mac_t2{M(i)}(m_info(i),1);
        txt=sprintf('%d-%d',P(i),p_text(i));%�������ţ�����ţ��ӹ�ʱ�������ַ���
        rectangle('Position',rec,'LineWidth',0.5,'LineStyle','-','FaceColor',color(p_color(i)));%draw every rectangle  
        text(mac_t2{M(i)}(m_info(i),1)+(x-6)/5,M(i),txt,'FontWeight','Bold','FontSize',10);%label the id of every task  ��������������������
      end
    end
end

