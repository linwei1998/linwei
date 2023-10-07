close all
clear 
clc
format long

global timesample;
timesample=1;                                                            %数据采样率

global GPS_mask;
global BDS_mask; 
global GALILEO_mask;
global QZSS_mask;

GPS_mask=0;
BDS_mask=0;
GALILEO_mask=1;
QZSS_mask=0;

global ref_GPS;
global ref_BDS;
global ref_Galileo;
global ref_QZSS;

ref_GPS=0;
ref_BDS=10;
ref_Galileo=0;
ref_QZSS=0;

signal_mask=[];
signa2_mask=[];

% filepath1 = "C:\WEILIN\Data\UMA680compare\30dB\rinex-obs_V1_A1-static vehicle_30dB_l1l2.obs";  filepath2 =  "C:\WEILIN\Data\UMA680compare\30dB\COM19___9600_230914_065114.obs";                            csvre='30dBF9PL1L2DD.csv';       
% filepath1 = "C:\WEILIN\Data\UMA680compare\30dB\rinex-obs_V1_A1-static vehicle_30dB_l1l5.obs";  filepath2 =  "C:\WEILIN\Data\UMA680compare\30dB\UM680A30dB.obs";                                            csvre='30dBUML1L5DD.csv';
% filepath1 = "C:\WEILIN\Data\UMA680compare\30dB\rinex-obs_V1_A1-static vehicle_30dB_l1l2.obs";  filepath2 =  "C:\WEILIN\Data\UMA680compare\30dB\14.09.23_14.51.10_RTCM_STA8100_v5.8.21_D0_30dB_l1l2.obs";   csvre='30dBT5L1L2DD.csv';  
 filepath1 = "C:\WEILIN\Data\UMA680compare\30dB\rinex-obs_V1_A1-static vehicle_30dB_l1l5.obs";  filepath2 =  "C:\WEILIN\Data\UMA680compare\30dB\14.09.23_14.51.10_RTCM_STA8100_v5.8.21_D0_30dB_l1l5.obs";   csvre='30dBT5L1L5DD.csv';
%  
% filepath1 = "C:\WEILIN\Data\UMA680compare\40dB\rinex-obs_V1_A1-static vehicle_40dB_l1l2.obs";  filepath2 =  "C:\WEILIN\Data\UMA680compare\40dB\COM19___9600_230914_083156.obs";                            csvre='40dBF9PL1L2DD.csv';                                                 
% filepath1 = "C:\WEILIN\Data\UMA680compare\40dB\rinex-obs_V1_A1-static vehicle_40dB_l1l5.obs";  filepath2 =  "C:\WEILIN\Data\UMA680compare\40dB\UM680A40dB.obs";                                            csvre='40dBUML1L5DD.csv';
% filepath1 = "C:\WEILIN\Data\UMA680compare\40dB\rinex-obs_V1_A1-static vehicle_40dB_l1l2.obs";  filepath2 = "C:\WEILIN\Data\UMA680compare\40dB\14.09.23_16.31.27_RTCM_STA8100_v5.8.21_D0_40dB_l1l2.obs";    csvre='40dBT5L1L2DD.csv';
% filepath1 = "C:\WEILIN\Data\UMA680compare\40dB\rinex-obs_V1_A1-static vehicle_40dB_l1l5.obs";  filepath2 =  "C:\WEILIN\Data\UMA680compare\40dB\14.09.23_16.31.27_RTCM_STA8100_v5.8.21_D0_40dB_l1l5.obs";   csvre='40dBT5L1L5DD.csv';

% InstructStr1='Read Rinex30X File1';
% filepath1=getfilepath(InstructStr1);
% if isempty(filepath1)
%     return
% end
% 
% InstructStr2='Read Rinex30X File2';
% filepath2=getfilepath(InstructStr2);
% if isempty(filepath2)
%     return
% end



[reftimebegin,reftimelast,refrinexobs,signal1_mask]=ReadRinex(filepath1);  %读文件
[timebegin,timelast,rinexobs,signal2_mask]=ReadRinex(filepath2);

if (isempty(refrinexobs)||isempty(rinexobs))                               %出现空文件则退出程序
    disp('没有搜索到观测信息程序自动退出，请检查rinex文件格式!');
    return
end

timeend=floor(min(reftimelast,timelast));
timefirst=ceil(max(reftimebegin,timebegin));

if(timeend>timefirst)
    disp(['同步观测时段长度：',num2str(timeend-timefirst),'秒']);
else
    disp('无同步观测时段');
    return
end

index1(2)=round((timeend-reftimebegin)/timesample)+1;
index1(1)=round((timefirst-reftimebegin)/timesample)+1;
index2(2)=round((timeend-timebegin)/timesample)+1;
index2(1)=round((timefirst-timebegin)/timesample)+1;

REFOBS1=GetComObs(refrinexobs,index1);                                     %得到同步观测时段观测量
name1=fieldnames(REFOBS1);
Sysnum1=length(name1);

TSSOBS2=GetComObs(rinexobs,index2);
name2=fieldnames(TSSOBS2);
Sysnum2=length(name2);

if(Sysnum1==0||Sysnum2==0)                                                 %没有同步观测到就退出
    disp('rinex文件不具备同步观测时段，退出程序！');
    return
end

%csvre='_.csv';                                                     %写入文件路径设置
fidcsv=Writecsvfile(csvre,signal1_mask,signal2_mask);
if(fidcsv<0)
    return
end
disp('------------------------------------------------------------------');

plot_gps(REFOBS1,TSSOBS2,signal1_mask,fidcsv,1,0);
plot_galileo(REFOBS1,TSSOBS2,signal2_mask,fidcsv,1,0);
plot_bds(REFOBS1,TSSOBS2,signal2_mask,fidcsv,1,0);
plot_qzss(REFOBS1,TSSOBS2,signal2_mask,fidcsv,1,0);

fclose('all');
%close all        