%主函数
function nsga2_scheduling
    clear all;
    clc;
    pop = 200; %种群数量
    a=2;%灰狼优化协同系数
    gen =20; %初始方案迭代次数
    gen1=100;%重调度迭代次数
    pop_f=100;%父代种群数量
    data_mac;%载入车间设备信息
    data_pro;%载入待加工工件信息
    pro_matrix=[];%包含工序及目标函数值得决策矩阵
    mac_matrix=[];%包含设备染色体信息的决策矩阵
    for i=1:pop_f%生成初始种群
        [P,M,N]=initPop(J);
        [part_t,mac_t]=decode(J,P,M,N);
        origin_c_time=cal_comp_time(part_t);
        t_cons=cal_ene_consu(Mac,mac_t,P,M,origin_c_time);
        pro_matrix(i,:)=[P,origin_c_time,t_cons];
        mac_matrix(i,:)=M;
    end 
   for i = 1 : gen
        pool = round(pop/2);%round() 四舍五入取整 交配池大小
        tour = 2;%竞标赛  参赛选手个数
        [p_matrix,m_matrix]= non_domination_sort_mod(pro_matrix,mac_matrix);%种群进行非支配快速排序和拥挤度计算 
%         clear pro_matrix;
%         clear mac_matrix;
       
         [p_chromosome,m_chromosome] = tournament_selection(p_matrix,m_matrix,pool,tour);%竞标赛选择适合繁殖的父代
        %交叉变异生成子代种群
      [p_child_matrix,m_child_matrix] = GWO(p_chromosome,m_chromosome,J,a);
        %根据父类和子类总种群，进行非支配快速排序，选取出下一代的父代种群
        for j=1:size(p_child_matrix,1)
            P=p_child_matrix(j,:);
            M=m_child_matrix(j,:);
            N=machine_index(J,P,M);
            [part_t,mac_t]=decode(J,P,M,N); 
            c_time=cal_comp_time(mac_t);

            t_cons=cal_ene_consu(Mac,mac_t,P,M,c_time);
            pro_matrix(j,:)=[P,c_time,t_cons];
            mac_matrix(j,:)=M;
        end
        n_p_m=size(pro_matrix,1);
        pro_matrix(n_p_m+1:n_p_m+10,:)=p_matrix(1:10,1:size(pro_matrix,2));%保留精英染色体到子代种群中
        mac_matrix(n_p_m+1:n_p_m+10,:)=m_matrix(1:10,:);
   end
   [p_matrix,m_matrix]= non_domination_sort_mod(pro_matrix,mac_matrix);
   num_of_level_1=length(find(p_matrix(:,size(p_matrix,2)-1)==1));
   target_p_matrix=p_matrix(1:num_of_level_1,:);
   target_m_matrix=m_matrix(1:num_of_level_1,:);
   best_p=target_p_matrix(1,:);%选取第一个作为最优解，可根据需求，选择AHP和熵权法或模糊决策法，选出最优解
   best_m=target_m_matrix(1,:);
   P=best_p(1:length(best_p)-4);
   M=best_m;
   N=machine_index(J,P,M);
   [part_t,mac_t]=decode(J,P,M,N);
   for i=1:size(mac_t,1)
       while size(mac_t{i},2)==0
           r=randperm( num_of_level_1,1);
            best_p=target_p_matrix(r,:);
             best_m=target_m_matrix(r,:);
              P=best_p(1:length(best_p)-4);
             M=best_m;
             N=machine_index(J,P,M);
            [part_t,mac_t]=decode(J,P,M,N);
       end
   end
%  P=best_p(1:length(best_p)-4);
origin_mac_t=mac_t;

% %----------------20、40时刻原方案甘特图----------------%
[unprocessed_pro,unprocessed_mac,processed_pro, processed_mac,p_text1,p_text2,~,m_info2,~,N2]= reschedule_pro(J,best_p,M,origin_mac_t,20,N);
%  [~,~,processed_pro1, processed_mac1,~,p_text22,~,m_info22,~,N22]= reschedule_pro(J,best_p,M,origin_mac_t,40,N);
% 
%   %----------------20时刻实际情况甘特图----------------%
 [J1,pos,num] = timeChange20(J,processed_pro,N2,p_text2);
