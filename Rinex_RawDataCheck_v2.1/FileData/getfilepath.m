function filepath = getfilepath(instructstr)

    [filename,pathname]=uigetfile('*.*',instructstr);
    if isequal(filename,0)
        disp ('�û�ȡ���˴��ļ�')
        filepath='';
    else
        filepath=fullfile(pathname,filename);
        disp (['�û�ѡ�����ļ�',filepath])
    end
    
end