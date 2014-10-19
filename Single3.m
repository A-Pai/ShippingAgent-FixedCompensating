%此程序研究单期下只收单一价格货物（不遗留货物到第二天，货物总量大于仓容则截至收货）的最优仓容问题---总量

clc
clear
close all

%% 参数设置
n=100;    %观测多少天
rate=1;       %运价
fare=0.6;   %仓容单位价格
D1=0.2E4;     %试验仓容的最低值
D2=10.2E4;     %试验仓容的最高值,D1和D2的取值是根据到货的分布
Gap=1000;
cs=(D2-D1)/Gap;    %实验的次数
m=10;v=0.5;           %每天到来货物重量的lognrnd参数：均值和方差（其实是对于的正态分别的）

%% 试验
for k=1:cs
    c=D1+k*Gap;
    tran_T(k)=0;              %当前仓容情况下的总运输量Total transportation--考虑社会效益
    for rseed=1:n
        rng(rseed);      % 设置随机种子
        d(rseed)= lognrnd(m,v,1);      %生成当天的货物总重量
        if c>d(rseed)
            cost(k,rseed)=(c-d(rseed))*fare;
            revenue(k,rseed)=d(rseed)*rate-c*fare;
            Lf(k,rseed)=d(rseed)/c;
            tran_T(k)=  tran_T(k)+d(rseed);
        else
            cost(k,rseed)=(d(rseed)-c)*(rate-fare);
            revenue(k,rseed)=c*(rate-fare);          %超过仓容，不再接货，所以不赔
            Lf(k,rseed)=1;
            tran_T(k)=  tran_T(k)+c;                    %总的运输量
        end
        if mod(rseed,20)==0&mod(k,10)==0      %输出计算进度--间断性的
            fprintf('试验，当前是第%d-%d次，共%d-%d次\n', rseed,k,n,cs)
        end
    end
end

cost_m=mean(cost,2);
revenue_m=mean(revenue,2);

c=D1+Gap:Gap:D2;
save JL_Single3   cost revenue  Lf  cost_m revenue_m  tran_T  c


figure
h1 = plot(c,cost_m,'k-','LineWidth',2);
hold on
h2 = plot(c,revenue_m,'r-','LineWidth',2);
[C1,Index1] = min(cost_m);
[C2,Index2] = max(revenue_m);
h3= plot(c(Index1),C1,'k*','MarkerSize',5);
h4= plot(c(Index2),C2,'r*','MarkerSize',5);
grid on
legend([h1 h2 h3 h4],'损失','收益','最小点','最大点','Location','best')
xlabel('仓容');
 ylabel('平均损失或收益');
 title('平均损失或收益随仓容变化曲线')
 
 
Co=fare;                       %供过于求的成本
Cu=rate-fare;                %供不应求的成本
Y=prctile(d,Cu*100/(Cu+Co));
fprintf('理论上最大收益（最小损失）发生在当仓容为 ：%.2e\n',Y)
fprintf('试验，最大收益为：%.2e，发生当仓容为：%.2e\n', C2,c(Index2))
fprintf('试验，最小损失为：%.2e，发生当仓容为：%.2e\n', C1,c(Index1))
fprintf('此时总运输量为：%.2e，总仓容为：%.2e,平均满载率为：%.2f%%\n', tran_T(Index2),c(Index2)*n,tran_T(Index2)*100/(c(Index2)*n))
fprintf('此时平均资金收益率为：%.2f%%\n', tran_T(Index2)*rate*100/(c(Index2)*n*fare))
% ratio=revenue_m./c';
% [C,Index] = max(ratio);
% figure
% hold on
% h1=plot(c(Index2),ratio(Index2),'k*','MarkerSize',10);
% h2=plot(c(Index),ratio(Index),'kh','MarkerSize',10);
% h3=plot(c,ratio,'k-','LineWidth',2);
% h4=plot(c,mean(Lf,2),'k:','LineWidth',2);
% xlabel('仓容');
% % ylabel('收益率');
% legend([h2 h1 h3 h4 ],'收益率最大','收益值最大','收益率','满载率','Location','best')
% grid on


figure
hold on
cdfplot(d);       %概率累计曲线
plot(c,logncdf(c,m,v));

