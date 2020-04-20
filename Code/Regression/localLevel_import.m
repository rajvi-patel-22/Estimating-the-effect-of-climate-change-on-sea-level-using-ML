clc;clear all;close all;

% Import the CSV
localsealevel = csvread('local sea level.csv');

% Average the months
d = size(localsealevel,1);
months = sum(localsealevel(:,3)==1);
m = 0;
monthlylevel = zeros(months,1);
time = zeros(months,1);
average = 0;
days = 0;

for i = 1:d
   average = average + localsealevel(i,4);
   days = days+1;
   if(i==d || localsealevel(i+1,3)==1)
      m = m+1; 
      time(m) = localsealevel(i,1)+(localsealevel(i,2)-1)/12;
      monthlylevel(m) = average/days;
      days = 0;
      average = 0;
   end  
end

times = time*12;
N = times(end)-times(1)+1;
timef = linspace(times(1),times(end),N)';

lvl = zeros(N,1);
shift = 0;
i = 1;

while i <= N 
   if(times(i-shift)==timef(i))
       lvl(i) = monthlylevel(i-shift);
       i = i+1;
   else
       %We have a problem. The original time vector 'times' is missing this value i. 
       %Send a variable exploring ahead
       j = 0;
       while times(i-shift)~=timef(i+j)      
        j = j+1;
       end
       %Now we know that there are j months missing
       for k = 1:j
            lvl(i) = NaN;
            i = i+1;
       end
       shift = shift+j;
   end
end

%Now interpolate the NaN fields
i = 1;
while i <= N
    if isnan(lvl(i))
        j = 0;
        while isnan(lvl(i+j))     
            j = j+1;
        end
        increment = (lvl(i+j)-lvl(i-1))/(j+1);
        for k = 1:j
            lvl(i) = lvl(i-1)+k*increment;
            i = i+1;
        end
    else
        i = i+1;
    end
end

locallevel = lvl-lvl(1); % subtract reference 
time_locallevel = timef/12; % convert from months to fractional years

M = N/12;
locallevel_y = zeros(M,1);
time_locallevel_y = zeros(M,1);
average = 0;

for i = 1:N
    average = average+locallevel(i);
    if mod(i,12)==0
       locallevel_y(i/12) = average/12;
       time_locallevel_y(i/12) = time_locallevel(i-11);
       average = 0;
    end
end

locallevel_m = locallevel;
time_locallevel_m = time_locallevel;

save('locallevel_m.mat','time_locallevel_m','locallevel_m');
save('locallevel_y.mat','time_locallevel_y','locallevel_y');

hold on;
%plot(time_locallevel,locallevel);
plot(time_locallevel_y,locallevel_y);
hold off;
xlabel('Time (year)');
ylabel('Sea level rise from reference height (mm)');
axis([1900 2012 -inf inf]);
%monthlylevel = monthlylevel-monthlylevel(1);