function [p,m,n,p_text]=reinitPop(unprocessed_pro,J,p_text)
  p=[];%���ڹ���ı���
%     m(1:size(p,2))=0;%���ڻ��������Ⱦɫ��
    m=[];
    n=[];
    num=[];
for i=1:size(J,2)
   index=find(unprocessed_pro==i);
   a=length(index);
    num(i,1)=a; 
    for j=1:num(i,1)
         p(size(p,2)+1)=i;
    end
end
   r=randperm(size(p,2));
    p=p(1,r);%������Ч������Ļ��ڹ������

     for i=1:size(J,2)
        f{i}=find(p==i);%�ҳ�����i�ڹ���Ⱦɫ��������Ӧ�����
        pos=find(unprocessed_pro==i);
%         pro_num=m_info(pos(1));
        if num(i,1)~=0
          for j=1: num(i,1)
            k=f{i}(j);
            s=size(J(i).m{p_text(pos(j))},2);
            num1=randperm(s,1);
            n(k)=num1;
            m(k)=J(i).m{p_text(pos(j))}(num1);
%             m(f{i}(j))=J(i).m{j}(randperm(size(J(i).m{j},2),1));
          end
        end
    end
end
