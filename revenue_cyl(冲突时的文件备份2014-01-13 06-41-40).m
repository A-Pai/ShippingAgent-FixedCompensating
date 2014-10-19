function Answer= revenue_cyl(c,d)
fare=0.6;   %仓容单位价格
p=0.2;      %每延后一天，赔偿p
rate=1;       %运价

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
for ts=1:n
    if D(ts)<c
%         revenue(ts)=d(ts)*rate-c*fare;
        revenue(ts)=D(ts)*rate-c*fare;
    else
         revenue(ts)=c*(rate-fare)-(D(ts)-c)*p;
  %     revenue(ts)=d(ts)*rate-c*fare-(D(ts)-c)*p;
    end
end
%Answer=revenue;
Answer=mean(revenue);