% 
% %----------------40时刻实际甘特图----------------%
% [unprocessed_pro,unprocessed_mac,processed_pro1, processed_mac1,p_text11,p_text22,m_info11,m_info22,N11,N22]= reschedule_pro(J,best_p,M,mac_t,40,N);
%  [J2] = timeChange40(J1,processed_pro1, processed_mac1,N22,p_text22,pos,num);
% P=best_p(1:length(best_p)-4);
% [part_t2,mac_t2]=decode(J2,P,M,N);
%  c_time=cal_comp_time(mac_t2);
% stability=rescheduling_statibility(origin_mac_t,mac_t2);
%  P(29:32)=[c_time,stability,0,0];
% %  subplot(3,3,5),ganttChart2(J2,processed_pro1,processed_mac1,mac_t2,p_text22,m_info22); 
% %  subplot(3,3,6),ganttChart1(J2,P,M,mac_t2,mac_t2); 
% 
     jj=1;
    for ii=1:size(processed_pro,2)     %找出已加工工序   
      if processed_pro(ii)~=0
          p2(jj)=processed_pro(ii);
          m2(jj)=processed_mac(ii);
%            n2(jj)=m_info2(ii);
       p_text22(jj)=p_text2(ii);
          jj=jj+1;
      end
    end
      [n2]=n_recode(p2,m2,J1,p_text22);
