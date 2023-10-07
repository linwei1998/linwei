%************************读取具有相同观测时段的两组rinex3.0x格式文件，做观测量精度评估***************************%
%************************时间：2020.03**********************************************************************%
%************************作者：研发二部工程师******************************************************************%
%函数作用：将同一观测时刻的参考星，其他星共计四个观测量组成列向量；当其中只要有一个为零时置为nan向量 方便计算；

function [thdetdata]=ThreeDet(matdata)

     detdata=[];
     thdetdata=[];
     if (isempty(matdata))
         return
     end
     
     [m,n]=size(matdata);
     if(m~=4)
         return
     end
     
     matmid=nan(m,n);
     nanvar=[nan nan nan nan]';
     k=1;
     
     for i=1:n
         if(length(find(matdata(:,i)~=0))==m)
           matmid(:,k)=matdata(:,i);
           k=k+1;
         else
           matmid(:,k)=nanvar;
           k=k+1;
         end
     end
     
     if isempty(matmid)
         return
     end
     
      %三差变式
     Cplas1=matmid(1,:)+matmid(2,:);
     Cplas2=matmid(3,:)+matmid(4,:);
     detdata=Cplas1-Cplas2;

     for j=1:length(detdata)-1
         thdetdata(j)=detdata(j+1)-detdata(j);
     end   

end