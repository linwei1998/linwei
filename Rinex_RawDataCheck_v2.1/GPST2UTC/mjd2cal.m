function cal=mjd2cal(mjd)
% mjd2cal	����������ת��������������ʱ���롣
%  cal=mjd2cal(mjd)  ���ص�cal��1x6����6�зֱ�Ϊ������ʱ����
%  mjd����������

jd=mjd+2400000.5;
cal=jd2cal(jd);
