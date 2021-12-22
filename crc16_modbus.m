function crc = crc16_modbus(frame)
%%
% frame由Slave Adress. Function Code以及Data组成，格式为[xx;xx;xx;...]，
% xx由十六进制表示，含2个字节。
% 输出格式: crc = [CRC Lo; CRC Hi], [xx; xx]。
%%初始化
frame_dec = hex2dec(frame);
frame_bin = dec2bin(frame_dec, 16); % 将十六进制转变为二进制
initial_crc = uint8(ones(1, 16)); % CRC初始值0xFFFF
op_crc = uint8([1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 1]);% 0xA001，用于异或运算
%% 利用for循环计算二进制表示的CRC
[n, ~] = size(frame);
for i = 1:n
    frame_bin_element = frame_bin(i, :);
    frame_bin_element =  frame_bin_element';
    frame_bin_element_dec = bin2dec(frame_bin_element);
    frame_bin_element_dec = frame_bin_element_dec';
    frame_crc =  uint8(frame_bin_element_dec);
    if i == 1
        crc = bitxor(initial_crc, frame_crc);
    else
        crc = bitxor (crc, frame_crc);
    end
    LSB = crc(16);
    for j = 1:8
        crc = [uint8(0), crc(1:15)];
        if LSB == 1
            crc = bitxor(crc, op_crc);
        end
        LSB = crc(16);
    end
end
%% 将二进制CRC转变为十六进制
crc_bin = dec2bin(crc);
crc_dec = bin2dec(crc_bin');
crc = dec2hex(crc_dec , 4);
crc = [crc(3:4);crc(1:2)]; % [CRC Lo; CRC Hi]
end

