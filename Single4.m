%此程序研究多期下只收单一价格货物（当天发送，推迟到第二天则提供赔偿）的最优仓容问题
%每天调整预订的仓容c=固定最优仓容C+前一天的余量B0


clc
clear
close all

%% 参数设置
n=100;                       %观测多少天
rate=1;                       %运价
fare=0.6;                   %仓容单位价格
p=0.2;                        %每延后一天，赔偿p
D1=0.2E4;                %试验仓容的最低值
D2=10.2E4;              %试验仓容的最高值,D1和D2的取值是根据到货的分布
Gap=1000;
cs=(D2-D1)/Gap;       %实验的次数cs
m=10;v=0.5;              %每天到来货物重量的lognrnd参数：均值和方差（其实是对于的正态分别的）
Co=fare;                      %供过于求的成本
Cu=rate-fare+p;          %供不应求的成本
P=Cu/(Cu+Co);            %报童问题的服务水平
C=logninv(P,m,v);        %典型报童问题的解--求取分位数

%% 试验
B0(1)=0;
for rseed=1:n
    rng(rseed);      % 设置随机种子
    d(rseed)= lognrnd(m,v,1);      %生成当天的货物总重量
    c(rseed)=C+B0(rseed);                  
    if (d(rseed)+B0(rseed))<c(rseed)
        revenue(rseed)=d(rseed)*rate-c(rseed)*fare;   %这个收益是实质的，承运所得(以接货时刻为准--接货时收钱）-仓容开支
        Lf(rseed)=d(rseed)/c(rseed);
        B0(rseed+1)=0;
    else
        B0(rseed+1)=d(rseed)+B0(rseed)-c(rseed);
        revenue(rseed)=d(rseed)*rate-B0(rseed+1)*p-c(rseed)*fare;
        Lf(rseed)=1;
        if d(rseed)>c(rseed)
            yc(rseed)=1;           %yc--延迟，如果当天的到货大于仓容，则当天会存在延迟发送
        else
            yc(rseed)=0;
        end
    end
    if mod(rseed,20)==0
        fprintf('试验，当前是第%d次，共%d次\n', rseed,n)
    end
end
tran_T=sum(d)-B0(rseed);

revenue_m=mean(revenue);

save JL_Single4_p0_2    revenue  Lf   revenue_m c d  tran_T n  fare


bar(c-d-B0(1:n),'k')
title('仓容余量');


fprintf('平均收益为：%.2e\n', revenue_m)
fprintf('此时总运输量为：%.2e，总仓容为：%.2e，平均满载率为：%.2f%%\n', tran_T,sum(c),tran_T*100/sum(c))
fprintf('此时平均资金收益率为：%.2f%%\n', revenue_m*n*100/(sum(c)*fare))




