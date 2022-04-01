function [p_child_matrix,m_child_matrix] = GWO(p_parent_chromosome,m_parent_chromosome,J,a)
  p_child_matrix=[];
   m_child_matrix=[];
   num1=find(p_parent_chromosome(:,size(p_parent_chromosome,2)-1)==1);
     num2=find(p_parent_chromosome(:,size(p_parent_chromosome,2)-1)==2);
       num3=find(p_parent_chromosome(:,size(p_parent_chromosome,2)-1)==3);
      num4=find(p_parent_chromosome(:,size(p_parent_chromosome,2)-1)==4);
       for i=1:length(num1)
               num_index(i)=num1(i);            
       end
       for i=1:length(num2)
            num_index(length(num1)+i)=num2(i);
            
       end
       for i=1:length(num3)
            num_index(length(num1)+length(num2)+i)=num3(i);
       end
      for i=1:length(num4)
            num_index(length(num1)+length(num2)+length(num3)+i)=num4(i);
       end
       p1=m_parent_chromosome(num_index(1),:);
        p2=m_parent_chromosome(num_index(2),:);
        p3=m_parent_chromosome(num_index(3),:);
        a=num_index(1);
        b=num_index(2);
        c=num_index(3);
%   if length(num1)>=3      
% p1=m_parent_chromosome(num1(1),:);
% p2=m_parent_chromosome(num1(2),:);
% p3=m_parent_chromosome(num1(3),:);
% a=num1(1);
% b=num1(2);
% c=num1(3);
%   elseif length(num1)==2
% p1=m_parent_chromosome(num1(1),:);
% p2=m_parent_chromosome(num1(2),:);
% p3=m_parent_chromosome(num2(1),:);
% a=num1(1);
% b=num1(2);
% c=num2(1);
%   elseif  length(num1)==1&&length(num2)>=2
% p1=m_parent_chromosome(num1(1),:);
% p2=m_parent_chromosome(num2(1),:);
% p3=m_parent_chromosome(num2(2),:);
% a=num1(1);
% b=num2(1);
% c=num2(2);
%   else
% p1=m_parent_chromosome(num1(1),:);
% p2=m_parent_chromosome(num2(1),:);
% p3=m_parent_chromosome(num3(1),:);
% a=num1(1);
% b=num2(1);
% c=num3(1);


  gen=100;
for i=1:gen        %对N个染色体进行更新
     p5=p1;        %为防止p1，p2，p3的数值发生变化，赋值给p5，p6，p7
     p6=p2;
     p7=p3;
    if i==1     %将前三个最好的解放入下一代数的前三个解，保证最优解不会变坏
      m_child_matrix(1,:) = p5;
       p_child_matrix(1,:)=p_parent_chromosome(a,1:size(m_parent_chromosome,2));
    elseif i==2
       m_child_matrix(2,:)= p6;
        p_child_matrix(2,:)=p_parent_chromosome(b,1:size(m_parent_chromosome,2));
    elseif i==3
       m_child_matrix(3,:) = p7;
        p_child_matrix(3,:)=p_parent_chromosome(c,1:size(m_parent_chromosome,2));
    elseif i>3
        p4 = m_parent_chromosome(i-3,:);   %将其余的灰狼取出
        for ii=1:size(J,2)  %进行位置信息转
             pos1=find(p_parent_chromosome(a,1:size(m_parent_chromosome,2))==ii);
             pos2=find(p_parent_chromosome(b,1:size(m_parent_chromosome,2))==ii);
             pos3=find(p_parent_chromosome(c,1:size(m_parent_chromosome,2))==ii);
             pos4=find(p_parent_chromosome(i-3,1:size(m_parent_chromosome,2))==ii);
%                  for index=1;size(pos,2)
             for j = 1:J(ii).a(1)
                
                 if length(find(J(ii).m{j}==p5(pos1(j))))>1
                     p5(pos1(j)) = 0;
                 else
                     p5(pos1(j)) = find(J(ii).m{j}==p5(pos1(j)));

                 end
                 if length(find(J(ii).m{j}==p6(pos2(j))))>1
                     p6(pos2(j)) = 0;
                 else
                     p6(pos2(j))= find(J(ii).m{j}==p6(pos2(j)));
                 end

                 if length(find(J(ii).m{j}==p7(pos3(j))))>1
                     p7(pos3(j)) = 0;
                else
                 p7(pos3(j)) = find(J(ii).m{j}==p7(pos3(j)));

                 end
                 if length(find(J(ii).m{j}==p4(pos4(j))))>1
                     p4(pos4(j)) = 0;
                 else
                      p4(pos4(j))= find(J(ii).m{j}==p4(pos4(j)));

                 end
                 
             end
         end
        p4 = abs(ceil((p5-(2*a*rand-a).*((2*rand).*p5-p4)+p6-(2*a*rand-a).*((2*rand).*p6-p4)+p7-(2*a*rand-a).*((2*rand).*p7-p4))/3));
        %灰狼位置更新公式
        for ii = 1:size(J,2)        %将位置信息转换回机器号
             pos=find(p_parent_chromosome(i-3,1:size(m_parent_chromosome,2))==ii);
            for j = 1:J(ii).a(1)
                  if length(J(ii).m{j})<p4(pos(j))||p4(pos(j))==0 
                 n= ceil(rand*length(J(ii).m{j})); 
                    p4(pos(j)) = J(ii).m{j}(n);                
                  else           
                       p4(pos(j)) = J(ii).m{j}( p4(pos(j)));
                  end  
            end
        end
       m_child_matrix(i,:) = p4;
         p_child_matrix(i,:)=p_parent_chromosome(i-3,1:size(m_parent_chromosome,2));
    end
 
end

