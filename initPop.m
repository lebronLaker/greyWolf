%��ʼ������Ⱥ���� J���������Ϣ��pΪ���ڹ���ı��� 
% mΪ��Ӧ�Ļ�������  nΪ��ѡ�豸�ڶ�Ӧ��ѡ�豸���е����к�
function [p,m,n]= initPop(J)
    p=[];%���ڹ���ı���
%     m(1:size(p,2))=0;%���ڻ��������Ⱦɫ��
    m=[];
    n=[];
    for i=1:size(J,2)%������ȵĹ�����
        for j=1:J(i).a(1)%�ù���Ĺ���
            p(size(p,2)+1)=i;
        end
    end
    r=randperm(size(p,2));
    p=p(1,r);%������Ч������Ļ��ڹ������
%-------------���ڹ���������ɶ�Ӧ�Ļ��ڻ����ı���-------------%
    for i=1:size(J,2)
        f{i}=find(p==i);%�ҳ�����i�ڹ���Ⱦɫ��������Ӧ�����
        for j=1:J(i).a(1)
            k=f{i}(j);
            s=size(J(i).m{j},2);
            num=randperm(s,1);
            n(k)=num;
            m(k)=J(i).m{j}(num);
%             m(f{i}(j))=J(i).m{j}(randperm(size(J(i).m{j},2),1));
        end
    end
end

