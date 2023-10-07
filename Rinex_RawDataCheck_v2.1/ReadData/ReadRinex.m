%************************功能:按照RINEX3.0X协议读取完整的观测量***********************************************%
%************************时间：2021/12/06*****************************************************************%
%************************作者：Lucas Yao******************************************************************%

function [timebegin,timelast,Rinexobs,signal_mask]=ReadRinex(file)

    global timesample;
    global GPS_mask;
    global BDS_mask; 
    global GALILEO_mask;
    global GLONASS_mask; 
    global QZSS_mask;
    
    fid=fopen(file,'r');
    signal_mask=zeros(5,4);
    timebegin=[];
    timelast=[];
    Rinexobs=[];
    lasttime=[];
    timeepoch=[];

    while ~feof(fid)

        dat_lines='';
        dat_lines=fgetl(fid);

        if strcmp(dat_lines,'')
            continue
        end
        
        if contains(dat_lines,'SYS / # / OBS TYPES')
           
            sys_mask=dat_lines(1);
            signal_number=round(str2num(dat_lines(6))/4);
            
            switch(sys_mask)
                case 'G'
                    signal_mask(1,1)=signal_number;
                    if contains(dat_lines,'C1')
                        signal_mask(1,2)=1;
                        disp('Rinex: GPS L1 signal');
                    end
                    if contains(dat_lines,'C2')
                        signal_mask(1,3)=1;
                        disp('Rinex: GPS L2 signal');
                    end
                    if contains(dat_lines,'C5')
                        signal_mask(1,4)=1;
                        disp('Rinex: GPS L5 signal');
                    end
                case 'C'
                    signal_mask(2,1)=signal_number;
                    if contains(dat_lines,'C2')
                        signal_mask(2,2)=1;
                        disp('Rinex: BDS B1 signal');
                    end
                    if contains(dat_lines,'C7')
                        signal_mask(2,3)=1;
                        disp('Rinex: BDS B2 signal');
                    end
                    if contains(dat_lines,'C5')
                        signal_mask(2,4)=1;
                        disp('Rinex: BDS B2a signal');
                    end
                case 'E'
                    signal_mask(3,1)=signal_number;
                    if contains(dat_lines,'C1')
                        signal_mask(3,2)=1;
                        disp('Rinex: Galileo E1 signal');
                    end
                    if contains(dat_lines,'C7')
                        signal_mask(3,3)=1;
                        disp('Rinex: Galileo E5b signal');
                    end
                    if contains(dat_lines,'C5')
                        signal_mask(3,4)=1;
                        disp('Rinex: Galileo E1a signal');
                    end
                case 'R'
                    signal_mask(4,1)=signal_number;
                    if contains(dat_lines,'C1')
                        signal_mask(4,2)=1;
                        disp('Rinex: GLONASS L1 signal');
                    end
                    if contains(dat_lines,'C2')
                        signal_mask(4,3)=1;
                        disp('Rinex: GLONASS L2 signal');
                    end
                    if contains(dat_lines,'C5')
                        signal_mask(4,4)=1;
                        disp('Rinex: GLONASS L5 signal');
                    end
                case 'J'
                    signal_mask(5,1)=signal_number;
                    if contains(dat_lines,'C1')
                        signal_mask(5,2)=1;
                        disp('Rinex: QZSS L1 signal');
                    end
                    if contains(dat_lines,'C2')
                        signal_mask(5,3)=1;
                        disp('Rinex: QZSS L2 signal');
                    end
                    if contains(dat_lines,'C5')
                        signal_mask(5,4)=1;
                        disp('Rinex: QZSS L5 signal');
                    end
                otherwise
                    continue 
            end
                
        end
        
        if contains(dat_lines,'TIME OF FIRST OBS')
            timeinf=regexp(dat_lines,'\s+','split');

            year_begin=str2double(timeinf{2});
            month_begin=str2double(timeinf{3});
            day_begin=str2double(timeinf{4});
            hour_begin=str2double(timeinf{5});
            minute_begin=str2double(timeinf{6});  
            second_begin=round(str2double(timeinf{7}),1); 

            timebegin=hour_begin*3600+minute_begin*60+second_begin;
            disp(['rinex观测起始时间 UTC：',num2str(year_begin),'年',num2str(month_begin),'月',num2str(day_begin),'日'...
                ,num2str(hour_begin),'时',num2str(minute_begin),'分',num2str(second_begin),'秒']);
            continue
        end

        if contains(dat_lines,'TIME OF LAST OBS')
            timeinfo=regexp(dat_lines,'\s+','split');

            year_last=str2double(timeinfo{2});
            month_last=str2double(timeinfo{3});
            day_last=str2double(timeinfo{4});
            hour_last=str2double(timeinfo{5});
            minute_last=str2double(timeinfo{6});  
            second_last=round(str2double(timeinfo{7}),1); 
            
            lasttime=hour_last*3600+minute_last*60+second_last;
            timelast=lasttime;
            disp(['rinex观测结束时间 UTC：',num2str(year_last),'年',num2str(month_last),'月',num2str(day_last),'日',...
                num2str(hour_last),'时',num2str(minute_last),'分',num2str(second_last),'秒']);

            continue
        end

        if contains(dat_lines,'END OF HEADER')
            disp('读到rinex头结束标志：END OF HEADER');
            continue
        end

        if strcmp(dat_lines(1),'>')
            obstimeline=regexp(dat_lines,'\s+','split');
            year_epoch=str2double(obstimeline{2});
            month_epoch=str2double(obstimeline{3});
            day_epoch=str2double(obstimeline{4});
            hour_epoch=str2double(obstimeline{5});
            minute_epoch=str2double(obstimeline{6});
            second_epoch=round(str2double(obstimeline{7}),1);
            svnum_epoch=str2double(obstimeline{9});

            timeepoch=(day_epoch-day_begin)*3600*24+hour_epoch*3600+minute_epoch*60+second_epoch;
            serial=round((timeepoch-timebegin)/timesample)+1;

            for i=1:svnum_epoch
                obs_line = fgetl(fid);
                len = length(obs_line);
