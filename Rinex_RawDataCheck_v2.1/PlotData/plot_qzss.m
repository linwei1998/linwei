function plot_qzss(OBS,fdcsvfile,signal_mask,range_mask,phase_mask,dcb_mask,noise_mask,pl_mask,mp_mask)

    signaltype=0;
    L1Freq = 1575.42*1000000;
    L2Freq = 1227.60*1000000;
    L5Freq = 1176.45*1000000;
    CLIGHT=299792458.0;
    
    lamda_1=CLIGHT/L1Freq;
    lamda_2=0;
    if isequal(signal_mask(5,:),[2,1,1,0])
        lamda_2=CLIGHT/L2Freq;
        aph=(L1Freq*L1Freq)/(L2Freq*L2Freq);
        signaltype=2;
        disp('QZSS: L1+L2')
    elseif isequal(signal_mask(5,:),[2,1,0,1])
        lamda_2=CLIGHT/L5Freq;
        aph=(L1Freq*L1Freq)/(L5Freq*L5Freq);
        signaltype=5;
        disp('QZSS: L1+L5')
    end
    
    if (isfield(OBS,'Qzssobs'))                                            %处理QZSS卫星数据
        
       SN=OBS.Qzssobs.S1;
       SN_mean=floor(mean(SN,2,'omitnan'));
       ind=find(SN_mean>0);

       for j=1:length(ind)
           
           osv=ind(j);
           LengthS=length(OBS.Qzssobs.C1(osv,:));
           P1=[];
           P2=[];
           L1=[];
           L2=[];
           D1=[];
           D2=[];
           S1=[];
           S2=[];

           mp1=nan(LengthS,1);
           mp2=nan(LengthS,1);
           DL1L2=nan(LengthS,1);
           std_mp1=nan;
           std_mp2=nan;
           dcb=nan(LengthS,1);
           
           diffP1=zeros(LengthS-1,1);
           diffP2=zeros(LengthS-1,1);
           ddiffP1=zeros(LengthS-2,1);
           ddiffP2=zeros(LengthS-2,1);
           dddiffP1=zeros(LengthS-3,1);
           dddiffP2=zeros(LengthS-3,1);
           ddddiffP1=zeros(LengthS-4,1);
           ddddiffP2=zeros(LengthS-4,1);
           
           diffL1=zeros(LengthS-1,1);
           diffL2=zeros(LengthS-1,1);
           ddiffL1=zeros(LengthS-2,1);
           ddiffL2=zeros(LengthS-2,1);
           dddiffL1=zeros(LengthS-3,1);
           dddiffL2=zeros(LengthS-3,1);
           
           diffD1=zeros(LengthS-1,1);
           diffD2=zeros(LengthS-1,1);
           ddiffD1=zeros(LengthS-2,1);
           ddiffD2=zeros(LengthS-2,1);
           dddiffD1=zeros(LengthS-3,1);
           dddiffD2=zeros(LengthS-3,1);
           
           P1_noise=nan;
           L1_noise=nan;
           D1_noise=nan;
           P2_noise=nan;
           L2_noise=nan;
           D2_noise=nan;
           
           DiffPL1=nan(LengthS,1);
           DiffPL2=nan(LengthS,1);
           DDPL1=nan(LengthS-1,1);
           DDPL2=nan(LengthS-1,1);
           DDL1L2=nan(LengthS-1,1);
           DDDL1L2=nan(LengthS-2,1);
           mean_ddpl1=nan;
           mean_ddpl2=nan;
           std_ddpl1=nan;
           std_ddpl2=nan;
           
           if(isfield(OBS.Qzssobs,'C1') && isfield(OBS.Qzssobs,'P2') )
               for i=1:length(OBS.Qzssobs.C1(osv,:))
                   if(~isnan(OBS.Qzssobs.C1(osv,i))&&~isnan(OBS.Qzssobs.P2(osv,i))&&(OBS.Qzssobs.C1(osv,i)~=0)&&(OBS.Qzssobs.P2(osv,i)~=0))
                      dcb(i)=OBS.Qzssobs.P2(osv,i)-OBS.Qzssobs.C1(osv,i);
                   end 
                   if(isfield(OBS.Qzssobs,'L1') && isfield(OBS.Qzssobs,'L2'))
                      if((OBS.Qzssobs.C1(osv,i)~=0)&&(OBS.Qzssobs.P2(osv,i)~=0)&&(OBS.Qzssobs.L1(osv,i)~=0)&&(OBS.Qzssobs.L2(osv,i)~=0)&&...
                          ~isnan(OBS.Qzssobs.C1(osv,i))&&~isnan(OBS.Qzssobs.P2(osv,i))&&~isnan(OBS.Qzssobs.L1(osv,i))&&~isnan(OBS.Qzssobs.L2(osv,i)))
                         mp1(i)=OBS.Qzssobs.C1(osv,i)-((1+aph)/(aph-1))*lamda_1*OBS.Qzssobs.L1(osv,i)+2.0/(aph-1)*lamda_2*OBS.Qzssobs.L2(osv,i);
                         mp2(i)=OBS.Qzssobs.P2(osv,i)-2.0*aph/(aph-1)*lamda_1*OBS.Qzssobs.L1(osv,i)+(1+aph)/(aph-1)*lamda_2*OBS.Qzssobs.L2(osv,i);
                         DL1L2(i)=OBS.Qzssobs.L1(osv,i)*lamda_1-lamda_2*OBS.Qzssobs.L2(osv,i);
                      end 
                   end
               end
           end
           
           if(isfield(OBS.Qzssobs,'C1'))
               
               len=0;
               P1=OBS.Qzssobs.C1(osv,:);
               P1((P1==0))=nan;
               S1=OBS.Qzssobs.S1(osv,:);
               S1(S1==0)=nan;
               
               if ~all(isnan(P1))
                   for i=1:length(P1)-1
                       if (isnan(P1(i))||isnan(P1(i+1)))
                           diffP1(i)=nan;
                       else
                           diffP1(i)=P1(i+1)-P1(i);
                       end
                   end

                   for i=1:length(diffP1)-1
                       if (isnan(diffP1(i))||isnan(diffP1(i+1)))
                           ddiffP1(i)=nan;
                       else
                           ddiffP1(i)=diffP1(i+1)-diffP1(i);
                       end
                   end

                   for i=1:length(ddiffP1)-1
                       if (isnan(ddiffP1(i))||isnan(ddiffP1(i+1)))
                           dddiffP1(i)=nan;
                       else
                           dddiffP1(i)=ddiffP1(i+1)-ddiffP1(i);
                           len=len+1;
                       end
                   end
