function plot_qzss(REFOBS,TSSOBS,signal_mask,fdcsvfile, refoutput, testoutput)

    global timesample;
    global ref_QZSS;
    
    signaltype=0;
    L1_freq = 1575.42*1000000;
    L2_freq = 1227.60*1000000;
    L5_freq = 1176.45*1000000;
    C_speed=299792458.0;
    
    lamda_1=C_speed/L1_freq;
    lamda_2=0;
    if isequal(signal_mask(1,:),[2,1,1,0])
        lamda_2=C_speed/L2_freq;
        signaltype=2;
        disp('QZSS: L1+L2')
    elseif isequal(signal_mask(1,:),[2,1,0,1])
        lamda_2=C_speed/L5_freq;
        signaltype=5;
        disp('QZSS: L1+L5')
    else
        disp('QZSS: L1')
    end
    
    if (isfield(REFOBS,'QZSS')&&isfield(TSSOBS,'QZSS'))                      %处理QZSS卫星数据

       SN1=mean(REFOBS.QZSS.S1,2,'omitnan');
       ind1=find(SN1>20);
       
       SN3=mean(REFOBS.QZSS.S2,2,'omitnan');
       ind3=find(SN3>20);
       
       ind4=intersect(ind1,ind3);
       
       SN2=mean(TSSOBS.QZSS.S1,2,'omitnan');
       ind2=find(SN2>20);
       ind=intersect(ind4,ind2);                                           %找出真正的共视星
       [~,indsv]=max(mean(REFOBS.QZSS.S1(ind,:),2));                        %在共视星选出参考星
       
       if ref_QZSS==0
           refsv=ind(indsv);
       else
           refsv=ref_QZSS;
       end
       
       disp('--------------------------------------------------------------------------------');
       disp(['选取QZSS系统',num2str(refsv),'号星作为参考卫星']);
       for j=1:length(ind)

           osv=ind(j);
           LengthS=length(REFOBS.QZSS.C1(osv,:));
           
           DiffPL1=nan(LengthS,1);
           DiffPL2=nan(LengthS,1);
           DDPL1=nan(LengthS-1,1);
           DDPL2=nan(LengthS-1,1);
           DiffL1=nan(LengthS-1,1);
           DiffL2=nan(LengthS-1,1);
           DDLD1=nan(LengthS-1,1);
           DDLD2=nan(LengthS-1,1);
           
           if(refoutput)
               disp('reference obs')
               if(isfield(REFOBS.QZSS,'C1') && isfield(REFOBS.QZSS,'L1'))   
                  DiffPL1=REFOBS.QZSS.C1(osv,:)-REFOBS.QZSS.L1(osv,:)*lamda_1;
                  for i=1:length(DiffPL1)-1
                      DDPL1(i)=DiffPL1(i+1)-DiffPL1(i);
                  end
               end

               if(isfield(REFOBS.QZSS,'P2') && isfield(REFOBS.QZSS,'L2'))
                  DiffPL2=REFOBS.QZSS.P2(osv,:)-REFOBS.QZSS.L2(osv,:)*lamda_2; 
                  for i=1:length(DiffPL2)-1
                      DDPL2(i)=DiffPL2(i+1)-DiffPL2(i);
                  end
               end

               if(isfield(REFOBS.QZSS,'L1') && isfield(REFOBS.QZSS,'D1'))
                   for i=1:length(REFOBS.QZSS.L1(osv,:))-1
                        DiffL1(i) = REFOBS.QZSS.L1(osv,i+1)-REFOBS.QZSS.L1(osv,i);
                   end
                   for i=1:length(DiffL1)
                        DDLD1(i)=DiffL1(i)/timesample + REFOBS.QZSS.D1(osv,i);
                   end  
               end

               if(isfield(REFOBS.QZSS,'L2') && isfield(REFOBS.QZSS,'D2'))
                   for i=1:length(REFOBS.QZSS.L2(osv,:))-1
                        DiffL2(i) = REFOBS.QZSS.L2(osv,i+1)-REFOBS.QZSS.L2(osv,i);
                   end
                   for i=1:length(DiffL2)
                        DDLD2(i)=DiffL2(i)/timesample+REFOBS.QZSS.D2(osv,i);
                   end
               end

                figure
                subplot(2,2,1)
                plot(DDPL1,'b')
                title(['J',num2str(osv),' DDPL1']);
                xlabel('epoch')
                ylabel('unit:m')
                grid on
                subplot(2,2,2)
                plot(DDLD1,'r')
                title(['J',num2str(osv),' DDLD1']);
                xlabel('epoch')
                ylabel('unit:HZ')
                grid on
                subplot(2,2,3)
                plot(DDPL2,'r')
                if signaltype==2
                    title(['J',num2str(osv),' DDPL2']);
                elseif(signaltype==5)
                    title(['J',num2str(osv),' DDPL5']);
                end
                xlabel('epoch')
                ylabel('unit:m')
                grid on

                subplot(2,2,4)
                plot(DDLD2,'b')
                if signaltype==2
                    title(['J',num2str(osv),'DDLD2']);
                elseif(signaltype==5)
                    title(['J',num2str(osv),'DDLD5']);
                end
                xlabel('epoch')
                ylabel('unit:HZ')
                grid on

              DDPL1(abs(DDPL1)>3)=nan;
              mean_ddpl1=mean(DDPL1,'omitnan');
              std_ddpl1=std(DDPL1,'omitnan');
              disp(['J',num2str(osv), ':Mean DDPL1=',num2str(mean_ddpl1,4),'m  ','Std DDPL1=',num2str(std_ddpl1,4),'m']);

              DDPL2(abs(DDPL2)>3)=nan;
              mean_ddpl2=mean(DDPL2,'omitnan');
              std_ddpl2=std(DDPL2,'omitnan');
              if signaltype==2
                   disp(['J',num2str(osv), ':Mean DDPL2=',num2str(mean_ddpl2,4),'m  ','Std DDPL2=',num2str(std_ddpl2,4),'m']);
              else 
                   disp(['J',num2str(osv), ':Mean DDPL5=',num2str(mean_ddpl2,4),'m  ','Std DDPL5=',num2str(std_ddpl2,4),'m']);
              end

              DDLD1(abs(DDLD1)>3)=nan;
              mean_ddld1=mean(DDLD1,'omitnan');
              std_ddld1=std(DDLD1,'omitnan');
              disp(['J',num2str(osv), ':Mean DDLD1=',num2str(mean_ddld1,4),'HZ  ','Std DDLD1=',num2str(std_ddld1,4),'HZ']);

              DDLD2(abs(DDLD2)>3)=nan;
              mean_ddld2=mean(DDLD2,'omitnan');
              std_ddld2=std(DDLD2,'omitnan');
              if signaltype==2
                   disp(['J',num2str(osv), ':Mean DDLD2=',num2str(mean_ddld2,4),'HZ  ','Std DDLD2=',num2str(std_ddld2,4),'HZ']);
              elseif(signaltype==5)
                    disp(['J',num2str(osv), ':Mean DDLD5=',num2str(mean_ddld2,4),'HZ  ','Std DDLD5=',num2str(std_ddld2,4),'HZ']);
              end
           end
              
           if(testoutput)
               disp('test obs:')
               if(isfield(TSSOBS.QZSS,'C1') && isfield(TSSOBS.QZSS,'L1'))
                  DiffPL1=TSSOBS.QZSS.C1(osv,:)-TSSOBS.QZSS.L1(osv,:)*lamda_1;
                  for i=1:length(DiffPL1)-1
                      DDPL1(i)=DiffPL1(i+1)-DiffPL1(i);
                  end
               end

               if(isfield(TSSOBS.QZSS,'P2') && isfield(TSSOBS.QZSS,'L2'))
                  DiffPL2=TSSOBS.QZSS.P2(osv,:)-TSSOBS.QZSS.L2(osv,:)*lamda_2; 
                  for i=1:length(DiffPL2)-1
                      DDPL2(i)=DiffPL2(i+1)-DiffPL2(i);
                  end
               end

               if(isfield(TSSOBS.QZSS,'L1') && isfield(TSSOBS.QZSS,'D1'))

                   for i=1:length(TSSOBS.QZSS.L1(osv,:))-1
                        DiffL1(i) = TSSOBS.QZSS.L1(osv,i+1)-TSSOBS.QZSS.L1(osv,i);
                   end

                   for i=1:length(DiffL1)
                        DDLD1(i)=DiffL1(i)/timesample + TSSOBS.QZSS.D1(osv,i);
                   end  
               end

               if(isfield(TSSOBS.QZSS,'L2') && isfield(TSSOBS.QZSS,'D2'))

                   for i=1:length(TSSOBS.QZSS.L2(osv,:))-1
                        DiffL2(i) = TSSOBS.QZSS.L2(osv,i+1)-TSSOBS.QZSS.L2(osv,i);
                   end

                   for i=1:length(DiffL2)
                        DDLD2(i)=DiffL2(i)/timesample+TSSOBS.QZSS.D2(osv,i);
                   end
               end

                figure
                subplot(2,2,1)
                plot(DDPL1,'b')
                title(['J',num2str(osv),' DDPL1']);
                xlabel('epoch')
                ylabel('unit:m')
                grid on
                subplot(2,2,2)
                plot(DDLD1,'r')
                title(['J',num2str(osv),' DDLD1']);
                xlabel('epoch')
                ylabel('unit:HZ')
                grid on
                subplot(2,2,3)
                plot(DDPL2,'r')
                if signaltype==2
                    title(['J',num2str(osv),' DDPL2']);
                elseif(signaltype==5)
                    title(['J',num2str(osv),' DDPL5']);
                end
                xlabel('epoch')
                ylabel('unit:m')
                grid on

                subplot(2,2,4)
                plot(DDLD2,'b')
                if signaltype==2
                    title(['J',num2str(osv),'DDLD2']);
                elseif(signaltype==5)
                    title(['J',num2str(osv),'DDLD5']);
                end
                xlabel('epoch')
                ylabel('unit:HZ')
                grid on

              DDPL1(abs(DDPL1)>3)=nan;
              mean_ddpl1=mean(DDPL1,'omitnan');
              std_ddpl1=std(DDPL1,'omitnan');
              disp(['J',num2str(osv), ':Mean DDPL1=',num2str(mean_ddpl1,4),'m  ','Std DDPL1=',num2str(std_ddpl1,4),'m']);

              DDPL2(abs(DDPL2)>3)=nan;
              mean_ddpl2=mean(DDPL2,'omitnan');
              std_ddpl2=std(DDPL2,'omitnan');
              if signaltype==2
                   disp(['J',num2str(osv), ':Mean DDPL2=',num2str(mean_ddpl2,4),'m  ','Std DDPL2=',num2str(std_ddpl2,4),'m']);
              else 
                   disp(['J',num2str(osv), ':Mean DDPL5=',num2str(mean_ddpl2,4),'m  ','Std DDPL5=',num2str(std_ddpl2,4),'m']);
              end

              DDLD1(abs(DDLD1)>3)=nan;
              mean_ddld1=mean(DDLD1,'omitnan');
              std_ddld1=std(DDLD1,'omitnan');
              disp(['J',num2str(osv), ':Mean DDLD1=',num2str(mean_ddld1,4),'HZ  ','Std DDLD1=',num2str(std_ddld1,4),'HZ']);

              DDLD2(abs(DDLD2)>3)=nan;
              mean_ddld2=mean(DDLD2,'omitnan');
              std_ddld2=std(DDLD2,'omitnan');
              if signaltype==2
                   disp(['J',num2str(osv), ':Mean DDLD2=',num2str(mean_ddld2,4),'HZ  ','Std DDLD2=',num2str(std_ddld2,4),'HZ']);
              elseif(signaltype==5)
                    disp(['J',num2str(osv), ':Mean DDLD5=',num2str(mean_ddld2,4),'HZ  ','Std DDLD5=',num2str(std_ddld2,4),'HZ']);
              end
           end
          
           if(refsv~=osv)
               
                detL1=nan(LengthS,1);
                detL2=nan(LengthS,1);
                detC1=nan(LengthS,1);
                detP2=nan(LengthS,1);
                detD1=nan(LengthS,1);
                detD2=nan(LengthS,1);
                meandetC1=nan;
                meandetL1=nan;
                meandetD1=nan;
                meandetP2=nan;
                meandetL2=nan;
                meandetD2=nan;
                stddetC1=nan;
                stddetL1=nan;
                stddetD1=nan;
                stddetP2=nan;
                stddetL2=nan;
                stddetD2=nan;
                
                if(isfield(TSSOBS.QZSS,'C1')&&isfield(REFOBS.QZSS,'C1'))
                    
                    NewMatC1=[TSSOBS.QZSS.C1(osv,:);REFOBS.QZSS.C1(refsv,:);REFOBS.QZSS.C1(osv,:);TSSOBS.QZSS.C1(refsv,:)];
                    detC1=DoubleDet(NewMatC1);
                    detC1(abs(detC1)>1000)=nan;
                    detC11=detC1(~isnan(detC1));
                    detC11(abs(detC11)>100)=0;
                    meandetC1=mean(detC11,'omitnan');
                    stddetC1=std(detC11,'omitnan');
                    
                    detC1_s=sort(abs(detC11));
                    C1_cep50=cep(detC1_s,0.50);
                    C1_cep68=cep(detC1_s,0.68);
                    C1_cep95=cep(detC1_s,0.95);
                    C1_cep99=cep(detC1_s,0.99);
                    C1_cep100=cep(detC1_s,1.0);
                    SNR1=mean(TSSOBS.QZSS.S1(osv,:),2,'omitnan');
                    disp(' ')
                    disp(['J',num2str(osv),'Avg_SNR1',num2str(SNR1,2),' DD_CA ','mean=',num2str(meandetC1,4), ' m ','std=',num2str(stddetC1,4),' m'])
                    disp(['J',num2str(osv),' DD_CA ','cep50=',num2str(C1_cep50,4),'cep68=',num2str(C1_cep68,4),'cep95=',num2str(C1_cep95,4),'cep99=',num2str(C1_cep99,4),'cep100=',num2str(C1_cep100,4)])
                    NewMatL1=[TSSOBS.QZSS.L1(osv,:);REFOBS.QZSS.L1(refsv,:);REFOBS.QZSS.L1(osv,:);TSSOBS.QZSS.L1(refsv,:)];
                    %[detL1,meandetL1,stddetL1]=ThreeDet(NewMatL1,1);
                    detL1=DoubleDet(NewMatL1);
                    detL1(abs(detL1)>1000)=nan;
                    detL12=detL1(~isnan(detL1));
                    detL12(abs(detL12)>100)=0;
                    detL11=detL12-round(detL12);
                    for ii=1:length(detL11)
                        if detL11(ii)>0.35
                            detL11(ii)=detL11(ii)-0.5;
                        elseif detL11(ii)<-0.35
                            detL11(ii)=detL11(ii)+0.5;
                        end
                    end
                    detL1_s=sort(abs(detL11));
                    L1_cep50=cep(detL1_s,0.50);
                    L1_cep68=cep(detL1_s,0.68);
                    L1_cep95=cep(detL1_s,0.95);
                    L1_cep99=cep(detL1_s,0.99);
                    L1_cep100=cep(detL1_s,1.0);
                    
                    meandetL1=mean(detL11,'omitnan');
                    stddetL1=std(detL11,'omitnan');
                    disp(['J',num2str(osv),' DD_L1 ','mean=',num2str(meandetL1,4), ' cycle ','std=',num2str(stddetL1,4),' cycle'])
                    disp(['J',num2str(osv),' DD_L1 ','cep50=',num2str(L1_cep50,4),'cep68=',num2str(L1_cep68,4),'cep95=',num2str(L1_cep95,4),'cep99=',num2str(L1_cep99,4),'cep100=',num2str(L1_cep100,4)])

                    NewMatD1=[TSSOBS.QZSS.D1(osv,:);REFOBS.QZSS.D1(refsv,:);REFOBS.QZSS.D1(osv,:);TSSOBS.QZSS.D1(refsv,:)];
                    detD1=DoubleDet(NewMatD1);
                    meandetD1=mean(detD1,'omitnan')*lamda_1;
                    stddetD1=std(detD1,'omitnan')*lamda_1;
                    disp(['J',num2str(osv),' DD_D1 ','mean=',num2str(meandetD1,4), ' m/s ','std=',num2str(stddetD1,4),' m/s']) 
                    fprintf(fdcsvfile,'\nG%02d,%.2f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,',osv,SNR1,meandetC1,stddetC1,C1_cep68,C1_cep95,meandetL1,stddetL1,L1_cep68,L1_cep95,meandetD1,stddetD1);
                end

                if(isfield(TSSOBS.QZSS,'P2')&& isfield(REFOBS.QZSS,'P2'))
                    NewMatP2=[TSSOBS.QZSS.P2(osv,:);REFOBS.QZSS.P2(refsv,:);REFOBS.QZSS.P2(osv,:);TSSOBS.QZSS.P2(refsv,:)];
                    detP2=DoubleDet(NewMatP2);
                    detP2(abs(detP2)>1000)=nan;
                    detP21=detP2(~isnan(detP2));
                    detP21(abs(detP21)>100)=0;
                    meandetP2=mean(detP21,'omitnan');
                    stddetP2=std(detP21,'omitnan');
                    
                    detP2_s=sort(abs(detP21));
                    P2_cep50=cep(detP2_s,0.50);
                    P2_cep68=cep(detP2_s,0.68);
                    P2_cep95=cep(detP2_s,0.95);
                    P2_cep99=cep(detP2_s,0.99);
                    P2_cep100=cep(detP2_s,1.0);
                    SNR2=mean(TSSOBS.QZSS.S2(osv,:),2,'omitnan');
                    
                    if signaltype==2
                        disp(['J',num2str(osv),' DD_P2 ','mean=',num2str(meandetP2,4), ' m ','std=',num2str(stddetP2,4),' m'])
                    elseif(signaltype==5)
                        disp(['J',num2str(osv),' DD_P5 ','mean=',num2str(meandetP2,4), ' m ','std=',num2str(stddetP2,4),' m'])
                    end
                    
                    disp(['J',num2str(osv),' DD_P2 ','cep50=',num2str(P2_cep50,4),'cep68=',num2str(P2_cep68,4),'cep95=',num2str(P2_cep95,4),'cep99=',num2str(P2_cep99,4),'cep100=',num2str(P2_cep100,4)])
                    NewMatL2=[TSSOBS.QZSS.L2(osv,:);REFOBS.QZSS.L2(refsv,:);REFOBS.QZSS.L2(osv,:);TSSOBS.QZSS.L2(refsv,:)];
                    detL2=DoubleDet(NewMatL2);
                    detL2(abs(detL2)>1000)=nan;
                    detL21=detL2(~isnan(detL2));
                    detL21(abs(detL21)>100)=0;
                        %[detL2,meandetL2,stddetL2]=ThreeDet(NewMatL2,2);
                    detL22=detL21-round(detL21);   
                    for ii=1:length(detL22)
                        if detL22(ii)>0.35
                            detL22(ii)=detL22(ii)-0.5;
                        elseif detL22(ii)<-0.35
                            detL22(ii)=detL22(ii)+0.5;
                        end
                    end
                    
                    meandetL2=mean(detL22,'omitnan');
                    stddetL2=std(detL22,'omitnan');
                    
                    detL2_s=sort(abs(detL22));
                    L2_cep50=cep(detL2_s,0.50);
                    L2_cep68=cep(detL2_s,0.68);
                    L2_cep95=cep(detL2_s,0.95);
                    L2_cep99=cep(detL2_s,0.99);
                    L2_cep100=cep(detL2_s,1.0);
                    if signaltype==2
                        disp(['J',num2str(osv),' DD_L2 ','mean=',num2str(meandetL2,4), ' cycle ','std=',num2str(stddetL2,4),' cycle'])
                    elseif(signaltype==5)
                        disp(['J',num2str(osv),' DD_L5 ','mean=',num2str(meandetL2,4), ' cycle ','std=',num2str(stddetL2,4),' cycle'])
                    end
                    disp(['J',num2str(osv),' DD_L2 ','cep50=',num2str(L2_cep50,4),'cep68=',num2str(L2_cep68,4),'cep95=',num2str(L2_cep95,4),'cep99=',num2str(L2_cep99,4),'cep100=',num2str(L2_cep100,4)])  
                    
                    NewMatD2=[TSSOBS.QZSS.D2(osv,:);REFOBS.QZSS.D2(refsv,:);REFOBS.QZSS.D2(osv,:);TSSOBS.QZSS.D2(refsv,:)];
                    detD2=DoubleDet(NewMatD2);
                    detD2(abs(detD2)>10000)=nan;
                    meandetD2=mean(detD2,'omitnan')*lamda_2;
                    stddetD2=std(detD2,'omitnan')*lamda_2;
                    if signaltype==2
                        disp(['J',num2str(osv),' DD_D2 ','mean=',num2str(meandetD2,4), ' m/s ','std=',num2str(stddetD2,4),' m/s'])
                    elseif(signaltype==5)
                        disp(['J',num2str(osv),' DD_D5 ','mean=',num2str(meandetD2,4), ' m/s ','std=',num2str(stddetD2,4),' m/s'])
                    end
                    
                    fprintf(fdcsvfile,'%.2f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,',SNR2,meandetP2,stddetP2, P2_cep68, P2_cep95,meandetL2,stddetL2,L2_cep68, L2_cep95,meandetD2,stddetD2);
                end

                figure
                subplot(2,3,1)
                plot(detC1,'b');
                title(['J',num2str(osv),' DD CA']);
                xlabel('epoch')
                ylabel('unit：m')
                grid on
                
                subplot(2,3,2)
                plot(detL1,'g');
                title(['J',num2str(osv),' DD L1']);
                grid on
                xlabel('epoch')
                ylabel('unit：circle')
                
                subplot(2,3,3)
                plot(detD1,'r');
                title(['G:',num2str(osv),' DD D1']);
                xlabel('epoch')
                ylabel('unit：HZ')
                grid on

                subplot(2,3,4)
                plot(detP2,'b');
                if signaltype==2
                    title(['J',num2str(osv),' DD P2']);
                elseif(signaltype==5)
                    title(['J',num2str(osv),' DD P5']);
                end
                xlabel('epoch')
                ylabel('unit：circle')
                grid on
                
                subplot(2,3,5)
                plot(detL2,'g');
                if signaltype==2
                    title(['J',num2str(osv),' DD L2']);
                elseif(signaltype==5)
                    title(['J',num2str(osv),' DD L5']);
                end
                xlabel('epoch')
                ylabel('unit：circle')
                grid on
                
                subplot(2,3,6)
                plot(detD2,'r');
                if signaltype==2
                    title(['J',num2str(osv),' DD D2']);
                elseif(signaltype==5)
                    title(['J',num2str(osv),' DD D5']);
                end
                grid on
                xlabel('epoch')
                ylabel('unit：HZ')
           end
       end
    end
end