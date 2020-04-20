% This function imports data from the specified CSV file and returns the
% monthly and yearly values. It recognizes if the data has a yearly or
% monthly format, and then interpolates or averages, respectively. The
% expected format for yearly data is two column, for monthly is 13 column

function [time_y, data_y, time_m, data_m] = import_csv(filename)

% Read the file into a m-by-n array
import = csvread(filename);
import(~any(import,2),:) = [];  % remove empty rows
import(:,~any(import,1)) = [];  % remove empty columns
m = size(import,1);
n = size(import,2);

if n == 2 % assume data is in yearly format
    
    time_y = import(:,1);
    data_y = import(:,2);
    M = (m-1)*12; % We are subtracting one, because we cannot interpolate beyond the last point
    time_m = zeros(M,1);
    data_m = zeros(M,1);
    k = 0;

    % Interpolate
    for i = 1:m-1
        for j = 1:12
            k = k+1;
            time_m(k) = time_y(i)+(j-1)/12;
            data_m(k) = data_y(i)+(j-1)*(data_y(i+1)-data_y(i))/12;
        end
    end
    
    
elseif n == 13 % assume data is in monthly format
    
    time_y = import(:,1);
    
    % Straighten the monthly data from a matrix into a single column
    data_matrix = import(:,2:13);
    time_m = zeros(m*12,1);
    data_m = zeros(m*12,1);

    for i = 1:m    
        for j = 1:12
            time_m((i-1)*12+j) = time_y(i)+((j-1)/12);
            data_m((i-1)*12+j) = data_matrix(i,j); 
        end
    end
    
    % Fill in missing data
    for i= 1:m*12
        if(isnan(data_m(i)))
            data_m(i) = (data_m(i+1)+data_m(i-1))/2; % This assumes that there are no two missing data next to each other!
        end
    end
    
    % Now average the monthly data for yearly data. 
    data_y = zeros(m,1);
    average = 0;

    for i = 1:m*12
        average = average+data_m(i);
        if mod(i,12)==0
           data_y(i/12) = average/12;
           average = 0;
        end
    end

else
    error('Error: Imported data does not match expected format.')
end

figure;
hold on;
scatter(time_m,data_m,'.');
scatter(time_y,data_y,'+');
hold off;
legend('Yearly data','Monthly data');
title(filename);


end