%                    dddiffP1(abs(dddiffP1)>10000)=nan;
                   for i=1:length(dddiffP1)-1
                       if (isnan(dddiffP1(i))||isnan(dddiffP1(i+1)))
                           ddddiffP1(i)=nan;
                       else
                           ddddiffP1(i)=dddiffP1(i+1)-dddiffP1(i);
                           len=len+1;
                       end
                   end
                   
                   ddddiffP1(abs(ddddiffP1)>10000)=nan;
                       figure
                       plot(S1,'b')
                       title(['J',num2str(osv),' L1 CN0']);
                       grid on
                       xlabel('epoch')
                       ylabel('CN0:dBHZ')
%                    if noise_mask
                       figure
                       plot(ddddiffP1,'b.')
                       title(['J',num2str(osv),' L1 PR Qurd-Diff']);
                       grid on
                       xlabel('epoch')
                       ylabel('range:m')
%                    end
                   ddddiffP1((abs(ddddiffP1)>100))=nan;
                   if(~all(isnan(ddddiffP1)))
%                         P1_noise = sqrt(sum(dddiffP1.*dddiffP1,'omitnan')/(8*(len-1)));
                          P1_noise = sqrt(sum(ddddiffP1.*ddddiffP1,'omitnan'));
                   end
                   disp(['J',num2str(osv),' L1 pseudorange noise: ',num2str(P1_noise)]);
               end
           end
           
           if(isfield(OBS.Qzssobs,'L1'))
               
               len=0;
               L1=OBS.Qzssobs.L1(osv,:);
               L1((L1==0))=nan;
               
               if ~all(isnan(L1))
                   for i=1:length(L1)-1
                       if (isnan(L1(i))||isnan(L1(i+1)))
                           diffL1(i)=nan;
                       else
                           diffL1(i)=L1(i+1)-L1(i);
                       end
                   end

                   for i=1:length(diffL1)-1
                       if (isnan(diffL1(i))||isnan(diffL1(i+1)))
                           ddiffL1(i)=nan;
                       else
                           ddiffL1(i)=diffL1(i+1)-diffL1(i);
                       end
                   end

                   for i=1:length(ddiffL1)-1
                       if (isnan(ddiffL1(i))||isnan(ddiffL1(i+1)))
                           dddiffL1(i)=nan;
                       else
                           dddiffL1(i)=ddiffL1(i+1)-ddiffL1(i);
                           len=len+1;
                       end
                   end
                   dddiffL1(abs(dddiffL1)>10000)=nan;
                   if noise_mask
                       figure
                       plot(dddiffL1,'r+')
                       title(['J',num2str(osv),' L1 carrie phase accuracy']);
                       grid on
                       xlabel('epoch')
                       ylabel('range:cycle')
                   end
                   dddiffL1((abs(dddiffL1)>3))=nan;
                   if(~all(isnan(dddiffL1)))
                        L1_noise = sqrt(sum(dddiffL1.*dddiffL1,'omitnan')/(8*(len-1)));
                   end
                   disp(['J',num2str(osv),' L1 carrie phase noise: ',num2str(L1_noise)]);
               end
           end
           
            if(isfield(OBS.Qzssobs,'D1'))
               
               len=0;
               D1=OBS.Qzssobs.D1(osv,:);
               D1((D1==0))=nan;
               
               if ~all(isnan(L1))
                   for i=1:length(D1)-1
                       if (isnan(D1(i))||isnan(D1(i+1)))
                           diffD1(i)=nan;
                       else
                           diffD1(i)=D1(i+1)-D1(i);
                       end
                   end

                   for i=1:length(diffD1)-1
                       if (isnan(diffD1(i))||isnan(diffD1(i+1)))
                           ddiffD1(i)=nan;
                       else
                           ddiffD1(i)=diffD1(i+1)-diffD1(i);
                       end
                   end

                   for i=1:length(ddiffD1)-1
                       if (isnan(ddiffD1(i))||isnan(ddiffD1(i+1)))
                           dddiffD1(i)=nan;
                       else
                           dddiffD1(i)=ddiffD1(i+1)-ddiffD1(i);
                           len=len+1;
                       end
                   end

                   if noise_mask
                       figure
                       plot(dddiffD1,'y*')
                       title(['J',num2str(osv),' L1 doppler accuracy']);
                       grid on
                       xlabel('epoch')
                       ylabel('range:HZ')
                   end
                   dddiffD1((abs(dddiffD1)>10))=nan;
                   if(~all(isnan(dddiffD1)))
                        D1_noise = sqrt(sum(dddiffD1.*dddiffD1,'omitnan')/(8*(len-1)));
                   end
                   disp(['J',num2str(osv),' L1 doppler noise: ',num2str(D1_noise)]);
               end
           end
           
           if(isfield(OBS.Qzssobs,'P2'))
               
               len=0;
               P2=OBS.Qzssobs.P2(osv,:);
               P2((P2==0))=nan;
               S2=OBS.Qzssobs.S2(osv,:);
               S2(S2==0)=nan;
               
               if ~all(isnan(P2))
                   for i=1:length(P2)-1
                       if (isnan(P2(i))||isnan(P2(i+1)))
                           diffP2(i)=nan;
                       else
                           diffP2(i)=P2(i+1)-P2(i);
                       end
                   end

                   for i=1:length(diffP2)-1
                       if (isnan(diffP2(i))||isnan(diffP2(i+1)))
                           ddiffP2(i)=nan;
                       else
                           ddiffP2(i)=diffP2(i+1)-diffP2(i);
                       end
                   end

                   for i=1:length(ddiffP2)-1
                       if (isnan(ddiffP2(i))||isnan(ddiffP2(i+1)))
                           dddiffP2(i)=nan;
                       else
                           dddiffP2(i)=ddiffP2(i+1)-ddiffP2(i);
                           len=len+1;
                       end
                   end
