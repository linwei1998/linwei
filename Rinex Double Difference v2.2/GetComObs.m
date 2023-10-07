function obsdata=GetComObs(rinexobs,time)
    obsdata=[];
    if(time(1)>time(2))
        error('index error');
    end

    if isfield(rinexobs,'Gpsobs')
        if(isfield(rinexobs.Gpsobs,'C1'))
            obsdata.GPS.C1=rinexobs.Gpsobs.C1(:,time(1):time(2));
            obsdata.GPS.L1=rinexobs.Gpsobs.L1(:,time(1):time(2));
            obsdata.GPS.D1=rinexobs.Gpsobs.D1(:,time(1):time(2));
            obsdata.GPS.S1=rinexobs.Gpsobs.S1(:,time(1):time(2));
        end
        
        if(isfield(rinexobs.Gpsobs,'P2'))
            obsdata.GPS.P2=rinexobs.Gpsobs.P2(:,time(1):time(2));
            obsdata.GPS.L2=rinexobs.Gpsobs.L2(:,time(1):time(2));
            obsdata.GPS.D2=rinexobs.Gpsobs.D2(:,time(1):time(2));
            obsdata.GPS.S2=rinexobs.Gpsobs.S2(:,time(1):time(2));
        end

        if(isfield(rinexobs.Gpsobs,'P3'))
            obsdata.GPS.P3=rinexobs.Gpsobs.P3(:,time(1):time(2));
            obsdata.GPS.L3=rinexobs.Gpsobs.L3(:,time(1):time(2));
            obsdata.GPS.D3=rinexobs.Gpsobs.D3(:,time(1):time(2));
            obsdata.GPS.S3=rinexobs.Gpsobs.S3(:,time(1):time(2));
        end
    end

    if isfield(rinexobs,'Bdsobs')
        if(isfield(rinexobs.Bdsobs,'C1'))
            obsdata.BDS.C1=rinexobs.Bdsobs.C1(:,time(1):time(2));
            obsdata.BDS.L1=rinexobs.Bdsobs.L1(:,time(1):time(2));
            obsdata.BDS.D1=rinexobs.Bdsobs.D1(:,time(1):time(2));
            obsdata.BDS.S1=rinexobs.Bdsobs.S1(:,time(1):time(2));
        end

        if(isfield(rinexobs.Bdsobs,'P2'))
            obsdata.BDS.P2=rinexobs.Bdsobs.P2(:,time(1):time(2));
            obsdata.BDS.L2=rinexobs.Bdsobs.L2(:,time(1):time(2));
            obsdata.BDS.D2=rinexobs.Bdsobs.D2(:,time(1):time(2));
            obsdata.BDS.S2=rinexobs.Bdsobs.S2(:,time(1):time(2));
        end

        if(isfield(rinexobs.Bdsobs,'P3'))
            obsdata.BDS.P3=rinexobs.Bdsobs.P3(:,time(1):time(2));
            obsdata.BDS.L3=rinexobs.Bdsobs.L3(:,time(1):time(2));
            obsdata.BDS.D3=rinexobs.Bdsobs.D3(:,time(1):time(2));
            obsdata.BDS.S3=rinexobs.Bdsobs.S3(:,time(1):time(2));
        end

    end

    if isfield(rinexobs,'GALobs')
        if(isfield(rinexobs.GALobs,'C1'))
            obsdata.GALILEO.C1=rinexobs.GALobs.C1(:,time(1):time(2));
            obsdata.GALILEO.L1=rinexobs.GALobs.L1(:,time(1):time(2));
            obsdata.GALILEO.D1=rinexobs.GALobs.D1(:,time(1):time(2));
            obsdata.GALILEO.S1=rinexobs.GALobs.S1(:,time(1):time(2));
        end

        if(isfield(rinexobs.GALobs,'P2'))
            obsdata.GALILEO.P2=rinexobs.GALobs.P2(:,time(1):time(2));
            obsdata.GALILEO.L2=rinexobs.GALobs.L2(:,time(1):time(2));
            obsdata.GALILEO.D2=rinexobs.GALobs.D2(:,time(1):time(2));
            obsdata.GALILEO.S2=rinexobs.GALobs.S2(:,time(1):time(2));
        end
        
        if(isfield(rinexobs.GALobs,'P3'))
            obsdata.GALILEO.P3=rinexobs.GALobs.P3(:,time(1):time(2));
            obsdata.GALILEO.L3=rinexobs.GALobs.L3(:,time(1):time(2));
            obsdata.GALILEO.D3=rinexobs.GALobs.D3(:,time(1):time(2));
            obsdata.GALILEO.S3=rinexobs.GALobs.S3(:,time(1):time(2));
        end
    end
    
    if isfield(rinexobs,'Gloobs')
        if(isfield(rinexobs.Gloobs,'C1'))
            obsdata.GLONASS.C1=rinexobs.Gloobs.C1(:,time(1):time(2));
            obsdata.GLONASS.L1=rinexobs.Gloobs.L1(:,time(1):time(2));
            obsdata.GLONASS.D1=rinexobs.Gloobs.D1(:,time(1):time(2));
            obsdata.GLONASS.S1=rinexobs.Gloobs.S1(:,time(1):time(2));
        end

        if(isfield(rinexobs.Gloobs,'P2'))
            obsdata.GLONASS.P2=rinexobs.Gloobs.P2(:,time(1):time(2));
            obsdata.GLONASS.L2=rinexobs.Gloobs.L2(:,time(1):time(2));
            obsdata.GLONASS.D2=rinexobs.Gloobs.D2(:,time(1):time(2));
            obsdata.GLONASS.S2=rinexobs.Gloobs.S2(:,time(1):time(2));
        end

        if(isfield(rinexobs.Gloobs,'P3'))
            obsdata.GLONASS.P3=rinexobs.Gloobs.P3(:,time(1):time(2));
            obsdata.GLONASS.L3=rinexobs.Gloobs.L3(:,time(1):time(2));
            obsdata.GLONASS.D3=rinexobs.Gloobs.D3(:,time(1):time(2));
            obsdata.GLONASS.S3=rinexobs.Gloobs.S3(:,time(1):time(2));
        end

    end
    
    if isfield(rinexobs,'Qzssobs')
        if(isfield(rinexobs.Qzssobs,'C1'))
            obsdata.QZSS.C1=rinexobs.Qzssobs.C1(:,time(1):time(2));
            obsdata.QZSS.L1=rinexobs.Qzssobs.L1(:,time(1):time(2));
            obsdata.QZSS.D1=rinexobs.Qzssobs.D1(:,time(1):time(2));
            obsdata.QZSS.S1=rinexobs.Qzssobs.S1(:,time(1):time(2));
        end
        
        if(isfield(rinexobs.Qzssobs,'P2'))
            obsdata.QZSS.P2=rinexobs.Qzssobs.P2(:,time(1):time(2));
            obsdata.QZSS.L2=rinexobs.Qzssobs.L2(:,time(1):time(2));
            obsdata.QZSS.D2=rinexobs.Qzssobs.D2(:,time(1):time(2));
            obsdata.QZSS.S2=rinexobs.Qzssobs.S2(:,time(1):time(2));
        end

        if(isfield(rinexobs.Qzssobs,'P3'))
            obsdata.QZSS.P3=rinexobs.Qzssobs.P3(:,time(1):time(2));
            obsdata.QZSS.L3=rinexobs.Qzssobs.L3(:,time(1):time(2));
            obsdata.QZSS.D3=rinexobs.Qzssobs.D3(:,time(1):time(2));
            obsdata.QZSS.S3=rinexobs.Qzssobs.S3(:,time(1):time(2));
        end
    end
end
