%���������㷨�ĺ�ʱ
%�˳����о�������ֻ�յ�һ�۸������췢�ͣ��Ƴٵ��ڶ������ṩ�⳥�������Ų�������---����
%������ȷ�����Ų��ݣ��������Ľ���֮�Ƚϣ���������������
%��������ֵ���ȶ���--��ͬ���������
%���ñ�ͯ-������(������ŵ���ַ�)


clc
clear
close all

%% ��������
sj=10;     %����������Ĵ���
n=1000;    %�۲������
rate=1;       %�˼�
fare=0.6;   %���ݵ�λ�۸�
p=0.2;      %ÿ�Ӻ�һ�죬�⳥p
D1=0.2E4;     %������ݵ����ֵ
D2=10.2E4;     %������ݵ����ֵ,D1��D2��ȡֵ�Ǹ��ݵ����ķֲ�
Gap=1000;         %����ÿ�ε����ֵ
cs=(D2-D1)/Gap;    %����Ĵ���cs
c=D1+Gap:Gap:D2; %����Ĳ������У�������Ĵ�����Ӧ
m=10;v=0.5;           %ÿ�쵽������������lognrnd��������ֵ�ͷ����ʵ�Ƕ��ڵ���̬�ֱ�ģ�
Co=fare;                      %��������ĳɱ�
Cu=rate-fare+p;          %����Ӧ��ĳɱ�
SL=Cu/(Cu+Co);            %��ͯ����ķ���ˮƽ

rng(1);      % �����������
d= lognrnd(m,v,sj*2,n);      %���ɵ����Ļ�������������,��sj*2��(�У���ǰsj��������⣬��sj��������֤

%% �������õ����Ų���
tic;
for rseed=1:sj    %��ͬ���������������--���ݲ�ͬ
    %% �����������еĲ��ݣ�һ���Ěi�ࣩȥ���飬�õ����Ų���
    for cr=1:cs                %cr-��������cs-ѭ���Ĵ���
        B0=0;
        for ts=1:n               %ts--�۲�ĵڼ�����   n-��������
                      if (d(rseed,ts)+B0)<c(cr)                    %�������Ķ��������ã�����ڵ���ĵ�������ǰһ���������
                B0=0;
            else                                                       %%�������Ķ����������ã�����ڵ���ĵ�������ǰһ���������
                B0=d(rseed,ts)+B0-c(cr);                        %%����Ҫ���������Ļ�����
            end
            revenue1(cr,ts)=d(rseed,ts)*rate-B0*p-c(cr)*fare;
%             if mod(ts,20)==0&mod(cr,10)==0
%                 fprintf('������⣬��ǰ�ǵ�%d-%d-%d�Σ���%d-%d-%d��\n', ts,cr,rseed,n,cs,sj)
%             end
        end
        revenue1_m(rseed,cr)=mean(revenue1(cr,:));                   %��ǰ�������µĶ��������ƽ��ֵ
    end
end
time_bl=toc;


%% �������õ����Ų���
tic;
for rseed=1:sj    %��ͬ���������������--���ݲ�ͬ
%%  ������(������ŵ���ַ���----���ǰ���ȥ��
    ddcs=1;  %��������
    a=D1;      %D1�����Եġ�������Ϊ��Ѳ��ݡ��Ľ�Сֵ
    b=D2;      %D2�����Եġ�������Ϊ��Ѳ��ݡ��Ľϴ�ֵ
    c_dd(rseed,ddcs)=(a+b)/2;      %�������
    Distance(rseed,ddcs)=distance(c_dd(rseed,ddcs),d(rseed,:),SL);   %��ȡ��ǰ�������c_dd(rseed,ddcs)����ǰ��������d(rseed,:)������ˮƽSL�µ�C-c
    threshold=5;    %ԭʼ��ֵ
    times=1;          %������ֵ�Ĵ���
    while abs(Distance(rseed,ddcs))>threshold         %����ǰ�ġ�C-c�����ϴ�
        if  distance(c_dd(rseed,ddcs),d(rseed,:),SL)*distance(b,d(rseed,:),SL)<0
            a=c_dd(rseed,ddcs);
        else
            b=c_dd(rseed,ddcs);
        end
        c_dd(rseed,ddcs+1)=(a+b)/2;
        Distance(rseed,ddcs+1)=distance(c_dd(rseed,ddcs+1),d(rseed,:),SL);
        ddcs=ddcs+1;
        if ddcs>20*times       %�µġ���ֵ�����ٴ�����20��
            threshold=threshold+5;      %��������ֵ��5����λ
            times=times+1;
        end
    end
    %% '���Խ�','��ͯ��'�ӽ����ͼ
%     figure
%     yx=(find(c_dd(rseed,:)~=0));       %c_dd�е�ǰ������Ч��yx�����У���Щ��Ϊ0��
%     h1=plot(c_dd(rseed,yx),'k-o','LineWidth',1,'MarkerSize',3);
%     hold on
%     h2=plot(Distance(rseed,yx),'k:o','LineWidth',1,'MarkerSize',3);
%     grid on
%     legend([h1 h2],'������','f(c)','Location','best')
%     title('����������')
    
    C_dd(rseed)=c_dd(rseed,max(find(c_dd(rseed,:)>0))) ; %ÿ�ε���ʵ������Ų���ֵ
    DistanceGg(rseed)=Distance(rseed,max(find(Distance(rseed,:)~=0))) ;     %���ԡ����ء��ġ�C-c��
end
time_dd=toc;
    
 