%                    dddiffP2(abs(dddiffP2)>10000)=nan;
                   for i=1:length(dddiffP2)-1
                       if (isnan(dddiffP2(i))||isnan(dddiffP2(i+1)))
                           ddddiffP2(i)=nan;
                       else
                           ddddiffP2(i)=dddiffP2(i+1)-dddiffP2(i);
                           len=len+1;
                       end
                   end
                   
                   ddddiffP2(abs(ddddiffP2)>10000)=nan;
                   
                       figure
                       plot(S2,'r')
                       if signaltype==2
                           title(['J',num2str(osv),' L2 CN0']);
                       else
                           title(['J',num2str(osv),' L5 CN0']);
                       end
                       grid on
                       xlabel('epoch')
                       ylabel('CN0:dBHZ')
                   
%                    if noise_mask
                       figure
                       plot(ddddiffP2,'r.')
                       if signaltype==2
                           title(['J',num2str(osv),' L2 PR Qurd-Diff'])
                       else
                           title(['J',num2str(osv),' L2 PR Qurd-Diff'])
                       end
                       grid on
                       xlabel('epoch')
                       ylabel('range:m')
%                    end
                   ddddiffP2((abs(ddddiffP2)>100))=nan;
                   if(~all(isnan(ddddiffP2)))
