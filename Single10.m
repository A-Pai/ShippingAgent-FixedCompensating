%�˳����о�������ֻ�յ�һ�۸������췢�ͣ��Ƴٵ��ڶ������ṩ�⳥�������Ų�������---����
%������ȷ�����Ų��ݣ��������Ľ���֮�Ƚϣ���������������
%��������ֵ���ȶ���--��ͬ���������
%���ñ�ͯ-������(������ŵ���ַ�)


clc
clear
close all

%% ��������
sj=10;     %����������Ĵ���
n=5000;    %�۲������
rate=1;       %�˼�
fare=0.6;   %���ݵ�λ�۸�
p=0.2;      %ÿ�Ӻ�һ�죬�⳥p
D1=0.2E4;     %������ݵ����ֵ
D2=10.2E4;     %������ݵ����ֵ,D1��D2��ȡֵ�Ǹ��ݵ����ķֲ�
Gap=1000;         %�������Ӛi��
cs=(D2-D1)/Gap;    %����Ĵ���cs
c=D1+Gap:Gap:D2; %����Ĳ������У�������Ĵ�����Ӧ
m=10;v=0.5;           %ÿ�쵽������������lognrnd��������ֵ�ͷ����ʵ�Ƕ��ڵ���̬�ֱ�ģ�
Co=fare;                      %��������ĳɱ�
Cu=rate-fare+p;          %����Ӧ��ĳɱ�
SL=Cu/(Cu+Co);            %������ͯ����ķ���ˮƽ

