%����������ʱ��
function  total_def_time= cal_def_time(J,part_t)
    total_def_time=0;
    for i=1:size(J,2)
        m=size(part_t{i},1);
        if(m~=0)
        comp_time=part_t{i}(m,2);
        else
            comp_time=0;
        end
        total_def_time=total_def_time+max(comp_time-J(i).a(3),0);
    end
end

