function Answer= distance(c,d,SL)
n=length(d);
B(1)=0;
for ts=1:n-1               %ts--观察的第几天数   n-共多少天
    if (d(ts)+B(ts))<c
        B(ts+1)=0;                                                    %遗留到第二天的货物量为0
    else
        B(ts+1)=d(ts)+B(ts)-c;           %%遗留到第二天的货物量为：前一天的到货量+遗留到前一天的货物量-当前的仓容
    end
end
D=d+B;
% [f,xi]=ksdensity(D);
% plot(xi,f,'k-','LineWidth',1,'MarkerSize',3);
% cdfplot(D);
% hold on
 C=prctile(D,SL*100);  %由“第二天承运量”概率分布得到的最优仓容
Answer=C-c;
