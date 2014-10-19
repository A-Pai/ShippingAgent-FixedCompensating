%�˳����о�������ֻ�յ�һ�۸������������ﵽ�ڶ��죬�����������ڲ���������ջ��������Ų�������---����

clc
clear
close all

%% ��������
n=100;    %�۲������
rate=1;       %�˼�
fare=0.6;   %���ݵ�λ�۸�
D1=0.2E4;     %������ݵ����ֵ
D2=10.2E4;     %������ݵ����ֵ,D1��D2��ȡֵ�Ǹ��ݵ����ķֲ�
Gap=1000;
cs=(D2-D1)/Gap;    %ʵ��Ĵ���
m=10;v=0.5;           %ÿ�쵽������������lognrnd��������ֵ�ͷ����ʵ�Ƕ��ڵ���̬�ֱ�ģ�

%% ����
for k=1:cs
    c=D1+k*Gap;
    tran_T(k)=0;              %��ǰ��������µ���������Total transportation--�������Ч��
    for rseed=1:n
        rng(rseed);      % �����������
        d(rseed)= lognrnd(m,v,1);      %���ɵ���Ļ���������
        if c>d(rseed)
            cost(k,rseed)=(c-d(rseed))*fare;
            revenue(k,rseed)=d(rseed)*rate-c*fare;
            Lf(k,rseed)=d(rseed)/c;
            tran_T(k)=  tran_T(k)+d(rseed);
        else
            cost(k,rseed)=(d(rseed)-c)*(rate-fare);
            revenue(k,rseed)=c*(rate-fare);          %�������ݣ����ٽӻ������Բ���
            Lf(k,rseed)=1;
            tran_T(k)=  tran_T(k)+c;                    %�ܵ�������
        end
        if mod(rseed,20)==0&mod(k,10)==0      %����������--����Ե�
            fprintf('���飬��ǰ�ǵ�%d-%d�Σ���%d-%d��\n', rseed,k,n,cs)
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
legend([h1 h2 h3 h4],'��ʧ','����','��С��','����','Location','best')
xlabel('����');
 ylabel('ƽ����ʧ������');
 title('ƽ����ʧ����������ݱ仯����')
 
 
Co=fare;                       %��������ĳɱ�
Cu=rate-fare;                %����Ӧ��ĳɱ�
Y=prctile(d,Cu*100/(Cu+Co));
fprintf('������������棨��С��ʧ�������ڵ�����Ϊ ��%.2e\n',Y)
fprintf('���飬�������Ϊ��%.2e������������Ϊ��%.2e\n', C2,c(Index2))
fprintf('���飬��С��ʧΪ��%.2e������������Ϊ��%.2e\n', C1,c(Index1))
fprintf('��ʱ��������Ϊ��%.2e���ܲ���Ϊ��%.2e,ƽ��������Ϊ��%.2f%%\n', tran_T(Index2),c(Index2)*n,tran_T(Index2)*100/(c(Index2)*n))
fprintf('��ʱƽ���ʽ�������Ϊ��%.2f%%\n', tran_T(Index2)*rate*100/(c(Index2)*n*fare))
% ratio=revenue_m./c';
% [C,Index] = max(ratio);
% figure
% hold on
% h1=plot(c(Index2),ratio(Index2),'k*','MarkerSize',10);
% h2=plot(c(Index),ratio(Index),'kh','MarkerSize',10);
% h3=plot(c,ratio,'k-','LineWidth',2);
% h4=plot(c,mean(Lf,2),'k:','LineWidth',2);
% xlabel('����');
% % ylabel('������');
% legend([h2 h1 h3 h4 ],'���������','����ֵ���','������','������','Location','best')
% grid on


figure
hold on
cdfplot(d);       %�����ۼ�����
plot(c,logncdf(c,m,v));

