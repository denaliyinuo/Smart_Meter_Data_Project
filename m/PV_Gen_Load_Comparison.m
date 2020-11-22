clc
clear

sunrise = 6.5;
sunset = 18.5;
pump_load = 22;
minutes_day = 60*24;
PV_max_gen_theoretical = 24;

time = 0:minutes(1):minutes(60*24);
PV_gen = zeros(1,24*60); 
load = zeros(1,24*60);
n = 1;
t = 0;
PV_max_gen = 0;

for i = 0:minutes_day
    load(i+1) = pump_load;
    if i < sunrise*60
        PV_gen(i+1) = 0;
    elseif i > sunset*60
        PV_gen(i+1) = 0;
    else
        PV_gen(i+1) = PV_max_gen_theoretical*sin((i-sunrise*60)/((sunset-sunrise)*60)*pi);
    end
    
    if PV_gen(i+1) > pump_load
        t = t + 1;
        battery_charge_time(t) = time(i+1);
    end
    
    if i > 0
        if PV_gen(i+1) > PV_max_gen
            PV_max_gen = PV_gen(i+1);
            time_max_gen = time(i+1);
        end
    end
            
end
 
start_time = min(battery_charge_time);
end_time = max(battery_charge_time);

x1 = min(time);
x2 = max(time);


figure('units','normalized','outerposition',[0 0 1 1])
plot(time,PV_gen,time,load,'Linewidth',4)
line([start_time start_time], [0 pump_load],'Color','k')
line([end_time end_time], [0 pump_load],'Color','k')
line([time(sunrise*60+1) time(sunrise*60+1)], [0 pump_load],'Color','k')
line([time(1) time_max_gen], [PV_max_gen_theoretical PV_max_gen_theoretical],'Color','r','Linestyle','--','Linewidth',3)
line([time_max_gen time_max_gen], [0 PV_max_gen_theoretical],'Color','r','Linestyle','--','Linewidth',3)
line([time(sunset*60+1) time(sunset*60+1)], [0 pump_load],'Color','k')
xlabel('Time','FontSize', 25)
ylabel('Power ( kW )','FontSize', 25)
title('Dean Cayley Farm - Generic Comparison of PV Generation and Pump Load vs. Time','FontSize', 25)
legend({'30 kW - PV','22 kW - Pump'},'FontSize', 15)
xtickformat('hh:mm')
xlim([x1 x2])