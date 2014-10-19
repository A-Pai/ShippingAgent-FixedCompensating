%此程序研究多期下只收单一价格货物（当天发送，推迟到第二天则提供赔偿）的最优仓容问题---总量
%遍历法确定最优仓容
%考虑折扣


clc
clear
close all

%% 参数设置
n=100;    %观测多少天
rate=1;       %运价
fare=0.6;   %仓容单位价格
p=0.1;      %每延后一天，赔偿p
D1=0.2E4;     %试验仓容的最低值
D2=10.2E4;     %试验仓容的最高值,D1和D2的取值是根据到货的分布
Gap=1000;
cs=(D2-D1)/Gap;    %实验的次数cs
m=10;v=0.5;           %每天到来货物重量的lognrnd参数：均值和方差（其实是对于的正态分别的）
beta=1-1E-2;           %折扣率
% beta=1;           %折扣率
%% 试验
for k=1:cs
    B0=0;
    c=D1+k*Gap;
    for rseed=1:n
        rng(rseed);      % 设置随机种子
        d(rseed)= lognrnd(m,v,1);      %生成当天的货物总重量
        if (d(rseed)+B0)<c
            revenue(k,rseed)=d(rseed)*rate-c*fare;   %这个收益是实质的，承运所得(以接货时刻为准--接货时收钱）-仓容开支
            Lf(k,rseed)=d(rseed)/c;
            B0=0;
        else
            B0=d(rseed)+B0-c;
            revenue(k,rseed)=d(rseed)*rate-B0*p-c*fare;
            Lf(k,rseed)=1;
            if d(rseed)>c
                yc(k,rseed)=1;           %yc--延迟，如果当天的到货大于仓容，则当天会存在延迟发送
            else
                yc(k,rseed)=0;
            end
        end
        if mod(rseed,20)==0&mod(k,10)==0
            fprintf('试验，当前是第%d-%d次，共%d-%d次\n', rseed,k,n,cs)
        end
    end
    tran_T(k)=sum(d)-B0;
end
zk=repmat(beta.^(0:n-1),cs,1);      %折扣矩阵
revenue_m=mean(revenue.*zk,2);
c=D1+Gap:Gap:D2;
[R,id] = max(revenue_m);

fprintf('折扣率为：%.2f%%\n', beta*100)
fprintf('最大收益为：%.2e，发生当仓容为：%.2e\n', R,c(id))
fprintf('此时总运输量为：%.2e，总仓容为：%.2e，平均满载率为：%.2f%%\n', tran_T(id),c(id)*n,tran_T(id)*100/(c(id)*n))
fprintf('此时平均资金收益率为：%.2f%%\n', R*100/(c(id)*fare))
% save JL_Single2D_p0_1    revenue  Lf   revenue_m c d  tran_T n  fare

%% 收益随仓容变化曲线
figure
hold on
h1=plot(c,revenue_m,'k-','LineWidth',2);

h= plot(c(id),R,'k*','MarkerSize',8);
grid on
hold on
load JL_Single2_p0_1
h2=plot(c,revenue_m,'r-','LineWidth',2);
[R,id] = max(revenue_m);
h= plot(c(id),R,'k*','MarkerSize',8);

legend([h1 h2 h],'  折扣模型','无折扣模型','最大点','Location','best')
xlabel('仓容');
ylabel('平均收益');
title('平均收益随仓容变化曲线')



fprintf('无折扣时：\n')
fprintf('最大收益为：%.2e，发生当仓容为：%.2e\n', R,c(id))
fprintf('此时总运输量为：%.2e，总仓容为：%.2e，平均满载率为：%.2f%%\n', tran_T(id),c(id)*n,tran_T(id)*100/(c(id)*n))
fprintf('此时平均资金收益率为：%.2f%%\n', R*100/(c(id)*fare))


% ratio=revenue_m./c';
% [C,id] = max(ratio);
% figure
% hold on
% h2=plot(c(id),ratio(id),'kh','MarkerSize',10);
% h3=plot(c,ratio,'k-','LineWidth',2);
% h4=plot(c,mean(Lf,2),'k:','LineWidth',2);
% xlabel('仓容');
% % ylabel('收益率');
% legend([h2 h1 h3 h4 ],'收益率最大','收益值最大','收益率','满载率','Location','best')
% grid on

