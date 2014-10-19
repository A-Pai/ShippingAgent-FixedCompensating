%此程序比较单期和多期单一价格货物收益情况

clc
clear
close all

load JL_Single2_p0_1
[R1,id1] = max(revenue_m);
h1= plot(c(id1),R1,'k*','MarkerSize',5);
hold on
h2=plot(c,revenue_m,'k-','LineWidth',2);
tran_T2=tran_T(id1);

fprintf('多期，最大收益为：%.2f，发生在当仓容为：%d\n', R1,c(id1))

load JL_Single3
h3=plot(c,revenue_m,'r-','LineWidth',2);
[R2,id2] = max(revenue_m);
h= plot(c(id2),R2,'r*','MarkerSize',5);
legend([h1,h2,h3],'最大值','多期','单期','Location','best')
xlabel('仓容');
ylabel('平均收益');
grid on
tran_T3=tran_T(id2);
fprintf('单期，最大收益为：%.2f，发生在当仓容为：%d\n', R2,c(id2))

fprintf('多期比单期的收益增加了：%.2f%%，多运送货物：%.2f%%\n', (R1-R2)*100/R2,(tran_T2-tran_T3)*100/tran_T3)