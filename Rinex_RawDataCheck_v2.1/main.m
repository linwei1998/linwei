%********************GNSS Raw Data Analysis Program****************************%
%********************Author: Lucas Yao ***********************************%
%********************Version: V2.0****************************************%

clear 
clc
close all
format long
warning('off')
addpath(genpath('ReadData'));
addpath(genpath('PlotData'));
addpath(genpath('FileData'));

global timesample;
timesample=1;   

global GPS_mask;
global BDS_mask; 
global GALILEO_mask;
global QZSS_mask;
                                        
GPS_mask=1;
BDS_mask=0;
GALILEO_mask=0;
QZSS_mask=0;

signal_mask=zeros(5,4);

%  filepath1 =  "C:\WEILIN\Data\UMA680compare\30dB\COM19___9600_230914_065114.obs";                            csvre='30dBF9PL1L2.csv';                              %写入文件路径设置
%  filepath1 =  "C:\WEILIN\Data\UMA680compare\30dB\UM680A30dB.obs";                                            csvre='30dBUML1L5.csv';
%  filepath1 =  "C:\WEILIN\Data\UMA680compare\30dB\14.09.23_14.51.10_RTCM_STA8100_v5.8.21_D0_30dB_l1l2.obs";   csvre='30dBT5L1L2.csv';  
%  filepath1 =  "C:\WEILIN\Data\UMA680compare\30dB\14.09.23_14.51.10_RTCM_STA8100_v5.8.21_D0_30dB_l1l5.obs";   csvre='30dBT5L1L5.csv';
%  
%  filepath1 =  "C:\WEILIN\Data\UMA680compare\40dB\COM19___9600_230914_083156.obs";                            csvre='40dBF9PL1L2.csv';                                                 
%  filepath1 =  "C:\WEILIN\Data\UMA680compare\40dB\UM680A40dB.obs";                                            csvre='40dBUML1L5.csv';
%  filepath1 = "C:\WEILIN\Data\UMA680compare\40dB\14.09.23_16.31.27_RTCM_STA8100_v5.8.21_D0_40dB_l1l2.obs";    csvre='40dBT5L1L2.csv';
%  filepath1 =  "C:\WEILIN\Data\UMA680compare\40dB\14.09.23_16.31.27_RTCM_STA8100_v5.8.21_D0_40dB_l1l5.obs";   csvre='40dBT5L1L5.csv';

%filepath1 =  "C:\WEILIN\Data\UMA680compare\Fieldtest\20230921\UMcomparetest\COM40_230921_092634UMSPP1Hz.obs";                            csvre='COM40_230921_092634UMSPP1HzBDS.csv';
%filepath1 =  "C:\WEILIN\Data\UMA680compare\Fieldtest\20230921\UMcomparetest\COM86_230921_092607UMRTK.obs";                            csvre='COM86_230921_092607UMRTK10HzBDS.csv';

%filepath1 =  "C:\WEILIN\Data\UMA680compare\Fieldtest\20230921\UMcomparetest\3\COM40_230925_064911UMSPP1Hz.obs";                            csvre='COM40_230925_064911UMSPP1Hz.csv';
%filepath1 =  "C:\WEILIN\Data\UMA680compare\Fieldtest\20230921\UMcomparetest\3\COM92_230925_064853UMRTK1Hz.obs";                            csvre='COM92_230925_064853UMRTK1Hz.csv';
%filepath1 =  "C:\WEILIN\Data\UMA680compare\Fieldtest\20230921\UMcomparetest\4\COM92_230925_094055UMSPP.obs";                            csvre='COM92_230925_094055UMSPP.csv';

%filepath1 =  "C:\WEILIN\Data\UMA680compare\static\14.09.23_14.38.19_RTCM_STA8100_D0.obs";                            csvre='staticrawT5.csv';
%filepath1 =  "C:\WEILIN\Data\UMA680compare\static\F9P_230914_063408_1.obs";                            csvre='staticrawF9P.csv';
filepath1 =  "C:\WEILIN\Data\UMA680compare\static\UM680A_20230914_1.obs";                            csvre='staticrawUM.csv';

%InstructStr1='Read Rinex30X File1';
%filepath1=getfilepath(InstructStr1);

if isempty(filepath1)
    return
end

disp('------------------------------------------------------------------');
[reftimebegin,reftimelast,refrinexobs,signal_mask]=ReadRinex(filepath1);   %读文件

if (isempty(refrinexobs))                                                  %出现空文件则退出程序
    disp('没有搜索到观测信息程序自动退出，请检查rinex文件格式!');
    return
end

%csvre='D0l1l5.csv';                                                        %写入文件路径设置
fidcsv=Writecsvfile(csvre,signal_mask);
if(fidcsv<0)
    return
end

plot_gps(refrinexobs,fidcsv,signal_mask,0,0,0,0,0,1);                      %伪距图，相位图，dcb图，噪声图,伪距载波一致性，多路径
plot_galileo(refrinexobs,fidcsv,signal_mask,0,0,0,0,0,0);
plot_bds(refrinexobs,fidcsv,signal_mask,0,0,0,0,0,0); 
plot_qzss(refrinexobs,fidcsv,signal_mask,0,0,0,0,0,0);


fclose('all');
disp('----------------------Noise Caculate------------------------------')
noise_value=get_statistics(csvre);
disp('------------------------------------------------------------------')

disp(num2str(noise_value))
fclose('all');
%close all