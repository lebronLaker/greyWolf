function [P,M] =PSO(pro,mac,J)
%参数初始化
c1=1.49455;
c2=1.49445;
maxgen=200; %进化次数
sizepop=size(mac,1);%种群规模
Vmax=1;%最大速度
Vmin=-1;%最小速度
popmax=5;
popmin=1;
[pro,mac]= non_domination_sort_mod(pro,mac);

%产生初始速度
for i=1:sizepop
    V(i,1:size(mac,2))=rands(1);
end



%位置信息转换
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

%个体极值与群体极值
zbest=mac(1,:);%全局最佳
gbest=mac;

%迭代寻优
for i=1:maxgen
    for j=1;sizepop
        %速度更新
        V(j,:)=V(j,:)+c1*rand*(gbest(j,:)-mac(j,:))+c2*rand*(zbest-mac(j,:));
        V(j,find(V(j,:)>Vmax))=Vmax;
        V(j,find(V(j,:)<Vmin))=Vmin;
        
        %种群更新
        mac(j,:)=ceil(mac(j,:)+V(j,:));
        mac(j,find(mac(j,:)>popmax))=popmax;
        mac(j,find(mac(j,:)<popmin))=popmin;
    end
end

%将种群位置转换为机器号
for i=1:sizepop
    for ii = 1:size(J,2)        %将位置信息转换回机器号
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



