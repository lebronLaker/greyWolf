function g= ganttChart2(J,P,M,mac_t,p_text,m_info)
%   P=P_chromosome(1,1:size(M,2));
%     p_text=[];%��¼�����Ĺ�����Ϣ
%     m_info=[];%��¼�豸�ļӹ���Ϣ
    p_color=[];%��ɫ��Ϣ
    color=['r','g','b','c','m','y','w'];
    for i=1:size(J,2)

        p_index=find(P==i);
        color_i=mod(i,7)+1;
        for j=1:size(p_index,2)
            p_var=p_index(j);
            p_color(p_var)=color_i;
        end
    end
%    for i=1:J(1).num_mac 
%         m_index=find(M==i);
%         if size(m_index,1)>=1 && size(m_index,2)>=1
%             for j=1:size(m_index,2)
%                 m_var=m_index(j);
%                 m_info(m_var)=j;
%             end
%         end
%     end
    n_bay_nb=J(1).num_mac;%total bays  //������Ŀ
    n_task_nb=length(M);

    axis([0,140,0,n_bay_nb+0.5]);%x�� y��ķ�Χ
    set(gca,'xtick',0:10:80) ;%x�����������
    set(gca,'ytick',0:1:n_bay_nb+0.5) ;%y�����������
    xlabel('�ӹ�ʱ��'),ylabel('������');%x�� y�������

    rec=[0,0,0,0];
    for i =1:n_task_nb 
      if P(i)~=0
        rec(1) = mac_t{M(i)}(m_info(i),1);%���εĺ�����
        rec(2) = M(i)-0.3;%���ε�������
        rec(3) = mac_t{M(i)}(m_info(i),2)-mac_t{M(i)}(m_info(i),1);%���ε�x�᷽��ĳ���
        rec(4) = 0.6;
        x=mac_t{M(i)}(m_info(i),2)-mac_t{M(i)}(m_info(i),1);
        txt=sprintf('%d-%d',P(i),p_text(i));%�������ţ�����ţ��ӹ�ʱ�������ַ���
        rectangle('Position',rec,'LineWidth',0.5,'LineStyle','-','FaceColor',color(p_color(i)));%draw every rectangle  
        text(mac_t{M(i)}(m_info(i),1)+(x-6)/5,M(i),txt,'FontWeight','Bold','FontSize',10);%������������������
        makespan(i)=mac_t{M(i)}(m_info(i),2);
      end
        maxtime=max(makespan);
    end
    txt1=sprintf('����깤ʱ��:%d ',maxtime);
      text(15,9,txt1,'FontWeight','Bold','FontSize',10);
end



