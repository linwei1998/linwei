function Fidcsv = Writecsvfile(Csvre,signal_mask)

    Fidcsv=-1;
    pathname = pwd;                                                        %获取当前工作路径
    pathcsv=fullfile(pathname,Csvre);
    Fidcsv=fopen(pathcsv,'wt');
    if(Fidcsv>0)
        disp('open CSV OK');
    else
        disp('open CVS ERROR');
        return
    end
     %202309200W add add DDGF&QD
    if (isequal(signal_mask(1,:),[2,1,1,0])||isequal(signal_mask(2,:),[2,1,1,0])||isequal(signal_mask(3,:),[2,1,1,0])||isequal(signal_mask(5,:),[2,1,1,0]))
        fprintf(Fidcsv,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s','PRN','L1 PR noise','L1 CP noise','L1 doppler noise','L2 PR noise','L2 CP noise','L2 doppler noise','MP12','MP21','DDPL1','DDPL2','DDGFL1L2','QDP1','QDP2');
    elseif (isequal(signal_mask(1,:),[2,1,0,1])||isequal(signal_mask(2,:),[2,1,0,1])||isequal(signal_mask(3,:),[2,1,0,1])||isequal(signal_mask(5,:),[2,1,0,1]))
        fprintf(Fidcsv,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s','PRN','L1 PR noise','L1 CP noise','L1 doppler noise','L5 PR noise','L5 CP noise','L5 doppler noise','MP15','MP51','DDPL1','DDPL5','DDGFL1L5','QDP1','QDP5');
    end
     %202309200W add DDGF&QD
    
end