%                         P2_noise = sqrt(sum(dddiffP2.*dddiffP2,'omitnan')/(8*len-8));
                        P2_noise = sqrt(sum(ddddiffP2.*ddddiffP2,'omitnan'));
                   end
                   if signaltype==2
                       disp(['J',num2str(osv),' L2 pseudorange noise: ',num2str(P2_noise)]);
                   else
                       disp(['J',num2str(osv),' L5 pseudorange noise: ',num2str(P2_noise)]); 
                   end
               end
           end
           
           if(isfield(OBS.Qzssobs,'L2'))
               
               len=0;
               L2=OBS.Qzssobs.L2(osv,:);
               L2((L2==0))=nan;
               
               if ~all(isnan(L2))
                   for i=1:length(L2)-1
                       if (isnan(L2(i))||isnan(L2(i+1)))
                           diffL2(i)=nan;
                       else
                           diffL2(i)=L2(i+1)-L2(i);
                       end
                   end

                   for i=1:length(diffL2)-1
                       if (isnan(diffL2(i))||isnan(diffL2(i+1)))
                           ddiffL2(i)=nan;
                       else
                           ddiffL2(i)=diffL2(i+1)-diffL2(i);
                       end
                   end

                   for i=1:length(ddiffL2)-1
                       if (isnan(ddiffL2(i))||isnan(ddiffL2(i+1)))
                           dddiffL2(i)=nan;
                       else
                           dddiffL2(i)=ddiffL2(i+1)-ddiffL2(i);
                           len=len+1;
                       end
                   end
                   dddiffL2(abs(dddiffL2)>10000)=nan;
                   if noise_mask
                       figure
                       plot(dddiffL2,'g+')
                       if signaltype==2
                           title(['J',num2str(osv),' L2 carrie phase accuracy']);
                       else
                           title(['J',num2str(osv),' L5 carrie phase accuracy']);
                       end
                       grid on
                       xlabel('epoch')
                       ylabel('range:cycle')
                   end
                   dddiffL2((abs(dddiffL2)>3))=nan;
                   if(~all(isnan(dddiffL2)))
                        L2_noise = sqrt(sum(dddiffL2.*dddiffL2,'omitnan')/(8*(len-1)));
                   end
                   if signaltype==2
                       disp(['J',num2str(osv),' L2 carrie phase noise: ',num2str(L2_noise)]);
                   else
                       disp(['J',num2str(osv),' L5 carrie phase noise: ',num2str(L2_noise)]);
                   end
               end
           end
           
           if(isfield(OBS.Qzssobs,'D2'))
               
               len=0;
               D2=OBS.Qzssobs.D2(osv,:);
               D2((D2==0))=nan;
               
               if ~all(isnan(D2))
                   for i=1:length(D2)-1
                       if (isnan(D2(i))||isnan(D2(i+1)))
                           diffD2(i)=nan;
                       else
                           diffD2(i)=D2(i+1)-D2(i);
                       end
                   end

                   for i=1:length(diffD2)-1
                       if (isnan(diffD2(i))||isnan(diffD2(i+1)))
                           ddiffD2(i)=nan;
                       else
                           ddiffD2(i)=diffD2(i+1)-diffD2(i);
                       end
                   end

                   for i=1:length(ddiffD2)-1
                       if (isnan(ddiffD2(i))||isnan(ddiffD2(i+1)))
                           dddiffD2(i)=nan;
                       else
                           dddiffD2(i)=ddiffD2(i+1)-ddiffD2(i);
                           len=len+1;
                       end
                   end

                   if noise_mask
                       figure
                       plot(dddiffD2,'y*')
                       if signaltype==2
                           title(['J',num2str(osv),' L2 doppler accuracy']);
                       else
                           title(['J',num2str(osv),' L5 doppler accuracy']);
                       end
                       grid on
                       xlabel('epoch')
                       ylabel('range:HZ')
                   end
                   dddiffD2((abs(dddiffD2)>10))=nan;
                   if(~all(isnan(dddiffD2)))
                        D2_noise = sqrt(sum(dddiffD2.*dddiffD2,'omitnan')/(8*(len-1)));
                   end
                   if signaltype==2
                       disp(['J',num2str(osv),' L2 doppler noise: ',num2str(D2_noise)]);
                   else
                       disp(['J',num2str(osv),' L5 doppler noise: ',num2str(D2_noise)]);
                   end
               end
           end
           
           if(isfield(OBS.Qzssobs,'C1') && isfield(OBS.Qzssobs,'L1'))
              DiffPL1=OBS.Qzssobs.C1(osv,:)-OBS.Qzssobs.L1(osv,:)*lamda_1;
              for i=1:length(OBS.Qzssobs.C1(osv,:))-1
                  DDPL1(i)=DiffPL1(i+1)-DiffPL1(i);
              end
              DDPL1(DDPL1==0)=nan;
              DDPL1(abs(DDPL1)>3)=nan;
              mean_ddpl1=mean(DDPL1,'omitnan');
              std_ddpl1=std(DDPL1,'omitnan');
              disp(['J',num2str(osv), ':Mean DDPL1=',num2str(mean_ddpl1),'m  ','Std DDPL1=',num2str(std_ddpl1),'m']);
           end
           
           if(isfield(OBS.Qzssobs,'P2') && isfield(OBS.Qzssobs,'L2'))
              DiffPL2=OBS.Qzssobs.P2(osv,:)-OBS.Qzssobs.L2(osv,:)*lamda_2; 
              DiffPL2(DiffPL2==0)=nan;
              for i=1:length(OBS.Qzssobs.P2(osv,:))-1
                  DDPL2(i)=DiffPL2(i+1)-DiffPL2(i);
              end
              DDPL2(DDPL2==0)=nan;
              DDPL2(abs(DDPL2)>3)=nan;
              mean_ddpl2=mean(DDPL2,'omitnan');
              std_ddpl2=std(DDPL2,'omitnan');
              if signaltype==2
                   disp(['J',num2str(osv), ':Mean DDPL2=',num2str(mean_ddpl2),'m  ','Std DDPL2=',num2str(std_ddpl2),'m']);
              else 
                   disp(['J',num2str(osv), ':Mean DDPL5=',num2str(mean_ddpl2),'m  ','Std DDPL5=',num2str(std_ddpl2),'m']);
              end
           end
           
           if ~all(isnan(DL1L2))
                  for i=1:LengthS-1
                        DDL1L2(i)=DL1L2(i+1)-DL1L2(i);
                  end
                  
                  for i=1:LengthS-2
                        DDDL1L2(i)=DDL1L2(i+1)-DDL1L2(i);
                  end
                  
                  if ~all(isnan(DDDL1L2))
                       figure
                       plot(DDDL1L2,'b.')
                       grid on
                       xlabel('epoch')
                       ylabel('range：m')
                       if signaltype==2
