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

title('������ʱ��ָ�仯');
xlabel('1�����ռʱ��ٷֱ�');
ylabel('����');
legend([h100 h200 h500 h1000 ],'100��','200��','500��','1000��','location','Best')
grid on
