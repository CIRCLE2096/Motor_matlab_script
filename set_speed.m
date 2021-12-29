function set_speed(port, axis, speed)
try
    fopen(port);
    station_num = '01';
    fun_write_D = '10';
    switch axis
        case 'x'
            address_position = ['06';'42'];
        case 'y'
            address_position = ['06';'46'];
        case 'z'
            address_position = ['06';'4A'];
    end
    address_num_2 = ['00';'02'];
    Byte_num_4 = '04';

    Com_num =[station_num; fun_write_D; address_position; address_num_2; Byte_num_4];
    Com_num = hex_add_single(Com_num,speed);
    crc = crc16_modbus(Com_num);
    Com_num = [Com_num; crc];
    Com_num = hex2dec(Com_num);
    fwrite(port,Com_num);
catch e
    disp(e);
    fclose(port);
end
fclose(port);
end

