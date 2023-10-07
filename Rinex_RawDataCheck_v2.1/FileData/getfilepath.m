function filepath = getfilepath(instructstr)

    [filename,pathname]=uigetfile('*.*',instructstr);
    if isequal(filename,0)
        disp ('用户取消了打开文件')
        filepath='';
    else
        filepath=fullfile(pathname,filename);
        disp (['用户选择了文件',filepath])
    end
    
end