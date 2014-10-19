clc
clear
close all

load JL.mat
h100=plot(R_mean,'-r','LineWidth',1);
hold on

load JL0.4.mat
h100=plot(R_mean,'-k','LineWidth',1);


load JL200.mat
h200=plot(R_mean,':k','LineWidth',1);

load JL500.mat
h500=plot(R_mean,'-k','LineWidth',2);



load JL1000.mat
h1000=plot(R_mean,'--k','LineWidth',2);

title('收益随时间分割变化');
xlabel('1类货所占时间百分比');
ylabel('收益');
legend([h100 h200 h500 h1000 ],'100天','200天','500天','1000天','location','Best')
grid on
