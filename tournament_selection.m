%������ѡ�񷨣�ÿ�����ѡ���������壬����ѡ������ȼ��ߵĸ��壬�������ȼ�һ������ѡѡ��ӵ���ȴ�ĸ���,���ӵ������ͬ��ѡ���С����һ��
%
%p_chromosome,m_chromosome Ϊ����patro�⼯�ź������Ⱥ����   pool_size �����������ĳ���  tour_size ÿ���������Ĳ���ѡ�ָ��� 
function [p_parent_chromosome,m_parent_chromosome] = tournament_selection(p_chromosome,m_chromosome ,pool_size, tour_size)
    [pop, variables] = size(p_chromosome);%�����Ⱥ�ĸ��������;��߱������� pop��Ⱥ���� 
    rank = variables - 1;%��������������ֵ����λ��
    distance = variables;%����������ӵ��������λ��
    for i = 1 : pool_size
        for j = 1 : tour_size
             candidate(j) =randperm(100,1);
%             candidate(j) = round(pop*rand(1));%���ѡ���������
%             if candidate(j) == 0
%                 candidate(j) = 1;
%             end
            if j > 1
                while ~isempty(find(candidate(1 : j - 1) == candidate(j)))%��ֹ��������������ͬһ��
                    candidate(j) =randperm(100,1);
%                     candidate(j) = round(pop*rand(1));
%                     if candidate(j) == 0
%                         candidate(j) = 1;
%                     end
                end
            end
        end
        for j = 1 : tour_size% ��¼ÿ�������ߵ�����ȼ� ӵ����
            c_obj_rank(j) = p_chromosome(candidate(j),rank);
            c_obj_distance(j) = p_chromosome(candidate(j),distance);
        end
        min_candidate = ...
            find(c_obj_rank == min(c_obj_rank));%ѡ������ȼ���С�Ĳ����ߣ�find���ظò����ߵ�����
        if length(min_candidate) ~= 1%������������ߵ�����ȼ���� ������Ƚ�ӵ���� ����ѡ��ӵ���ȴ�ĸ���
            max_candidate = ...
            find(c_obj_distance(min_candidate) == max(c_obj_distance(min_candidate)));
            if length(max_candidate) ~= 1
                max_candidate = max_candidate(1);
            end
            p_parent_chromosome(i,:) =p_chromosome(candidate(min_candidate(max_candidate)),:);
            m_parent_chromosome(i,:)=m_chromosome(candidate(min_candidate(max_candidate)),:);   
        else
            p_parent_chromosome(i,:) =p_chromosome(candidate(min_candidate(1)),:);
            m_parent_chromosome(i,:)=m_chromosome(candidate(min_candidate(1)),:);
        end
    end
end