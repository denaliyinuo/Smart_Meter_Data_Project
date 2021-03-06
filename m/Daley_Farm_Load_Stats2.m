clc
clear

[status,sheets] = xlsfinfo('Hourly_Data_Smart_Meters.xlsx');

[data,titles]= xlsread('Hourly_Data_Smart_Meters.xlsx');

data_size = size(data);
data_size(1) = data_size(1) + 2;

num = numel(sheets);

file = zeros(data_size(1)-2,2);

n = 0;
a = 0;
b = 0;
for j = 1:4
for s = 1:numel(sheets)
n = n + 1;
    [data,titles]= xlsread('Hourly_Data_Smart_Meters.xlsx',s);
    data;
    data(isnan(data)) = 0;
    si = size(data);
    for x = 1:si(1)
        a = a + 1;
        for y = 1:si(2)
            b = b + 1;
            if data(x,y) == 'NaN'
                data(x,y) = 0;
            end
            file(x,y,j) = data(x,y);
        end
    end
end
end

n = 0;
k = max(max(file));

l = (data_size(1)-2);

t1 = datetime(2018,1,1,0,0,0);
t2 = datetime(2018,6,26,23,0,0);

t = t1:hours(1):t2;

tx = t(1):20:t(4248);
 

% ylim([0 k+24])
% xlim(datetime(2018,[1 6],[1 26]))
% xtickformat('MMM dd')
% xticks(t(1):10*24:max(t))
ylabel('每天电量 (kWh)')
xlabel('日期')

subplot(2,2,1)
plot(t,file(:,1))
% legend('Farm Bore 5 - 100 kW','Farm Bore 7 - 63 kVA','Farm Bore 6 - 100 kVA','Farm Bore 1 - 50 kVA','best')
% ylim([0 k+1])

title('Farm Bore 4')
ylabel('Average Hourly Load (kW)')
xlabel('Date')
xticks([tx(1) tx(2) tx(3) tx(4) tx(5) tx(6) tx(7) tx(8) tx(9)])
xlim([t(1) t(4248)])
grid on

subplot(2,2,2)
plot(t,file(:,2))
title('Farm Bore 7')
% legend('Farm Bore 5 - 100 kW','Farm Bore 7 - 63 kVA','Farm Bore 6 - 100 kVA','Farm Bore 1 - 50 kVA','best')
% ylim([0 k+1])

ylabel('Average Hourly Load (kW)')
xlabel('Date')
xticks([tx(1) tx(2) tx(3) tx(4) tx(5) tx(6) tx(7) tx(8) tx(9)])
xlim([t(1) t(4248)])
grid on

subplot(2,2,3)
plot(t,file(:,3))
title('Farm Bore 6')
% legend('Farm Bore 5 - 100 kW','Farm Bore 7 - 63 kVA','Farm Bore 6 - 100 kVA','Farm Bore 1 - 50 kVA','best')
% ylim([0 k+1])

ylabel('Average Hourly Load (kW)')
xlabel('Date')
xticks([tx(1) tx(2) tx(3) tx(4) tx(5) tx(6) tx(7) tx(8) tx(9)])
xlim([t(1) t(4248)])
grid on

subplot(2,2,4)
plot(t,file(:,4))
title('Farm Bore 1')

% legend('Farm Bore 5 - 100 kW','Farm Bore 7 - 63 kVA','Farm Bore 6 - 100 kVA','Farm Bore 1 - 50 kVA','best')
% ylim([0 k+1])

ylabel('Average Hourly Load (kW)')
xlabel('Date')
xticks([tx(1) tx(2) tx(3) tx(4) tx(5) tx(6) tx(7) tx(8) tx(9)])
xlim([t(1) t(4248)])
grid on


for j = 1:4
m = 1;
d = 1;
day_of_week = 1;
for i = 1:(data_size(1)-2)/24
    
    if day_of_week == 1 || day_of_week == 2 || day_of_week == 3 || day_of_week == 4 || day_of_week == 5
        
        T22A_beg = 11 + 24*(i-1);
        T22A_end = 20 + 24*(i-1);
        T22A(i,j) = sum(data(T22A_beg:T22A_end,j));
        
        T62_beg = 8 + 24*(i-1);
        T62_end = 21 + 24*(i-1);
        T62(i,j) = sum(data(T62_beg:T62_end,j));
        
        DoW(i) = day_of_week;
        day_of_week = day_of_week + 1;
        
    else
        
        T22A(i,j) = 0;
        T62(i,j) = 0;
        DoW(i) = day_of_week;
        day_of_week = day_of_week + 1;
        
        
        if day_of_week == 8
            day_of_week = 1;
        end
    end
        
    T65_beg = 8 + 24*(i-1);
    T65_end = 19 + 24*(i-1);
    T65(i,j) = sum(data(T65_beg:T65_end,j));
    
    total_beg = 1 + 24*(i-1);
    total_end = 24 + 24*(i-1);
    total(i,j) = sum(data(total_beg:total_end,j));
    
    if m == 1 || m == 3 || m == 5 || m == 7 || m == 8 || m == 10 || m == 12
        date(i) = datetime(2018,m,d);
        if d < 31
            d = d + 1;
        else
            m = m + 1;
            d = 1;
        end
    elseif m == 2
        date(i) = datetime(2018,m,d);
        if d < 28
            d = d + 1;
        else
            m = m + 1;
            d = 1;
        end
    else
        date(i) = datetime(2018,m,d);
        if d < 30
            d = d + 1;
        else
            m = m + 1;
            d = 1;
        end
    end
end
end

total = total';
T65 = T65';
T62 = T62';
T22A = T22A';
date = date';
DoW = DoW';

% date = cellstr(date);
date = string(date);
% T65 = num2cell(T65);

% ultimate_matrix(:,1) = date;
% ultimate_matrix(:,1) = date;
% % ultimate_matrix(:,2) = total;
% ultimate_matrix(:,3) = T22A;
% ultimate_matrix(:,4) = T62;
% ultimate_matrix(:,5) = T65;

% ultimate_matrix;

k = max(max(total));
total_size = size(total);

l = (data_size(1)-2)/24;
t = datetime(2018,1,1) + caldays(0:l-1);

% subplot(2,4,[5,6,7,8])
% plot(t,total(1,:),t,total(2,:),t,total(3,:),t,total(4,:))
% legend('Farm Bore 5 - 100 kW','Farm Bore 7 - 63 kVA','Farm Bore 6 - 100 kVA','Farm Bore 1 - 50 kVA','best')
% % ylim([0 k+24])
% xlim(datetime(2018,[1 6],[1 26]))
% xtickformat('MMM dd')
% xticks(t(1):10:t(177))
% ylabel('每天电量 (kWh)')
% xlabel('日期')
% dateFormat = -1;
% datetick('x')
% datetick('x','dd-mmm-yyyy','keepticks')
% startDate = datenum('01-01-2018');
% % Select an ending date.
% 
% endDate = datenum('06-28-2018');
% Create a variable, xdata, that corresponds to the number of months between the start and end dates.

% xData = linspace(startDate,endDate,12);
% Plot random data.

% figure
% stairs(xData,rand(1,12))

% xlswrite('T65.xls',T65)
% xlswrite('date2.xls',date)