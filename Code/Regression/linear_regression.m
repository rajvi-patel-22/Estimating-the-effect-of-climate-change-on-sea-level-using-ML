clc;clear all;close all;
tic

%% Load and process the data
frequency = 4;          % 1 for year, 4 for seasons, 12 for months
hold_fraction = 0.20;   % fraction to Divide data into training and testing part
offset =7 ;
span = 1;
t_xfirst = 1914;
t_xlast = 2013;
t_xl=2005;

features = {'globalCO2','globalpop','localprecip','localtemp'};     % define features
t_xsplit = t_xlast-round((t_xlast-t_xfirst)*hold_fraction);         % point from where test data is going to be splitted 
shift = offset+span;

% Load the data
if(frequency==1)
    appendix = '_y';
elseif(frequency==4)
    appendix = '_s';
elseif(frequency==12)
    appendix = '_m';
else error('Invalid data frequency. Select 1, 4 or 12');
end
load(['locallevel',appendix]);

%load all features according to appendix
for i = 1:size(features,2)              %size(features,2)  gives 4 from [1 4]
    load([char(features(i)),appendix]); %features are 'globalCO2','globalpop','localprecip','localtemp'
end

% normalize the inputs
for i = 1:size(features,2)
    eval([char(features(i)) appendix '=' char(features(i)) appendix '- mean(' char(features(i)) appendix ');' ]);
    eval([char(features(i)) appendix '=' char(features(i)) appendix '/ sqrt(var(' char(features(i)) appendix '));' ]);
end


%% Prepare the training and testing set according to type of data(monthly,yearly,seasonly)

%crop is a function
%   function newdata = crop(time,data,fbirst,last)
%   newdata = data(time>=first & time<last);
%   end


y_train = crop(eval(['time_locallevel',appendix]),eval(['locallevel',appendix]),t_xfirst,t_xsplit);
y_test = crop(eval(['time_locallevel',appendix]),eval(['locallevel',appendix]),t_xsplit,t_xlast);
x_train = zeros((t_xsplit-t_xfirst)*frequency,span*frequency*size(features,2)); 

for i = 0:size(features,2)-1
    feature = [char(features(i+1)),appendix];
    for j = 0:span-1
        for k = 0:frequency-1
            t = k/frequency;
            x_train(:,1+i*span*frequency+j*frequency+k) = crop(eval(['time_',feature]),eval(feature),t_xfirst+j+t,t_xsplit+j+t);
        end
    end
end

x_test = zeros((t_xlast-t_xsplit)*frequency,span*frequency*size(features,2));
for i = 0:size(features,2)-1
    feature = [char(features(i+1)),appendix];
    for j = 0:span-1
        for k = 0:frequency-1
            t = k/frequency;
            x_test(:,1+i*span*frequency+j*frequency+k) = crop(eval(['time_',feature]),eval(feature),t_xsplit+j+t,t_xlast+j+t);
        end
    end    
end

x_future = zeros(offset*frequency,span*frequency*size(features,2));
for i = 0:size(features,2)-1
    feature = [char(features(i+1)),appendix];
    for j = 0:span-1
        for k = 0:frequency-1
            t = k/frequency;
            p=t_xlast+j+t;
            q=t_xlast+offset+j+t;
            x_future(:,1+i*span*frequency+j*frequency+k) = crop(eval(['time_',feature]),eval(feature),t_xl+j+t,t_xl+offset+j+t);
        end
    end    
end

%create time vector according to training and testing data

t_traintest = crop(eval(['time_locallevel',appendix]),eval(['time_locallevel',appendix]),t_xfirst,t_xlast);%+shift,t_xlast+shift);
t_train=crop(eval(['time_locallevel',appendix]),eval(['time_locallevel',appendix]),t_xfirst,t_xsplit);
t_test=crop(eval(['time_locallevel',appendix]),eval(['time_locallevel',appendix]),t_xsplit,t_xlast);
t_future = zeros(offset*frequency,1);

for i = 0:offset-1
    for j = 0:frequency-1
        
        t_future(1+i*frequency+j) = t_xlast+i+j/frequency;
    end
end
t = [t_traintest;t_future];

% add column of 1's to the feature matrix
x_train = [ones(size(y_train)) x_train];
x_test = [ones(size(y_test)) x_test];
x_future = [ones(size(x_future,1),1) x_future];

