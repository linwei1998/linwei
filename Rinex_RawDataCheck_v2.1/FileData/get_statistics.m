function result = get_statistics(csvfile)

    result=zeros(5,6);
    
    G_noise=nan(32,1);
    C_noise=nan(64,1);
    E_noise=nan(36,1);
    R_noise=nan(36,1);
    J_noise=nan(10,1);
    
    if isempty(csvfile)
        disp('can not find excel file')
        return
    end

    Fidcsv=-1;
    pathname = pwd;                                                        %获取当前工作路径
    pathcsv=fullfile(pathname,csvfile);
    Fidcsv=fopen(pathcsv,'r');
    if(Fidcsv>0)
        disp('open CSV noise file success');
    else
        disp('open CVS noise file fail');
        return
    end
    
    while ~feof(Fidcsv)

        dat_lines='';
        dat_lines=fgetl(Fidcsv);

        if strcmp(dat_lines,'')
            continue
        end
        
        if contains(dat_lines,'PRN,L1 PR noise,L1 CP noise,L1 doppler noise,L2 PR noise,L2 CP noise,L2 doppler noise')
            disp('find noise file header')
            continue
        end
        
        strs=regexp(dat_lines,'\,','split');
        sys=strs{1}(1);
        prn=str2num(strs{1}(2:3));
        
        switch sys
            case 'G'
                G_noise(prn,1)=str2double(strs{2});
                G_noise(prn,2)=str2double(strs{3});
                G_noise(prn,3)=str2double(strs{4});
                G_noise(prn,4)=str2double(strs{5});
                G_noise(prn,5)=str2double(strs{6});
                G_noise(prn,6)=str2double(strs{7});
            case 'C'
                C_noise(prn,1)=str2double(strs{2});
                C_noise(prn,2)=str2double(strs{3});
                C_noise(prn,3)=str2double(strs{4});
                C_noise(prn,4)=str2double(strs{5});
                C_noise(prn,5)=str2double(strs{6});
                C_noise(prn,6)=str2double(strs{7});
            case 'E'
                E_noise(prn,1)=str2double(strs{2});
                E_noise(prn,2)=str2double(strs{3});
                E_noise(prn,3)=str2double(strs{4});
                E_noise(prn,4)=str2double(strs{5});
                E_noise(prn,5)=str2double(strs{6});
                E_noise(prn,6)=str2double(strs{7});
            case 'R'
                R_noise(prn,1)=str2double(strs{2});
                R_noise(prn,2)=str2double(strs{3});
                R_noise(prn,3)=str2double(strs{4});
                R_noise(prn,4)=str2double(strs{5});
                R_noise(prn,5)=str2double(strs{6});
                R_noise(prn,6)=str2double(strs{7});
            case 'J'
                J_noise(prn,1)=str2double(strs{2});
                J_noise(prn,2)=str2double(strs{3});
                J_noise(prn,3)=str2double(strs{4});
                J_noise(prn,4)=str2double(strs{5});
                J_noise(prn,5)=str2double(strs{6});
                J_noise(prn,6)=str2double(strs{7});
            otherwise
                continue 
        end
    end
    
    if ~isempty(G_noise)
       G_noise(G_noise==0)=nan;
       result(1,:)=roundn(mean(G_noise,1,'omitnan'),-4);  
    end
    
    if ~isempty(C_noise)
       C_noise(C_noise==0)=nan;
       result(2,:)=roundn(mean(C_noise,1,'omitnan'),-4);  
    end
    
    if ~isempty(E_noise)
       E_noise(E_noise==0)=nan;
       result(3,:)=roundn(mean(E_noise,1,'omitnan'),-4);  
    end

    if ~isempty(R_noise)
       R_noise(R_noise==0)=nan;
       result(4,:)=roundn(mean(R_noise,1,'omitnan'),-4);  
    end
    
    if ~isempty(J_noise)
       J_noise(J_noise==0)=nan;
       result(5,:)=roundn(mean(J_noise,1,'omitnan'),-4);  
    end 
end