%                 strs = regexp(obs_line, '\s+', 'split');
%                 len_strs = length(strs);
                switch(obs_line(1))
                    case 'G'
                        if (GPS_mask==1)
                            prn=str2num(obs_line(2:3)); 
                            if(isequal(signal_mask(1,:),[1,1,0,0])||isequal(signal_mask(1,:),[1,0,1,0])||isequal(signal_mask(1,:),[1,0,0,1]))
                                Rinexobs.Gpsobs.C1(prn,serial)=str2double(obs_line(6:17));
                                Rinexobs.Gpsobs.L1(prn,serial)=str2double(obs_line(21:33));
                                Rinexobs.Gpsobs.D1(prn,serial)=str2double(obs_line(41:49));
                                Rinexobs.Gpsobs.S1(prn,serial)=str2double(obs_line(60:65));
                            elseif(isequal(signal_mask(1,:),[2,1,1,0])||isequal(signal_mask(1,:),[2,1,0,1])||isequal(signal_mask(1,:),[2,0,1,1]))
                                Rinexobs.Gpsobs.C1(prn,serial)=str2double(obs_line(6:17));
                                Rinexobs.Gpsobs.L1(prn,serial)=str2double(obs_line(21:33));
                                Rinexobs.Gpsobs.D1(prn,serial)=str2double(obs_line(41:49));
                                Rinexobs.Gpsobs.S1(prn,serial)=str2double(obs_line(60:65));
                                if(len>=129)
                                    Rinexobs.Gpsobs.P2(prn,serial)=str2double(obs_line(70:81));
                                    Rinexobs.Gpsobs.L2(prn,serial)=str2double(obs_line(85:97));
                                    Rinexobs.Gpsobs.D2(prn,serial)=str2double(obs_line(105:113)); 
                                    Rinexobs.Gpsobs.S2(prn,serial)=str2double(obs_line(124:129));
                                end
                            elseif(isequal(signal_mask(1,:),[3,1,1,1]))
                                Rinexobs.Gpsobs.C1(prn,serial)=str2double(obs_line(6:17));
                                Rinexobs.Gpsobs.L1(prn,serial)=str2double(obs_line(21:33));
                                Rinexobs.Gpsobs.D1(prn,serial)=str2double(obs_line(41:49));
                                Rinexobs.Gpsobs.S1(prn,serial)=str2double(obs_line(60:65));
                                if(len>=129)
                                    Rinexobs.Gpsobs.P2(prn,serial)=str2double(obs_line(70:81));
                                    Rinexobs.Gpsobs.L2(prn,serial)=str2double(obs_line(85:97));
                                    Rinexobs.Gpsobs.D2(prn,serial)=str2double(obs_line(105:113)); 
                                    Rinexobs.Gpsobs.S2(prn,serial)=str2double(obs_line(124:129));
                                end
                                if(len>=193)
                                    Rinexobs.Gpsobs.P3(prn,serial)=str2double(obs_line(134:145));
                                    Rinexobs.Gpsobs.L3(prn,serial)=str2double(obs_line(149:161));
                                    Rinexobs.Gpsobs.D3(prn,serial)=str2double(obs_line(169:177)); 
                                    Rinexobs.Gpsobs.S3(prn,serial)=str2double(obs_line(188:193));
                                end
                            end
                       end

                    case 'C'
                        if(BDS_mask==1)
                            prn=str2num(obs_line(2:3));
                            if(isequal(signal_mask(2,:),[1,1,0,0])||isequal(signal_mask(2,:),[1,0,1,0])||isequal(signal_mask(2,:),[1,0,0,1]))
                                Rinexobs.Bdsobs.C1(prn,serial)=str2double(obs_line(6:17));
                                Rinexobs.Bdsobs.L1(prn,serial)=str2double(obs_line(21:33));
                                Rinexobs.Bdsobs.D1(prn,serial)=str2double(obs_line(41:49));
                                Rinexobs.Bdsobs.S1(prn,serial)=str2double(obs_line(60:65));
                            elseif(isequal(signal_mask(2,:),[2,1,1,0])||isequal(signal_mask(2,:),[2,1,0,1])||isequal(signal_mask(2,:),[2,0,1,1]))
                                Rinexobs.Bdsobs.C1(prn,serial)=str2double(obs_line(6:17));
                                Rinexobs.Bdsobs.L1(prn,serial)=str2double(obs_line(21:33));
                                Rinexobs.Bdsobs.D1(prn,serial)=str2double(obs_line(41:49));
                                Rinexobs.Bdsobs.S1(prn,serial)=str2double(obs_line(60:65));
                                if(len>=129)
                                    Rinexobs.Bdsobs.P2(prn,serial)=str2double(obs_line(70:81));
                                    Rinexobs.Bdsobs.L2(prn,serial)=str2double(obs_line(85:97));
                                    Rinexobs.Bdsobs.D2(prn,serial)=str2double(obs_line(105:113)); 
                                    Rinexobs.Bdsobs.S2(prn,serial)=str2double(obs_line(124:129));
                                end
                           elseif(isequal(signal_mask(2,:),[3,1,1,1]))
                                Rinexobs.Bdsobs.C1(prn,serial)=str2double(obs_line(6:17));
                                Rinexobs.Bdsobs.L1(prn,serial)=str2double(obs_line(21:33));
                                Rinexobs.Bdsobs.D1(prn,serial)=str2double(obs_line(41:49));
                                Rinexobs.Bdsobs.S1(prn,serial)=str2double(obs_line(60:65));
                                if(len>=129)
                                    Rinexobs.Bdsobs.P2(prn,serial)=str2double(obs_line(70:81));
                                    Rinexobs.Bdsobs.L2(prn,serial)=str2double(obs_line(85:97));
                                    Rinexobs.Bdsobs.D2(prn,serial)=str2double(obs_line(105:113)); 
                                    Rinexobs.Bdsobs.S2(prn,serial)=str2double(obs_line(124:129));
                                end
                                if(len>=193)
                                    Rinexobs.Bdsobs.P3(prn,serial)=str2double(obs_line(134:145));
                                    Rinexobs.Bdsobs.L3(prn,serial)=str2double(obs_line(149:161));
                                    Rinexobs.Bdsobs.D3(prn,serial)=str2double(obs_line(169:177)); 
                                    Rinexobs.Gpsobs.S3(prn,serial)=str2double(obs_line(188:193));
                                end
                            end
                        end
                     case 'E'
                       if(GALILEO_mask==1)
                            prn=str2num(obs_line(2:3));
                            if(isequal(signal_mask(3,:),[1,1,0,0])||isequal(signal_mask(3,:),[1,0,1,0])||isequal(signal_mask(3,:),[1,0,0,1]))
                                Rinexobs.GALobs.C1(prn,serial)=str2double(obs_line(6:17));
                                Rinexobs.GALobs.L1(prn,serial)=str2double(obs_line(21:33));
                                Rinexobs.GALobs.D1(prn,serial)=str2double(obs_line(41:49));
                                Rinexobs.GALobs.S1(prn,serial)=str2double(obs_line(60:65));
                            elseif(isequal(signal_mask(3,:),[2,1,1,0])||isequal(signal_mask(3,:),[2,1,0,1])||isequal(signal_mask(3,:),[2,0,1,1]))
                                Rinexobs.GALobs.C1(prn,serial)=str2double(obs_line(6:17));
                                Rinexobs.GALobs.L1(prn,serial)=str2double(obs_line(21:33));
                                Rinexobs.GALobs.D1(prn,serial)=str2double(obs_line(41:49));
                                Rinexobs.GALobs.S1(prn,serial)=str2double(obs_line(60:65));
                                if(len>=129)
                                    Rinexobs.GALobs.P2(prn,serial)=str2double(obs_line(70:81));
                                    Rinexobs.GALobs.L2(prn,serial)=str2double(obs_line(85:97));
                                    Rinexobs.GALobs.D2(prn,serial)=str2double(obs_line(105:113)); 
                                    Rinexobs.GALobs.S2(prn,serial)=str2double(obs_line(124:129));
                                end
                            elseif(isequal(signal_mask(3,:),[3,1,1,1]))
                                Rinexobs.GALobs.C1(prn,serial)=str2double(obs_line(6:17));
                                Rinexobs.GALobs.L1(prn,serial)=str2double(obs_line(21:33));
                                Rinexobs.GALobs.D1(prn,serial)=str2double(obs_line(41:49));
                                Rinexobs.GALobs.S1(prn,serial)=str2double(obs_line(60:65));
                                if(len>=129)
                                    Rinexobs.GALobs.P2(prn,serial)=str2double(obs_line(70:81));
                                    Rinexobs.GALobs.L2(prn,serial)=str2double(obs_line(85:97));
                                    Rinexobs.GALobs.D2(prn,serial)=str2double(obs_line(105:113)); 
                                    Rinexobs.GALobs.S2(prn,serial)=str2double(obs_line(124:129));
                                end
                                if(len>=193)
                                    Rinexobs.GALobs.P3(prn,serial)=str2double(obs_line(134:145));
                                    Rinexobs.GALobs.L3(prn,serial)=str2double(obs_line(149:161));
                                    Rinexobs.GALobs.D3(prn,serial)=str2double(obs_line(169:177)); 
                                    Rinexobs.Gpsobs.S3(prn,serial)=str2double(obs_line(188:193));
                                end
                            end
                       end
                       
                     case 'R'
                         if(GLONASS_mask==1)
                            prn=str2num(obs_line(2:3));
                            if(isequal(signal_mask(4,:),[1,1,0,0])||isequal(signal_mask(4,:),[1,0,1,0])||isequal(signal_mask(4,:),[1,0,0,1]))
                                Rinexobs.Gloobs.C1(prn,serial)=str2double(obs_line(6:17));
                                Rinexobs.Gloobs.L1(prn,serial)=str2double(obs_line(21:33));
                                Rinexobs.Gloobs.D1(prn,serial)=str2double(obs_line(41:49));
                                Rinexobs.Gloobs.S1(prn,serial)=str2double(obs_line(60:65));
                            elseif(isequal(signal_mask(4,:),[2,1,1,0])||isequal(signal_mask(4,:),[2,1,0,1])||isequal(signal_mask(4,:),[2,0,1,1]))
                                Rinexobs.Gloobs.C1(prn,serial)=str2double(obs_line(6:17));
                                Rinexobs.Gloobs.L1(prn,serial)=str2double(obs_line(21:33));
                                Rinexobs.Gloobs.D1(prn,serial)=str2double(obs_line(41:49));
                                Rinexobs.Gloobs.S1(prn,serial)=str2double(obs_line(60:65));
                                if(len>=129)
                                    Rinexobs.Gloobs.P2(prn,serial)=str2double(obs_line(70:81));
                                    Rinexobs.Gloobs.L2(prn,serial)=str2double(obs_line(85:97));
                                    Rinexobs.Gloobs.D2(prn,serial)=str2double(obs_line(105:113)); 
                                    Rinexobs.Gloobs.S2(prn,serial)=str2double(obs_line(124:129));
                                end
                            elseif(isequal(signal_mask(4,:),[3,1,1,1]))
                                Rinexobs.Gloobs.C1(prn,serial)=str2double(obs_line(6:17));
                                Rinexobs.Gloobs.L1(prn,serial)=str2double(obs_line(21:33));
                                Rinexobs.Gloobs.D1(prn,serial)=str2double(obs_line(41:49));
                                Rinexobs.Gloobs.S1(prn,serial)=str2double(obs_line(60:65));
                                if(len>=129)
                                    Rinexobs.Gloobs.P2(prn,serial)=str2double(obs_line(70:81));
                                    Rinexobs.Gloobs.L2(prn,serial)=str2double(obs_line(85:97));
                                    Rinexobs.Gloobs.D2(prn,serial)=str2double(obs_line(105:113)); 
                                    Rinexobs.Gloobs.S2(prn,serial)=str2double(obs_line(124:129));
                                end
                                if(len>=193)
                                    Rinexobs.Gloobs.P3(prn,serial)=str2double(obs_line(134:145));
                                    Rinexobs.Gloobs.L3(prn,serial)=str2double(obs_line(149:161));
                                    Rinexobs.Gloobs.D3(prn,serial)=str2double(obs_line(169:177)); 
                                    Rinexobs.Gpsobs.S3(prn,serial)=str2double(obs_line(188:193));
                                end
                            end
                        end
                     case 'J'
                         if (QZSS_mask==1)
                            prn=str2num(obs_line(2:3));
                            if(isequal(signal_mask(5,:),[1,1,0,0])||isequal(signal_mask(5,:),[1,0,1,0])||isequal(signal_mask(5,:),[1,0,0,1]))
                                Rinexobs.Qzssobs.C1(prn,serial)=str2double(obs_line(6:17));
                                Rinexobs.Qzssobs.L1(prn,serial)=str2double(obs_line(21:33));
                                Rinexobs.Qzssobs.D1(prn,serial)=str2double(obs_line(41:49));
                                Rinexobs.Qzssobs.S1(prn,serial)=str2double(obs_line(60:65));
                            elseif(isequal(signal_mask(5,:),[2,1,1,0])||isequal(signal_mask(5,:),[2,1,0,1])||isequal(signal_mask(5,:),[2,0,1,1]))
                                Rinexobs.Qzssobs.C1(prn,serial)=str2double(obs_line(6:17));
                                Rinexobs.Qzssobs.L1(prn,serial)=str2double(obs_line(21:33));
                                Rinexobs.Qzssobs.D1(prn,serial)=str2double(obs_line(41:49));
                                Rinexobs.Qzssobs.S1(prn,serial)=str2double(obs_line(60:65));
                                if(len>=129)
                                    Rinexobs.Qzssobs.P2(prn,serial)=str2double(obs_line(70:81));
                                    Rinexobs.Qzssobs.L2(prn,serial)=str2double(obs_line(85:97));
                                    Rinexobs.Qzssobs.D2(prn,serial)=str2double(obs_line(105:113)); 
                                    Rinexobs.Qzssobs.S2(prn,serial)=str2double(obs_line(124:129));
                                end
                            elseif(isequal(signal_mask(5,:),[3,1,1,1]))
                                Rinexobs.Qzssobs.C1(prn,serial)=str2double(obs_line(6:17));
                                Rinexobs.Qzssobs.L1(prn,serial)=str2double(obs_line(21:33));
                                Rinexobs.Qzssobs.D1(prn,serial)=str2double(obs_line(41:49));
                                Rinexobs.Qzssobs.S1(prn,serial)=str2double(obs_line(60:65));
                                if(len>=129)
                                    Rinexobs.Qzssobs.P2(prn,serial)=str2double(obs_line(70:81));
                                    Rinexobs.Qzssobs.L2(prn,serial)=str2double(obs_line(85:97));
                                    Rinexobs.Qzssobs.D2(prn,serial)=str2double(obs_line(105:113)); 
                                    Rinexobs.Qzssobs.S2(prn,serial)=str2double(obs_line(124:129));
                                end
                                if(len>=193)
                                    Rinexobs.Qzssobs.P3(prn,serial)=str2double(obs_line(134:145));
                                    Rinexobs.Qzssobs.L3(prn,serial)=str2double(obs_line(149:161));
                                    Rinexobs.Qzssobs.D3(prn,serial)=str2double(obs_line(169:177)); 
                                    Rinexobs.Qzssobs.S3(prn,serial)=str2double(obs_line(188:193));
                                end
                            end
                         end
                otherwise
                    continue  
                end     
            end       
        end
    end

    if isempty(lasttime)
        if ~isempty(timeepoch)
            timelast=timeepoch;
            disp(['将最后观测量时间作为观测结束时间：',num2str(year_epoch),num2str(month_epoch),num2str(day_epoch),...
                 num2str(hour_epoch),num2str(minute_epoch),num2str(second_epoch)]);
        else
            disp('没有任何观测量的时间信息观测为空，请检查文件格式!');
        end
    end
    disp('--------------------------------------------------------------------------------');
    fclose(fid);
end


