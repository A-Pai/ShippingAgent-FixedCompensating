clc
clear
close all
m=10;v=0.5;           %ÿ�쵽������������lognrnd��������ֵ�ͷ����ʵ�Ƕ��ڵ���̬�ֱ�ģ�
n=1000;
c=20000:0.1:20010
SL=0.1;


rng(1);      % �����������
d= lognrnd(m,v,1,n);      %���ɵ����Ļ�������������,��sj*2��(�У���ǰsj��������⣬��sj��������֤

n=length(d);
for k=1:length(c)
    B(1)=0;
    for ts=1:n-1               %ts--�۲�ĵڼ�����   n-��������
        if (d(ts)+B(ts))<c(k)
            B(k,ts+1)=0;                                                    %�������ڶ���Ļ�����Ϊ0
        else
            B(k,ts+1)=d(ts)+B(ts)-c(k);           %%�������ڶ���Ļ�����Ϊ��ǰһ��ĵ�����+������ǰһ��Ļ�����-��ǰ�Ĳ���
        end
    end
    D(k,:)=d+B(k,:);
C(k)=prctile(D(k,:),SL*100);  %�ɡ��ڶ�������������ʷֲ��õ������Ų���    
end


plot(c,C)




% hold on
% h_d=cdfplot(d);
% h_D=cdfplot(D);
% h_D1=cdfplot(D1);
% h_B=cdfplot(B);
% 
% set(h_d,'LineStyle','-','Color','k');
% set(h_D,'LineStyle','-','Color','r');
% set(h_D1,'LineStyle','-','Color','r','LineWidth',4);
% set(h_B,'LineStyle','-','Color','b');
% legend([h_d h_D h_D1 h_B],'CDF_d','CDF_D','CDF_D1','CDF_B','Location','best')


