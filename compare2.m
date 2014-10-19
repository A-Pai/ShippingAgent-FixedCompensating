%此程序比较单期和多期单一价格货物收益情况

clc
clear
close all

load JL_Single2_p0_1     %p=0.1
figure
hold on
h1=plot(c,revenue_m,'k-','LineWidth',1);
[R,id] = max(revenue_m);
h= plot(c(id),R,'k*','MarkerSize',8);
[R,id] = max(revenue_m);
fprintf('p=0.1,最大收益为：%.2e，发生当仓容为：%.2e\n', R,c(id))
fprintf('此时总运输量为：%.2e，总仓容为：%.2e，平均满载率为：%.2f%%\n', tran_T(id),c(id)*n,tran_T(id)*100/(c(id)*n))
fprintf('此时平均资金收益率为：%.2f%%\n', R*100/(c(id)*fare))



load JL_Single2_p0_2     %p=0.2
h2=plot(c,revenue_m,'k--','LineWidth',1);
[R,id] = max(revenue_m);
h= plot(c(id),R,'k*','MarkerSize',8);
fprintf('p=0.2,最大收益为：%.2e，发生当仓容为：%.2e\n', R,c(id))
fprintf('此时总运输量为：%.2e，总仓容为：%.2e，平均满载率为：%.2f%%\n', tran_T(id),c(id)*n,tran_T(id)*100/(c(id)*n))
fprintf('此时平均资金收益率为：%.2f%%\n', R*100/(c(id)*fare))

load JL_Single2_p0_4     %p=0.4
h3=plot(c,revenue_m,'k:','LineWidth',1);
[R,id] = max(revenue_m);
h= plot(c(id),R,'k*','MarkerSize',8);
fprintf('p=0.4,最大收益为：%.2e，发生当仓容为：%.2e\n', R,c(id))
fprintf('此时总运输量为：%.2e，总仓容为：%.2e，平均满载率为：%.2f%%\n', tran_T(id),c(id)*n,tran_T(id)*100/(c(id)*n))
fprintf('此时平均资金收益率为：%.2f%%\n', R*100/(c(id)*fare))

load JL_Single3
h4=plot(c,revenue_m,'r-','LineWidth',1);
[R2,id2] = max(revenue_m);
h= plot(c(id2),R2,'k*','MarkerSize',8);

grid on
legend([h1 h2 h3 h4 h],'多期p=0.1','多期p=0.2','多期p=0.4','单期','最大值','Location','best')
xlabel('仓容');
ylabel('平均收益');
title('平均收益随仓容变化曲线')