%                         xlim([0,3500])
%                        ylim([-0.05,0.05])
                           title(['J',num2str(osv),' DDGF L1L2']);
                       else
                           title(['J',num2str(osv),' DDGF L1L5']);
                       end
                  end
            end
           
           if range_mask
               figure
               plot(P1,'b*')
               title(['J',num2str(osv),' Pseudo range']);
               grid on
               xlabel('epoch')
               ylabel('range：m')
               hold on
               plot(P2,'m+'),
               if signaltype==2
                   legend({'L1 C/A','L2C'})
               else 
                   legend({'L1 C/A','L5'})
               end
               
               figure
               plot(diffP1,'b*')
               title(['J',num2str(osv),' Pseudo range diff']);
               grid on
               xlabel('epoch')
               ylabel('range:m')
               hold on
               plot(diffP2,'k+')
               if signaltype==2
                   legend({'L1 C/A','L2C'})
               else 
                   legend({'L1 C/A','L5'})
               end
           end
           
           if phase_mask
               figure
               plot(L1,'b*')
               title(['J',num2str(osv),' Carrier phase']);
               grid on
               xlabel('epoch')
               ylabel('range:m')
               hold on
               plot(L2,'m+'),
               if signaltype==2
                   legend({'L1 C/A','L2C'})
               else 
                   legend({'L1 C/A','L5'})
               end
           end
           
           if (pl_mask && ~isempty(DDPL1))
               figure
               plot(DDPL1,'b.')
               title(['J',num2str(osv),' code - phase']);
               grid on
               xlabel('epoch')
               ylabel('unit:m')
               if~isempty(DDPL2)
                   hold on
                   plot(DDPL2,'r.')
               end
               if signaltype==2
                   legend({'DDPL1','DDPL2'})
               else 
                   legend({'DDPL1','DDPL5'})
               end
           end
           
           if (dcb_mask && ~all(isnan(dcb)))
               figure
               plot(dcb)
               title(['J',num2str(osv),' difference code bias']);
               grid on
               xlabel('epoch')
               ylabel('unit:m')
           end
           
           if (~all(isnan(mp1)) && ~all(isnan(mp2)))

                B=0.0;
                n=0;
                m=1;
                for i=1:length(mp1)
                    if isnan(mp1(i))
                        continue
                    end
                    if(abs(mp1(i)-B)>5.0)  
                        for k=m:i-1
                           mp1(k)= mp1(k)-B;
                        end
                        n=0;m=i;B=0.0;    
                    end
                    if(mp1(i)~=0)
                        n=n+1;
                        B=B+(mp1(i)-B)/n;  
                    end
                end

                for k=m:length(mp1)
                    if(~isnan(mp1(k)))
                        mp1(k)= mp1(k)-B;
                    end
                end
                
                B=0.0;
                n=0;
                m=1;
                for i=1:length(mp2)
                    if isnan(mp2(i))
                        continue
                    end
                    if(abs(mp2(i)-B)>5.0)  
                        for k=m:i-1
                           mp2(k)= mp2(k)-B;
                        end
                        n=0;m=i;B=0.0;    
                    end
                    n=n+1;
                    B=B+(mp2(i)-B)/n;   
                end

                for k=m:length(mp2)
                    if(~isnan(mp2(k)))
                        mp2(k)= mp2(k)-B;
                    end
                end
               
               std_mp1=std(mp1,'omitnan');
               std_mp2=std(mp2,'omitnan');
               
               if signaltype==2
                   disp(['J',num2str(osv), ':MP12=',num2str(std_mp1),'m  ','MP21=',num2str(std_mp2),'m']);
               else 
                   disp(['J',num2str(osv), ':MP15=',num2str(std_mp1),'m  ','MP51=',num2str(std_mp2),'m']);
               end
               
               if( mp_mask && ~all(isnan(mp1)) && ~all(isnan(mp2)))
                   figure
                   plot(mp1,'b.')
                   title(['J',num2str(osv),' multipath']);
                   grid on
                   xlabel('epoch')
                   ylabel('range:m')
                   hold on
                   plot(mp2,'r.')
                   if signaltype==2
                       legend({'MP12','MP21'})
                   else 
                       legend({'MP15','MP51'})
                   end
               end
           end
           
           fprintf(fdcsvfile,'\nJ%02d,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.4f,%.4f,%.3f,%.3f',...
               osv,P1_noise,L1_noise,D1_noise,P2_noise,L2_noise,D2_noise,std_mp1,std_mp2,std_ddpl1,std_ddpl2);
       end
    else
        disp('NO QZSS observation!');
    end
end