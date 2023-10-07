function Fidcsv=Writecsvfile(Csvre,signal_mask,signal2_mask)
    Fidcsv=-1;
    pathname = pwd;                                                        %获取当前工作路径
    pathcsv=fullfile(pathname,Csvre);
    Fidcsv=fopen(pathcsv,'wt');
    if(Fidcsv>0)
        disp('打开CSV数据保存文件成功');
    else
        disp('打开CVS保存数据文件失败');
        return
    end
    fretype=1;
    if (~all(signal_mask(:,3)==0)||~all(signal2_mask(:,3)==0))
        fretype=2;
    elseif (~all(signal_mask(:,4)==0)||~all(signal2_mask(:,4)==0))
        fretype=5;  
    end
    
    if fretype==1
        fprintf(Fidcsv,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s','PRN','SNR1','mean DDP1','std DDP1','DDP1_cep68','DDP1_cep95','mean DD L1','std DD L1','DDL1_cep68','DDL1_cep95',...
        'mean DD D1','std DD D1');
    elseif fretype==2
        fprintf(Fidcsv,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s','PRN','SNR1','mean DDP1','std DDP1','DDP1_cep68','DDP1_cep95','mean DD L1','std DD L1',...
        'DDL1_cep68','DDL1_cep95','mean DD D1','std DD D1','SNR2','mean DD P2','std DDP2','DDP2_cep68','DDP2_cep95','mean DD L2','std DD L2','DDL2_cep68','DDl2_cep95', 'mean DD D2','std DD D2');
    elseif fretype==5
         fprintf(Fidcsv,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s','PRN','SNR1','mean DDP1','std DDP1','DDP1_cep68','DDP1_cep95','mean DD L1','std DD L1',...
        'DDL1_cep68','DDL1_cep95','mean DD D1','std DD D1','SNR2','mean DD P5','std DDP5','DDP5_cep68','DDP5_cep95','mean DD L5','std DD L5','DDL5_cep68','DDl5_cep95', 'mean DD D5','std DD D5');
    end
end