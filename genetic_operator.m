function[p_child_matrix,m_child_matrix] = genetic_operator(J,p_parent_chromosome,m_parent_chromosome)
    [N,M] = size(p_parent_chromosome);%N�ǽ�����еĸ�������
   V=size(p_parent_chromosome,2)-size(m_parent_chromosome,2);%�Ż�Ŀ������
    across=0.8;
    mutation=0.15;
    p_child_matrix=[];
    m_child_matrix=[];
    k=1;%k��¼���ɵ��Ӵ���Ⱥ���������ﵽpop_sizeʱ������ѭ��
    for i = 1 : N%������Ȼѭ��N�Σ�����ÿ��ѭ�������и��ʲ���2������1���Ӵ����������ղ������Ӵ�����������Լ��2N��
        if rand(1) < across%�������0.8
            parent_1 =randperm(N,1);
            parent_2 =randperm(N,1);
        while isequal(p_parent_chromosome(parent_1,:),p_parent_chromosome(parent_2,:))%ѡ����뽻������ĸ�����Ⱥ
            parent_2 = randperm(N,1);
        end
        p_parent_1 = p_parent_chromosome(parent_1,1:M-V);
        m_parent_1=m_parent_chromosome(parent_1,:);
        p_parent_2 = p_parent_chromosome(parent_2,1:M-V);
        m_parent_2=m_parent_chromosome(parent_2,:);
        if mod(i,2)==1%���й��򽻲�
            J1=[];
            c1_p=zeros(1,M-V);%�Ӵ�Ⱦɫ��
            c1_m=zeros(1,M-V);
            c2_p=zeros(1,M-V);
            c2_m=zeros(1,M-V);
            while size(J1,1)==0&&size(J1,2)==0
                J1=find(round(rand(1,size(J,2)))==1);
            end
            for j=1:size(p_parent_1,2)%�����ڵ�һ������Ⱦɫ��������J1�Ĺ���λ�ñ���������ͬ���ڶ�������Ⱦɫ���в�����J1�Ĺ���λ�ñ�������
                if ismember(p_parent_1(j),J1)
                    c1_p(j)=p_parent_1(j);
                    c1_m(j)=m_parent_1(j);
                end
                if ~ismember(p_parent_2(j),J1)
                    c2_p(j)=p_parent_2(j);
                    c2_m(j)=m_parent_2(j);
                end
            end
            index_1_1=find(c1_p==0);
            index_1_2=find(c2_p~=0);
            index_2_2=find(c2_p==0);
            index_2_1=find(c1_p~=0);
            for j=1:size(index_1_1,2)
                c1_p(index_1_1(j))=p_parent_2(index_1_2(j));
                c1_m(index_1_1(j))=m_parent_2(index_1_2(j));
            end
            for j=1:size(index_2_2,2)
                c2_p(index_2_2(j))=p_parent_1(index_2_1(j));
                c2_m(index_2_2(j))=m_parent_1(index_2_1(j));
            end
        else%�����豸����
            c1_p=p_parent_1;
            c1_m=m_parent_1;
            c2_p=p_parent_2;
            c2_m=m_parent_2;
            m_cross_index=find(round(rand(1,M-V))==0);%ȷ����Ҫ�����豸����Ĺ���
            for j=1:size(m_cross_index,2)
                p_var=p_parent_1(m_cross_index(j));
                p_var_index=find(p_parent_1==p_var);
                p_number=find(p_var_index==m_cross_index(j));%ȷ�����ý����Ϊ�ĸ������ĵڼ�������
                %ȷ�����ù����ĸõ������ڵڶ��������е�λ��
                c2_across_index=find(p_parent_2==p_var);
                c1_m(m_cross_index(j))=m_parent_2(c2_across_index(p_number));
                c2_m(c2_across_index(p_number))=m_parent_1(m_cross_index(j));
            end      
        end
            p_child_matrix(k,:)=c1_p;
            m_child_matrix(k,:)=c1_m;
            k=k+1;
            p_child_matrix(k,:)=c2_p;
            m_child_matrix(k,:)=c2_m;
            k=k+1;
        end
        %���ڹ�����豸����
        if rand(1)<mutation%�������
            parent_3 = randperm(N,1);
            parent_4 = randperm(N,1);
            p_parent_3 = p_parent_chromosome(parent_3,1:M-V);%���빤������Ⱦɫ��
            m_parent_3 = m_parent_chromosome(parent_3,:);
            p_parent_4 = p_parent_chromosome(parent_4,1:M-V);%������������Ⱦɫ��
            m_parent_4 = m_parent_chromosome(parent_4,:);
            c3_p=p_parent_3;
            c3_m=m_parent_3;
            c4_p=p_parent_4;
            c4_m=m_parent_4;
            rand_num_1=randperm(M-V,1);%���ڹ������ģ��������ĵ�һ��λ��
            rand_num_2=randperm(M-V,1);%���ڹ������ģ��������ĵڶ���λ��
            while isequal(rand_num_1,rand_num_2)
                rand_num_2=randperm(M-V,1);
            end
%���ڹ�����췽�����������б�д
%             c3_p(rand_num_1)=p_parent_3(rand_num_2);
%             c3_m(rand_num_1)=m_parent_3(rand_num_2);
%             c3_p(rand_num_2)=p_parent_3(rand_num_1);
%             c3_m(rand_num_2)=m_parent_3(rand_num_1);
%             p_child_matrix(k,:)=c3_p;
%             m_child_matrix(k,:)=c3_m;
%             k=k+1;
% �����豸�ı���
            rand_num_3=randperm(M-V,1);%�������ĵ�һ��λ��
            rand_num_4=randperm(M-V,1);%�������ĵڶ���λ��
            while isequal(rand_num_3,rand_num_4)
                 rand_num_4=randperm(M-V,1);
            end
            p_var_3=p_parent_4(rand_num_3);
            p_var_4=p_parent_4(rand_num_4);
            muta_index_1=find(p_parent_4==p_var_3);
            num_of_p_1=find(muta_index_1==rand_num_3);%����p_var�ĵ�num_of_1������
            muta_index_2=find(p_parent_4==p_var_4);
            num_of_p_2=find(muta_index_2==rand_num_4);
            m1=randperm(size(J(p_var_3).m{num_of_p_1},2),1);
            m2=randperm(size(J(p_var_4).m{num_of_p_2},2),1);
            c4_m(rand_num_3)=J(p_var_3).m{num_of_p_1}(m1);
            c4_m(rand_num_4)=J(p_var_4).m{num_of_p_2}(m2);
            p_child_matrix(k,:)=c4_p;
            m_child_matrix(k,:)=c4_m;
            k=k+1;
        end
    end 
end

