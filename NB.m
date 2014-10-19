function Anser= NB(c,d,SL)
n=length(d);
B0=0;
for ts=1:n               %ts--观察的第几天数   n-共多少天
    if (d(ts)+B0)<c
        B0=0;                                                    %遗留到第二天的货物量为0
        D(ts)=d(ts);                  %D：第二天的承运量
    else
        B0=d(ts)+B0-c;           %%遗留到第二天的货物量为：前一天的到货量+遗留到前一天的货物量-当前的仓容
        D(ts)=d(ts)+B0;            %D：第二天的承运量
    end
end
C=prctile(D,SL*100);  %由“第二天承运量”概率分布得到的最优仓容

