function [p_child_matrix,m_child_matrix] =NSGAII(re_pro_parent_matrix,re_mac_parent_matrix,J,origin_mac_t);
  
    pop = 200; %��Ⱥ����
    gen = 10; %��������
  
   for i = 1 : gen
        pool = round(pop/2);%round() ��������ȡ�� ����ش�С
        tour = 2;%������  ����ѡ�ָ���
       [p_parent_matrix,m_parent_matrix]= non_domination_sort_mod(re_pro_parent_matrix,re_mac_parent_matrix); 
        [p_parent_chromosome,m_parent_chromosome] = tournament_selection(p_parent_matrix,m_parent_matrix,pool,tour);%������ѡ���ʺϷ�ֳ�ĸ���
        %������������Ӵ���Ⱥ
        [p_child_matrix,m_child_matrix]=genetic_operator(J,p_parent_chromosome,m_parent_chromosome);
        %���ݸ������������Ⱥ�����з�֧���������ѡȡ����һ���ĸ�����Ⱥ
   end

end


