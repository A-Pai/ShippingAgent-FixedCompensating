function Answer= distance(c,d,SL)
n=length(d);
B(1)=0;
for ts=1:n-1               %ts--�۲�ĵڼ�����   n-��������
    if (d(ts)+B(ts))<c
        B(ts+1)=0;                                                    %�������ڶ���Ļ�����Ϊ0
    else
        B(ts+1)=d(ts)+B(ts)-c;           %%�������ڶ���Ļ�����Ϊ��ǰһ��ĵ�����+������ǰһ��Ļ�����-��ǰ�Ĳ���
    end
end
D=d+B;
% [f,xi]=ksdensity(D);
% plot(xi,f,'k-','LineWidth',1,'MarkerSize',3);
% cdfplot(D);
% hold on
 C=prctile(D,SL*100);  %�ɡ��ڶ�������������ʷֲ��õ������Ų���
Answer=C-c;
