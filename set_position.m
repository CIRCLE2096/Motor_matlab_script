function set_position(port, axis, position)
station_num = '01';
fun_write_D = '10';
switch axis
    case 'x'
        address_position = ['06';'40'];
    case 'y'
        address_position = ['06';'44'];
    case 'z'
        address_position = ['06';'48'];
end
address_num_2 = ['00';'02'];
Byte_num_4 = '04';

Com_num =[station_num; fun_write_D; address_position; address_num_2; Byte_num_4];
Com_num = hex_add_single(Com_num,single(position));
crc = crc16_modbus(Com_num);
Com_num = [Com_num; crc];
disp(Com_num);
disp('*******');
Com_num = hex2dec(Com_num);
fwrite(port,Com_num);
end