%       %--------------------%
   for i=1:pop_f  
       [p1,m1,n1]=reinitPop(unprocessed_pro,J1,p_text1);
        pro_final=[p2,p1];
         mac_final=[m2,m1];
        n_index=[n2,n1];
        [part_t,mac_t]=decode(J1,pro_final,mac_final,n_index);
           c_time=cal_comp_time(mac_t);
            stability=rescheduling_statibility(origin_mac_t,mac_t);
        re_pro_matrix(i,:)=[pro_final,c_time,stability];
        re_mac_matrix(i,:)=mac_final;
   end
   %-----------基本灰狼优化算法--GWO--------------%
    re_pro_matrix_GWO=re_pro_matrix;
    re_mac_matrix_GWO=re_mac_matrix;   
    k1=1;
    for i = 1 : gen1  %GWO生成重调度工序
      [p_matrix,m_matrix]= non_domination_sort_mod(re_pro_matrix_GWO,re_mac_matrix_GWO);
      [p_chromosome,m_chromosome] = tournament_selection(p_matrix,m_matrix,pool,tour);
       [p_child_matrix,m_child_matrix] = GWO(p_chromosome,m_chromosome,J1,a);

         for j=1:size(p_child_matrix,1)
            P=p_child_matrix(j,:);
            M=m_child_matrix(j,:);
            N=machine_index(J1,P,M);
            [part_t,mac_t]=decode(J1,P,M,N); 
            c_time=cal_comp_time(mac_t);
            stability=rescheduling_statibility(origin_mac_t,mac_t);
            re_pro_matrix_GWO(j,:)=[P,c_time,stability];
            re_mac_matrix_GWO(j,:)=M;
         end
          [re_p_matrix_GWO,re_m_matrix_GWO]= non_domination_sort_mod(re_pro_matrix_GWO,re_mac_matrix_GWO);
             n_p_m=size(re_pro_matrix_GWO,1);
             re_pro_matrix_GWO(n_p_m-4:n_p_m,:)=p_matrix(1:5,1:size(re_pro_matrix_GWO,2));%保留精英染色体到子代种群中
             re_mac_matrix_GWO(n_p_m-4:n_p_m,:)=m_matrix(1:5,:);
    end
    [re_p_matrix_GWO,re_m_matrix_GWO]= non_domination_sort_mod(re_pro_matrix_GWO,re_mac_matrix_GWO);
     best_index_GWO=find(re_p_matrix_GWO(:,31)==1);
        for i=1:size(best_index_GWO,1)
            best_m_GWO(i)=re_p_matrix_GWO(best_index_GWO(i),29);
            best_s_GWO(i)=re_p_matrix_GWO(best_index_GWO(i),30);
        end
          
       %-----------改进灰狼优化算法--IGWO--------------%
    re_pro_matrix_IGWO=re_pro_matrix;
    re_mac_matrix_IGWO=re_mac_matrix;   
    k1=1;
    for i = 1 : gen1  %GWO生成重调度工序
      [p_matrix,m_matrix]= non_domination_sort_mod(re_pro_matrix_IGWO,re_mac_matrix_IGWO);
      [p_chromosome,m_chromosome] = tournament_selection(p_matrix,m_matrix,pool,tour);
      [p_IGWO_child_matrix,m_IGWO_child_matrix] = GWO(p_chromosome,m_chromosome,J1,a); 
           index1=size(p2,2);index2=size(p_IGWO_child_matrix,2);index3=size(m_IGWO_child_matrix,2);           
        [p_child_matrix,m_child_matrix]=genetic_operator_GWO(J,p_IGWO_child_matrix(:,index1+1:index2),m_IGWO_child_matrix(:,index1+1:index3));           
         for k=1:size(p_child_matrix,1)
            re_p_child_matrix(k,:)=[p2,p_child_matrix(k,:)];
             re_m_child_matrix(k,:)=[m2,m_child_matrix(k,:)];
         end
        
         for j=1:size( re_p_child_matrix,1)
            P=re_p_child_matrix(j,:);
            M= re_m_child_matrix(j,:);
            N=machine_index(J1,P,M);
            [part_t,mac_t]=decode(J1,P,M,N); 
            c_time=cal_comp_time(mac_t);
            stability=rescheduling_statibility(origin_mac_t,mac_t);
            re_pro_matrix_final(j,:)=[P,c_time,stability];
            re_mac_matrix_final(j,:)=M;
         end
          [re_p_matrix_IGWO,re_m_matrix_IGWO]= non_domination_sort_mod(re_pro_matrix_final,re_mac_matrix_final);
         for ii=1:100
              re_pro_matrix_IGWO(ii,:)=re_p_matrix_IGWO(ii,1:30);
              re_mac_matrix_IGWO(ii,:)=re_m_matrix_IGWO(ii,:);
         end
             n_p_m=size(re_pro_matrix_IGWO,1);
             re_pro_matrix_IGWO(n_p_m-4:n_p_m,:)=p_matrix(1:5,1:size(re_pro_matrix_IGWO,2));%保留精英染色体到子代种群中
             re_mac_matrix_IGWO(n_p_m-4:n_p_m,:)=m_matrix(1:5,:);
                
    end
    [re_p_matrix_IGWO,re_m_matrix_IGWO]= non_domination_sort_mod(re_pro_matrix_IGWO,re_mac_matrix_IGWO);
            best_index_IGWO=find(re_p_matrix_IGWO(:,31)==1);
        for i=1:size(best_index_IGWO,1)
            best_m_IGWO(i)=re_p_matrix_IGWO(best_index_IGWO(i),29);
            best_s_IGWO(i)=re_p_matrix_IGWO(best_index_IGWO(i),30);
        end
        


         %-----------NSGAII算法--------------%   
    re_pro_matrix_NSGAII=re_pro_matrix;
    re_mac_matrix_NSGAII=re_mac_matrix;   
    k2=1;
 for i = 1 : gen1 %NSGA-II生成重调度工序
     [p_matrix,m_matrix]= non_domination_sort_mod(re_pro_matrix_NSGAII,re_mac_matrix_NSGAII); 
        [p_chromosome,m_chromosome] = tournament_selection(p_matrix,m_matrix,pool,tour);%竞标赛选择适合繁殖的父代
        %交叉变异生成子代种群
        index1=size(p2,2);index2=size(p_chromosome,2);index3=size(m_chromosome,2);
        [p_child_matrix,m_child_matrix]=genetic_operator(J,p_chromosome(:,index1+1:index2),m_chromosome(:,index1+1:index3));
        for k=1:size(p_child_matrix,1)
            re_p_child_matrix(k,:)=[p2,p_child_matrix(k,:)];
             re_m_child_matrix(k,:)=[m2,m_child_matrix(k,:)];
        end
