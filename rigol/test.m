DG952 = visa( 'ni','USB0::0x1AB1::0x0643::DG9A225000454::INSTR' ); %创建VISA对象
fopen(DG952); %打开已创建的VISA对象
fprintf(DG952, ':SOUR1:APPL:SIN 500,2.5,1,90' ); %发送请求
fprintf(DG952, ':OUTP2 ON' );
% query_CH1 = fscanf(DG952); %查询数据
fclose(DG952); %关闭VISA对象
display(query_CH1) %显示已读取的设备信息
