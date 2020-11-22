clc
clear

[status,sheets] = xlsfinfo('Seasonal_Data_2014_2017_Adjusted.xlsx');

[data,titles]= xlsread('Seasonal_Data_2014_2017_Adjusted.xlsx');

data_size = size(data);

file = zeros(data_size(1),10);

file_size = size(file);

n = 0;
for i = 1:16
    for j = 1:10
        file(i,j) = data(i,j+2);
    end
    t(i) = datetime(2014,1,1) + caldays(93*(i-1));
    total(i) = sum(file(i,:));
end

meter_season_average = zeros(4,10);

for i = 1:10
    for j = 1:4
        for k = 1:4
            meter_season_average(k,i) = file(1+4*(j-1)+(k-1),i) + meter_season_average(k,i);
        end
    end
end

meter_season_average = meter_season_average/4*2190/1000;
m = meter_season_average;

size_file = size(file);

summ = 0;
fal = 0;
win = 0;
spr = 0;
for i = 1:4
    summ = summ + total(4*(i-1)+1);
    fal = fal + total(4*(i-1)+2);
    win = win + total(4*(i-1)+3);
    spr = spr + total(4*(i-1)+4);
end

season_average_load = [summ fal win spr]/4;

plot(t,file(:,1),t,file(:,2),t,file(:,3),t,file(:,4),t,file(:,5),t,file(:,6),t,file(:,7),t,file(:,8),t,file(:,9),t,file(:,10))
xlim([t(1) t(16)])
xticks(t(1):93:t(16))
xtickformat('MMM yyyy')
xlabel('Season')
ylabel('Average Seasonal Load (kW)')

plot(t,total)
xlim([t(1) t(16)])
xticks(t(1):93:t(16))
xtickformat('MMM yyyy')
xlabel('Season')
ylabel('Average Seasonal Load (kW)')

% bar(1:4,season_demand)
title('Average Seasonal Demand 2013-17')
xlabel('Season')
ylabel('Average Total Seasonal Demand (MWh)')
grid on

m(5,:) = zeros(1,10);

for i = 1:10
    for j = 1:4
        m(5,i) = m(j,i) + m(5,i);
    end
end

lab = [3041665562,3041665589,3041665945,3041665961,3041666011,3041667603,3041669274,3041669312,3050256921,3050664182];

lab2 = {'Farm Bore 9 - 3041665562','Farm Bore 4 - 3041665589','Farm Bore 5 - 3041665945','Farm Bore 2 - 3041665961','Farm Bore 1 - 3041666011','Farm Bore 8 - 3041667603','House - 3041669274','Farm Bore 7 - 3041669312','Farm Bore 3 - 3050256921','Farm Bore 6 - 3050664182'};

% suptitle.m

for i = 1:10
    if i < 6
        subplot(2,6,i+1)
        bar(m(:,i))
        title(lab2(i))
        %title([num2str(lab(i))])
        ylim([0 35])
        grid on
        ylabel('Average Consumption ( MWh )')
        xlabel('Time Period')
        xticklabels({'Q1','Q2','Q3','Q4','Year'})
    else
        subplot(2,6,i+2)
        bar(m(:,i))
        title(lab2(i))
        %title([num2str(lab(i))])
        ylim([0 35])
        grid on
        ylabel('Average Consumption ( MWh )')
        xlabel('Time Period')
        xticklabels({'Q1','Q2','Q3','Q4','Year'})
    end
end

% season_average_load(5) = 0;
% 
% for i = 1:4
%     season_average_load(5) = season_average_load(i) + season_average_load(5);
% end

season_average_load = sum(m,2);

subplot(2,6,[1 7])
bar(season_average_load)
title('Entire Farm')
ylim([0 180])
grid on
ylabel('Average Consumption ( MWh )')
xlabel('Time Period')
xticklabels({'Q1','Q2','Q3','Q4','Year'})
