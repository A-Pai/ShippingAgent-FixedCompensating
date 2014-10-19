%此程序研究多期下当天发出货物的最优仓容问题---possion分布分期到达

clc
clear
close all


n=100;    %观测多少天
rate=1;       %一天内发出的运价（1类货运价）
p=0.2;      %每延后一天，赔偿p，不分1类货和2类货
Arrivals=100;
R=0;
D1=4.5E4;     %试验仓容的最低值
D2=6.5E4;     %试验仓容的最高值
cs=(D2-D1)/100;    %实验的次数

for k=1:cs
    B0=0;     %初始的“第一天余量”
    c=D1+k*100;
    for rseed=1:100
        d(rseed)=sum(weight(rseed,Arrivals,500 ,10^2));     %kg
        if d(rseed)+B0<c
            r(k,rseed)=d(rseed)*rate;
            Lf(k,rseed)=(d(rseed)+B0)/c;
        else
            r(k,rseed)=d(rseed)*rate-(d(rseed)+B0-c)*p;
            B0=d(rseed)+B0-c;
            Lf(k,rseed)=1;
        end
        if mod(rseed,20)==0&mod(k,10)==0
            fprintf('试验，当前是第%d-%d次，共%d-%d次\n', rseed,k,100,cs)
        end
    end
    gkkz=c/10;
    r_m(k)=mean(r(k,:))-gkkz;
    ratio(k)=r_m(k)/gkkz;
    
end