%        [re_p_child_matrix_NSGAII,re_m_child_matrix_NSGAII] = NSGAII(re_pro_parent_matrix_NSGAII,re_mac_parent_matrix_NSGAII,J2,origin_mac_t);
         for j=1:size(re_p_child_matrix,1)
            P=re_p_child_matrix(j,:);
            M=re_m_child_matrix(j,:);
            N=machine_index(J1,P,M);
            [part_t,mac_t]=decode(J1,P,M,N); 
            c_time=cal_comp_time(mac_t);
          stability=rescheduling_statibility(origin_mac_t,mac_t);
            re_pro_matrix_final(j,:)=[P,c_time,stability];
            re_mac_matrix_final(j,:)=M;
         end
          [re_p_matrix_NSGAII,re_m_matrix_NSGAII]= non_domination_sort_mod(re_pro_matrix_final,re_mac_matrix_final);
         for ii=1:100
              re_pro_matrix_NSGAII(ii,:)=re_p_matrix_NSGAII(ii,1:30);
              re_mac_matrix_NSGAII(ii,:)=re_m_matrix_NSGAII(ii,:);
         end

          n_p_m=size(re_pro_matrix_NSGAII,1);
       re_pro_matrix_NSGAII(n_p_m-4:n_p_m,:)=p_matrix(1:5,1:size( re_pro_matrix_NSGAII,2));%保留精英染色体到子代种群中
        re_mac_matrix_NSGAII(n_p_m-4:n_p_m,:)=m_matrix(1:5,:);

 end
  [re_p_matrix_NSGAII,re_m_matrix_NSGAII]= non_domination_sort_mod(re_pro_matrix_NSGAII,re_mac_matrix_NSGAII);

 
     best_index_NSGAII=find(re_p_matrix_NSGAII(:,31)==1);
        for i=1:size(best_index_NSGAII,1)
            best_m_NSGAII(i)=re_p_matrix_NSGAII(best_index_NSGAII(i),29);
            best_s_NSGAII(i)=re_p_matrix_NSGAII(best_index_NSGAII(i),30);
        end
       


         %----------PSO算法--------------%   
%     re_pro_matrix_PSO=re_pro_matrix;
%     re_mac_matrix_PSO=re_mac_matrix;  
%     k3=1;
% for i = 1 : gen1 %PSO生成重调度工序
%            [p_matrix,m_matrix]= non_domination_sort_mod(re_pro_matrix_PSO,re_mac_matrix_PSO);
%        [p_child_matrix,m_child_matrix] = PSO(re_pro_matrix_PSO,re_mac_matrix_PSO,J1);
%          for j=1:size(p_child_matrix,1)
%             P=p_child_matrix(j,1:size(m_child_matrix,2));
%             M=m_child_matrix(j,:);
%             N=machine_index(J1,P,M);
%             [part_t,mac_t]=decode(J1,P,M,N); 
%             c_time=cal_comp_time(mac_t);
%           stability=rescheduling_statibility(origin_mac_t,mac_t);
%             re_pro_matrix_PSO(j,:)=[P,c_time,stability];
%             re_mac_matrix_PSO(j,:)=M;
%          end
%           [re_p_matrix,re_m_matrix]= non_domination_sort_mod( re_pro_matrix_PSO,re_mac_matrix_PSO);
%           [index]=select_best(re_p_matrix);
%           best_PSO(k3,1:2)=[re_p_matrix(index,size(re_p_matrix,2)-3),re_p_matrix(index,size(re_p_matrix,2)-2)];  
%           k3=k3+1;
% %          n_p_m=size( re_pro_matrix_PSO,1);
% %         re_pro_matrix_PSO(n_p_m+1:n_p_m+5,:)=p_matrix(1:5,1:size( re_pro_matrix_PSO,2));%保留精英染色体到子代种群中
% %         re_mac_matrix_PSO(n_p_m+1:n_p_m+5,:)=m_matrix(1:5,:);       
%         
% end
%     for i=1:100
%         makespan(i)=best_PSO(i,1);
%         makespan_PSO= sort(makespan,'descend');
%          stable(i)=best_PSO(i,2);
%         stable_PSO=  sort(stable,'descend');
%     end
    
            x1= best_m_GWO;y1= best_s_GWO;
            x2= best_m_IGWO;y2= best_s_IGWO;
            x3= best_m_NSGAII;y3= best_s_NSGAII;
% 
        subplot(2,2,1),plot(x1,y1,'*b');
         axis([75,100,1,25]);
        xlabel('makespan'), ylabel('deviation degree');
      
        
         subplot(2,2,2),plot(x2,y2,'*r');
         axis([75,100,1,25]);
        xlabel('makespan'), ylabel('deviation degree');
        
        
         subplot(2,2,3),plot(x3,y3,'*g');
         axis([75,100,1,25]);
        xlabel('makespan'), ylabel('deviation degree');
        
%          subplot(2,1,2),plot(x,y11,'-r',x,y22,'--g',x,y33,'-*b');
%           axis([1,100,0,40]);
%         xlabel('迭代次数'), ylabel('偏离度');
%         legend('IMO-GWO','NSGA-II','MPSO');
end




