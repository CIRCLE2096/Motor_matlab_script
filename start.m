function start(port,signal)
try
    fopen(port);
    station_num = '01';
    fun_write_M = '0F';

    address_start = ['00';'96'];
    address_num_1 = ['00';'01'];
    Byte_num_1 = '01';
    switch signal
        case 1
            signal = '01';
        case 0
            signal = '00';
    end
    Com_num =[station_num; fun_write_M; address_start; address_num_1; Byte_num_1;signal];
    Com_num = [Com_num; crc16_modbus(Com_num)];
    Com_num = hex2dec(Com_num);
    fwrite(port,Com_num);
catch e
    disp(e);
    fclose(port);
end
fclose(port);
end

