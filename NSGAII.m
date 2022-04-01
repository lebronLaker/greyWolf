function [p_child_matrix,m_child_matrix] =NSGAII(re_pro_parent_matrix,re_mac_parent_matrix,J,origin_mac_t);
  
    pop = 200; %种群数量
    gen = 10; %迭代次数
  
   for i = 1 : gen
        pool = round(pop/2);%round() 四舍五入取整 交配池大小
        tour = 2;%竞标赛  参赛选手个数
       [p_parent_matrix,m_parent_matrix]= non_domination_sort_mod(re_pro_parent_matrix,re_mac_parent_matrix); 
        [p_parent_chromosome,m_parent_chromosome] = tournament_selection(p_parent_matrix,m_parent_matrix,pool,tour);%竞标赛选择适合繁殖的父代
        %交叉变异生成子代种群
        [p_child_matrix,m_child_matrix]=genetic_operator(J,p_parent_chromosome,m_parent_chromosome);
        %根据父类和子类总种群，进行非支配快速排序，选取出下一代的父代种群
   end

end