rng(1);      % �����������
d= lognrnd(m,v,sj*2,n);      %���ɵ����Ļ�������������,��sj*2��(�У���ǰsj��������⣬��sj��������֤

%% �������͵����������Ų���

for rseed=1:sj    %��ͬ���������������--���ݲ�ͬ
    %% �����������еĲ��ݣ�һ���Ěi�ࣩȥ���飬�õ����Ų���
    for cr=1:cs                %cr-��������cs-ѭ���Ĵ���
        B(1)=0;                  %BΪ����������,���������յĻ�����Ϊ0
        for ts=1:n-1               %ts--�۲�ĵڼ�����   n-��������
            if (d(rseed,ts)+B(ts))<c(cr)                    %�������Ķ��������ã�����ڵ���ĵ�������ǰһ���������
                B(ts+1)=0;                               %%����Ҫ���������Ļ�����
                revenue1(cr,ts)=(d(rseed,ts)+B(ts))*rate-c(cr)*fare ;    %����Ϊ��ʵ�ʡ�������Ǯ--ʵ����ɵ���������ȥ�������ɱ��Ͳ���������Ҫ���������Ļ�������
            else                                                       %%�������Ķ����������ã�����ڵ���ĵ�������ǰһ���������
                B(ts+1)=d(rseed,ts)+B(ts)-c(cr);                        %%����Ҫ���������Ļ�����
                revenue1(cr,ts)=c(cr)*rate-c(cr)*fare -B(ts+1)*p;    %�������������ڶ���Ĳ���
            end
            if mod(ts,100)==0&mod(cr,100)==0
                fprintf('������⣬��ǰ�ǵ�%d-%d-%d�Σ���%d-%d-%d��\n', ts,cr,rseed,n,cs,sj)
            end
        end
        revenue1_m(rseed,cr)=mean(revenue1(cr,:));                   %��ǰ�������µĶ��������ƽ��ֵ
    end
    
%     figure
%     plot(c,revenue1_m(1,:),'k-','LineWidth',2);
%     [r_max,I] = max(revenue1_m(1,:))
%     hold on
%     h1=  plot(c(I),r_max,'k*','LineWidth',2,'MarkerSize',8);
%     xlim([0  11E+4])
%     xlabel('������')
%     ylabel('ƽ������')
%     legend(h1,'����')
%     grid on
%     figure
%     plot(c,revenue1_m(1,:),'k-','LineWidth',2);
%     hold on
%     h1=  plot(c(I),r_max,'k*','LineWidth',2,'MarkerSize',8);
%     xlim([2.7E+4  4.4E+4])
%     xlabel('������')
%     ylabel('ƽ������')
%     legend(h1,'����')
%     grid on
    
    %%  ������(������ŵ���ַ���----���ǰ���ȥ��
    ddcs=1;  %��������
    a=D1;      %D1�����Եġ�������Ϊ��Ѳ��ݡ��Ľ�Сֵ
    b=D2;      %D2�����Եġ�������Ϊ��Ѳ��ݡ��Ľϴ�ֵ
    c_dd(rseed,ddcs)=(a+b)/2;      %�������
    Distance(rseed,ddcs)=distance(c_dd(rseed,ddcs),d(rseed,:),SL);   %��ȡ��ǰ�������c_dd(rseed,ddcs)����ǰ��������d(rseed,:)������ˮƽSL�µ�C-c
    threshold=1;    %ԭʼ��ֵ
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
            threshold=threshold+1;      %��������ֵ��
            times=times+1;
        end
    end
        % '���Խ�','��ͯ��'�ӽ����ͼ
        figure
        yx=(find(c_dd(rseed,:)~=0));       %c_dd�е�ǰ������Ч��yx�����У���Щ��Ϊ0��
        h1=plot(c_dd(rseed,yx),'k-o','LineWidth',1,'MarkerSize',3);
        hold on
        h2=plot(Distance(rseed,yx),'k:o','LineWidth',1,'MarkerSize',3);
        grid on
        hl=legend([h1 h2],'������','f(c)','Location','best')
        set(hl,'Fontname', 'Times New Roman','FontAngle','italic')
%         title('����������')
xlabel('��������')
    
    C_dd(rseed)=c_dd(rseed,max(find(c_dd(rseed,:)>0))) ; %ÿ�ε���ʵ������Ų���ֵ
    DistanceGg(rseed)=Distance(rseed,max(find(Distance(rseed,:)~=0))) ;     %���ԡ����ء��ġ�C-c��
    
    
    
    %%%���ڵ�ǰ���Ų��ݣ��㷨�⣩�µ�����
    
    B=[];
    B(1)=0;
    for ts=1:n-1              %ts--�۲�ĵڼ�����   n-��������
        if (d(rseed,ts)+B(ts))<C_dd(rseed)
            B(ts+1)=0;
            revenue2(ts)=(d(rseed,ts)+B(ts))*rate-C_dd(rseed)*fare ;
        else
            B(ts+1)=d(rseed,ts)+B(ts)-C_dd(rseed);            %%�������ڶ���Ļ�����Ϊ�����쵽����+����������Ļ�����-��ǰ�Ķ�����
            revenue2(ts)=C_dd(rseed)*rate-C_dd(rseed)*fare- B(ts+1)*p;
        end
    end
    
    revenue2_m(rseed)=mean(revenue2);     %��ǰ������ݣ����������Ų����µ�ƽ������,��dΪ�������
%     revenue2_m_bj(rseed)=revenue_cyl(C_dd(rseed),d(rseed,:));    %��DΪ�������ʱ������
    
    [revenue1_m_max,id2]=max(revenue1_m,[],2);   %id2--�����⣬�ҵ�sj������������ݵ�������ֵ��λ��
    %     revenue1_m_max
    %     c(id2)
    %
    
end
bb=revenue1_m;
save bb bb;
%     C-c���
figure
plot(DistanceGg,'k-o','LineWidth',2,'MarkerSize',3);
% title('f(c)')
grid on


%% �Ƚϵ������Ĳ�����������Ĳ���
figure
h1=plot(C_dd,'k-o','LineWidth',1,'MarkerSize',3);
hold on
h2=plot(c(id2),'k:o','LineWidth',1,'MarkerSize',3);
% h3=plot(mean(d(1:sj,:),2),'k:o','LineWidth',2,'MarkerSize',3);
h=plot(C_dd-c(id2),'k-o','LineWidth',2,'MarkerSize',3);
% legend([h1 h2],'�㷨��','������','Location','best')
legend([h1 h2 h],'�㷨��','������','�㷨��--������','Location','best')
% legend([h1 h2 h3 h],'�㷨��','������','��������ֵ','�㷨��--������','Location','best')
% title('���������ϵı�����͵�����-����ֵ')
grid on

figure
h1=plot(revenue2_m,'k-o','LineWidth',1,'MarkerSize',3);
hold on
h2=plot(revenue1_m_max,'k:o','LineWidth',1,'MarkerSize',3);
h=plot(revenue2_m-revenue1_m_max','k-o','LineWidth',2,'MarkerSize',3);
 legend([h1 h2 h],'�㷨������','����������','�㷨������--����������','Location','best')
%legend([h1 h2],'������','������','Location','best')
% title('�����������������')
grid on

%     figure
%     title('���������ϵı�����͵�����')
%     boxplot([(C_dd)', (c(id2))'])
cOpti1=mean(C_dd);    %�㷨��
cOpti2=mean(c(id2));   %������
%
% %% ��������ݱ仯����
%
% figure
% plot(c,revenue_m','LineWidth',1);
% grid on
% xlabel('������');
% ylabel('ƽ������');
% title('ƽ����������ݱ仯����')


%% ��֤��������������ԣ������µ�����
%��֤sj����
for rseed=1:sj   %��ͬ���������������
    B_1=[];          %�������ʣ��������
    B_2=[];          %�������ʣ��������         
    B_1(1)=0;                      %�������������ڶ���Ļ�����
    B_2(1)=0;                      %�������������ڶ���Ļ�����
    revenueTest1=[];
    revenueTest2=[];
    for ts=1:n-1               %ts--�۲�ĵڼ�����   n-��������
        %�㷨��
        if (d(rseed+sj,ts)+B_1(ts))<cOpti1
            B_1(ts+1)=0;            %�������ڶ���Ļ�����Ϊ0
            revenueTest1(ts)=(d(rseed+sj,ts)+B_1(ts))*rate-cOpti1*fare;   %����Ϊ��ʵ�ʡ�������Ǯ--ʵ����ɵ���������ȥ�������ɱ��Ͳ���������Ҫ���������Ļ�������
        else
            B_1(ts+1)=d(rseed+sj,ts)+B_1(ts)-cOpti1;                        %����Ϊ��ʵ�ʡ�������Ǯ--ʵ����ɵ���������ȥ�������ɱ��Ͳ���������Ҫ���������Ļ�������
            revenueTest1(ts)=cOpti1*(rate-fare)-B_1(ts+1)*p;
        end
        %������
        if (d(rseed+sj,ts)+B_2(ts))<cOpti2
            B_2(ts+1)=0;            %�������ڶ���Ļ�����Ϊ0
            revenueTest2(ts)=(d(rseed+sj,ts)+B_2(ts))*rate-cOpti2*fare;   %����Ϊ��ʵ�ʡ�������Ǯ--ʵ����ɵ���������ȥ�������ɱ��Ͳ���������Ҫ���������Ļ�������
        else
            B_2(ts+1)=d(rseed+sj,ts)+B_2(ts)-cOpti2;                      %����Ϊ��ʵ�ʡ�������Ǯ--ʵ����ɵ���������ȥ�������ɱ��Ͳ���������Ҫ���������Ļ�������
            revenueTest2(ts)=cOpti2*(rate-fare)-B_2(ts+1)*p;
        end
        if mod(ts,20)==0
            fprintf('���飬��ǰ�ǵ�%d-%d�Σ���%d-%d��\n', ts,rseed-sj,n,sj)
        end
    end
    revenueMtest1(rseed)=mean(revenueTest1);                   %������Ķ��������ƽ��ֵ
    revenueMtest2(rseed)=mean(revenueTest2);                   %������Ķ��������ƽ��ֵ
    
end
% ratio=(revenueMtest1-revenueMtest2)./revenueMtest1;

figure
h1=plot(revenueMtest1,'k-o','LineWidth',1,'MarkerSize',3);
hold on
h2=plot(revenueMtest2,'k:o','LineWidth',1,'MarkerSize',3);
% h3=plot(revenue1_m_max,'r-o','LineWidth',1,'MarkerSize',3);
h=plot(revenueMtest1-revenueMtest2,'k-o','LineWidth',2,'MarkerSize',3);
 legend([h1 h2 h],'�㷨������','����������','�㷨������--����������','Location','best')
%legend([h1 h2],'�㷨��','������','Location','best')
% legend([h1 h2 h h3],'�㷨��','������','��---��','ѵ����','Location','best')
% title('������͵��������������ϵ�ƽ������')
grid on
%
% figure
% hist(revenueMtest1'- revenueMtest2')
% title('��֤�����ϵĵ�����ͱ�����������')
%
% figure
% subplot(1,2,1);
% plot(d(1,:),'k-','LineWidth',1,'MarkerSize',3);
% grid on
% % title('����������');
% subplot(1,2,2);
% [f,xi]=ksdensity(d(1,:));
% plot(xi,f,'k-','LineWidth',1,'MarkerSize',3);
% grid on
% % title('�������ֲ��ܶ�');
% hold on


fprintf('�����������Ų���ƽ��Ϊ��%.0f����׼��Ϊ��%.0f��%.0f�ڵ�ƽ������Ϊ��%.0f\n', cOpti1,std(C_dd),n,mean(revenueMtest1))
fprintf('�����������Ų���ƽ��Ϊ��%.0f����׼��Ϊ��%.0f��%.0f�ڵ�ƽ������Ϊ��%.0f\n', cOpti2,std(c(id2)),n,mean(revenueMtest2))
