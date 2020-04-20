function [time_s,data_s] = seasons(time_m,data_m)

m = size(time_m,1);
s = m/3;
time_s = zeros(s,1);
data_s = zeros(s,1);
mis = 1; % month in season
average = 0;

for i = 1:m
    average = average+data_m(i);
    
    if(mis==3)
       data_s(i/3) = average/3;
       time_s(i/3) = time_m(i-2);
       mis=0;
       average = 0;
    end
    
    mis = mis+1;
end


end