% compute theta using normal equation  
theta = inv(x_train'*x_train)*x_train'*y_train;

% get results for MLE
y_test_MLE = (theta'*x_test')';
y_train_MLE = (theta'*x_train')';
y_future_MLE = (theta'*x_future')';
y_MLE = [y_train_MLE; y_test_MLE; y_future_MLE];

%Calculate RMSE error for MLE
train_Error_MLE = sum((y_train-y_train_MLE).^2)/sum(y_train);
test_Error_MLE = sum((y_test_MLE-y_test).^2)/sum(y_test);

mse_test_ml=((y_test_MLE-y_test).^2)./size(y_test_MLE,1);
mse_train_ml=((y_train-y_train_MLE).^2)./size(y_train,1);
rmse_train_ml=sqrt(mse_train_ml);
rmse_test_ml=sqrt(mse_test_ml);
rmse_ml=[rmse_train_ml;rmse_test_ml];

%calculate noise variance 
var=0;
for i=1:size(mse_train_ml)
    var=var+mse_train_ml(i);
end

%initialize the variance of the Gaussian prior
b_sq=150;

%calculate theta after applying MAP
theta_MAP=inv((x_train'*x_train)+(var/b_sq*eye(size(x_train,2))))*x_train'*y_train;

% get results for MAP
y_test_MAP = (theta_MAP'*x_test')';
y_train_MAP = (theta_MAP'*x_train')';
y_future_MAP = (theta_MAP'*x_future')';
y_MAP = [y_train_MAP; y_test_MAP; y_future_MAP];

%calculate RMSE error for MAP
train_Error_MAP = sum((y_train-y_train_MAP).^2)/sum(y_train);
test_Error_MAP =sum((y_test_MAP-y_test).^2)/sum(y_test);

mse_train_map=((y_train-y_train_MAP).^2)./size(y_train,1);
mse_test_map=((y_test_MAP-y_test).^2)./size(y_test_MLE,1);
rmse_train_map=sqrt(mse_train_map);
rmse_test_map=sqrt(mse_test_map);
rmse_map=[rmse_train_map;rmse_test_map];

disp(['LR RMSE train error: ',num2str(train_Error_MLE)]);
disp(['LR RMSE test error: ',num2str(test_Error_MLE)]);
disp(['LR RMSE train error after MAP: ',num2str(train_Error_MAP)]);
disp(['LR RMSE test error after MAP: ',num2str(test_Error_MAP)]);

%plot the graphs
figure;
title('Linear regression (Global)');
hold on;
plot(t,y_MLE);
plot(t,y_MAP);
xlabel('Time (years)');
ylabel('Sea level (mm)');
h1= legend('MLE Prediction','MAP Prediction','Location','northwest');

figure;
title('Linear regression using MLE');
hold on;
plot(t_traintest,[y_train; y_test]);
plot(t_train,y_train_MLE);
plot(t_test,y_test_MLE);
xlabel('Time (years)');
ylabel('Sea level (mm)');
h2 = legend('Original','MLE Prediction on train data','MLE Prediction on test data','Location','northwest');

figure;
title('Linear regression using MAP');
hold on;
plot(t_traintest,[y_train; y_test]);
plot(t_train,y_train_MAP);
plot(t_test,y_test_MAP);
xlabel('Time (years)');
ylabel('Sea level (mm)');
h3 = legend('Original','MAP Prediction on train data','MAP Prediction on test data','Location','northwest');


figure
title('RMSE Error for MLE');
hold on;
plot(t_traintest,smooth(rmse_ml));
xlabel('Time (years)');
ylabel('Root Mean square error');

figure
title('RMSE Error for MAP');
hold on;
plot(t_traintest,smooth(rmse_map));
xlabel('Time (years)');
ylabel('Root Mean square error after MAP');

figure
title('Comparison of RMSE Error for MLE & MAP');
hold on;
plot(t_traintest,smooth(rmse_ml));
plot(t_traintest,smooth(rmse_map));
xlabel('Time (years)');
ylabel('Root Mean square error');
h4 = legend('Root Mean square error for MLE','Root Mean square error for MAP','Location','northwest');

figure
title('Plotting MLE & MAP data');
hold on
plot([y_train;y_test],[y_train_MLE;y_test_MLE],'ob');
plot([y_train;y_test],[y_train_MAP;y_test_MAP],'or');
plot([y_train;y_test],[y_train;y_test],'-k','LineWidth',2);
l = legend('MLE','MAP','Location','northwest');
xlabel('Original data');
ylabel('Prediction Data');
hold off

toc