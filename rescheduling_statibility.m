function stability=rescheduling_statibility(mac_t1,mac_t2)
  c_time1=cal_comp_time(mac_t1);
  c_time2=cal_comp_time(mac_t2);
    s1=abs(c_time1-c_time2);
    s2=0;
    num1=[];num2=[];
    for i=1:size(mac_t1,2)
        num1(i)=size(mac_t1{i},1);
    end
    for i=1:size(mac_t2,2)
        num2(i)=size(mac_t2{i},1);
    end
    for i=1:size(mac_t1,2)
     s2=s2+abs(num1(i)-num2(i));
    end
    stability=s1+s2;
end

