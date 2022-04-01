function g= ganttChart2(J,P,M,mac_t,p_text,m_info)
%   P=P_chromosome(1,1:size(M,2));
%     p_text=[];%记录工件的工序信息
%     m_info=[];%记录设备的加工信息
    p_color=[];%颜色信息
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
    n_bay_nb=J(1).num_mac;%total bays  //机器数目
    n_task_nb=length(M);

    axis([0,140,0,n_bay_nb+0.5]);%x轴 y轴的范围
    set(gca,'xtick',0:10:80) ;%x轴的增长幅度
    set(gca,'ytick',0:1:n_bay_nb+0.5) ;%y轴的增长幅度
    xlabel('加工时间'),ylabel('机器号');%x轴 y轴的名称

    rec=[0,0,0,0];
    for i =1:n_task_nb 
      if P(i)~=0
        rec(1) = mac_t{M(i)}(m_info(i),1);%矩形的横坐标
        rec(2) = M(i)-0.3;%矩形的纵坐标
        rec(3) = mac_t{M(i)}(m_info(i),2)-mac_t{M(i)}(m_info(i),1);%矩形的x轴方向的长度
        rec(4) = 0.6;
        x=mac_t{M(i)}(m_info(i),2)-mac_t{M(i)}(m_info(i),1);
        txt=sprintf('%d-%d',P(i),p_text(i));%将机器号，工序号，加工时间连城字符串
        rectangle('Position',rec,'LineWidth',0.5,'LineStyle','-','FaceColor',color(p_color(i)));%draw every rectangle  
        text(mac_t{M(i)}(m_info(i),1)+(x-6)/5,M(i),txt,'FontWeight','Bold','FontSize',10);%字体的坐标和其它特性
        makespan(i)=mac_t{M(i)}(m_info(i),2);
      end
        maxtime=max(makespan);
    end
    txt1=sprintf('最大完工时间:%d ',maxtime);
      text(15,9,txt1,'FontWeight','Bold','FontSize',10);
end



