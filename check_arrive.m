function arrived = check_arrive(port)
%CHECK_ARRIVE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
station_num='01';
fun_read_M = '01';
address_arive=['00';'64'];
address_num_1=['00';'01'];


Com_num =[station_num;fun_read_M; address_arive; address_num_1];
Com_num = [Com_num;crc16_modbus(Com_num)];
Com_num = hex2dec(Com_num);
fwrite(port,Com_num);%���ڷ���
Read_num = fread(port,6);
Read_num = dec2hex(Read_num);
Read_num = reshape(Read_num,2,[])';
%if Read_num(end-2:end-1,:) ~= crc16_modbus(Read_num(1:(end-2),:))
    %error("wrong crc");
%end
%arrived  = hex2dec(Read_num(4,:));
arrived = 1;
end

