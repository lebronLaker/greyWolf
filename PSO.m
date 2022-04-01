function [P,M] =PSO(pro,mac,J)
%������ʼ��
c1=1.49455;
c2=1.49445;
maxgen=200; %��������
sizepop=size(mac,1);%��Ⱥ��ģ
Vmax=1;%����ٶ�
Vmin=-1;%��С�ٶ�
popmax=5;
popmin=1;
[pro,mac]= non_domination_sort_mod(pro,mac);

%������ʼ�ٶ�
for i=1:sizepop
    V(i,1:size(mac,2))=rands(1);
end



%λ����Ϣת��
for i=1:sizepop
    for j=1:size(J,2)
        pos=find(pro(i,1:size(mac,2))==j);
          for k= 1:J(j).a(1) 
              if length(find(J(j).m{k}==mac(i,pos(k))))>1
                  mac(i,pos(k))=0;                             
              else  
                     mac(i,pos(k)) = find(J(j).m{k}==mac(i,pos(k))); 
              end
          end
    end
end

%���弫ֵ��Ⱥ�弫ֵ
zbest=mac(1,:);%ȫ�����
gbest=mac;

%����Ѱ��
for i=1:maxgen
    for j=1;sizepop
        %�ٶȸ���
        V(j,:)=V(j,:)+c1*rand*(gbest(j,:)-mac(j,:))+c2*rand*(zbest-mac(j,:));
        V(j,find(V(j,:)>Vmax))=Vmax;
        V(j,find(V(j,:)<Vmin))=Vmin;
        
        %��Ⱥ����
        mac(j,:)=ceil(mac(j,:)+V(j,:));
        mac(j,find(mac(j,:)>popmax))=popmax;
        mac(j,find(mac(j,:)<popmin))=popmin;
    end
end

%����Ⱥλ��ת��Ϊ������
for i=1:sizepop
    for ii = 1:size(J,2)        %��λ����Ϣת���ػ�����
             pos=find(pro(i,1:size(mac,2))==ii);
            for j = 1:J(ii).a(1)
                  if length(J(ii).m{j})<mac(i,(pos(j))) 
                        n= ceil(rand*length(J(ii).m{j})); 
                        mac(i,pos(j)) = J(ii).m{j}(n);                
                  else           
                      mac(i,pos(j)) = J(ii).m{j}( mac(i,pos(j)));
                  end  
            end
    end
end
   P=pro;
   M=mac;
end



