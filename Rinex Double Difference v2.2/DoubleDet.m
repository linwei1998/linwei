%************************��ȡ������ͬ�۲�ʱ�ε�����rinex3.0x��ʽ�ļ������۲�����������***************************%
%************************ʱ�䣺2020.03**********************************************************************%
%************************���ߣ��з���������ʦ******************************************************************%
%�������ã���ͬһ�۲�ʱ�̵Ĳο��ǣ������ǹ����ĸ��۲��������������������ֻҪ��һ��Ϊ��ʱ��Ϊnan���� ������㣻

function [detdata]=DoubleDet(matdata)

     detdata=[];
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
     
     %˫���ʽ
     Cplas1=matmid(1,:)+matmid(2,:);
     Cplas2=matmid(3,:)+matmid(4,:);
     detdata=Cplas1-Cplas2;
end
