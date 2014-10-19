clc
clear
close all
m=10;v=0.5;           %每天到来货物重量的lognrnd参数：均值和方差（其实是对于的正态分别的）
n=1000;
c=20000:0.1:20010
SL=0.1;


rng(1);      % 设置随机种子
d= lognrnd(m,v,1,n);      %生成到货的货物总重量序列,共sj*2次(行），前sj次用于求解，后sj次用于验证

n=length(d);
for k=1:length(c)
    B(1)=0;
    for ts=1:n-1               %ts--观察的第几天数   n-共多少天
        if (d(ts)+B(ts))<c(k)
            B(k,ts+1)=0;                                                    %遗留到第二天的货物量为0
        else
            B(k,ts+1)=d(ts)+B(ts)-c(k);           %%遗留到第二天的货物量为：前一天的到货量+遗留到前一天的货物量-当前的仓容
        end
    end
    D(k,:)=d+B(k,:);
C(k)=prctile(D(k,:),SL*100);  %由“第二天承运量”概率分布得到的最优仓容    
end


plot(c,C)




% hold on
% h_d=cdfplot(d);
% h_D=cdfplot(D);
% h_D1=cdfplot(D1);
% h_B=cdfplot(B);
% 
% set(h_d,'LineStyle','-','Color','k');
% set(h_D,'LineStyle','-','Color','r');
% set(h_D1,'LineStyle','-','Color','r','LineWidth',4);
% set(h_B,'LineStyle','-','Color','b');
% legend([h_d h_D h_D1 h_B],'CDF_d','CDF_D','CDF_D1','CDF_B','Location','best')


