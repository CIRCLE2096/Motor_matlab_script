clear all
sr3 = serial('COM4','BaudRate',9600); % 使用默认设置创建串�?� sr3
fopen(sr3); %打开串�?�
%读�?�到�?信�?�
Com_num =['01';'01'; '00'; '64'; '00'; '01'; 'BC'; '15']%加了 CRC 校验的命令�?列。
Com_num = hex2dec(Com_num);
fwrite(sr3,Com_num);%串�?��?��?
Read_num= fread(sr3,6);
Read_num= dec2hex(Read_num)%'01 03 00 F2 00 02 65 F8'
Com_num =['01';'03'; '00'; 'F2'; '00'; '02'; '65'; 'F8'];%加了 CRC 校验的命令�?列。
Com_num = hex2dec(Com_num);
fwrite(sr3,Com_num);%串�?��?��?
Read_num= fread(sr3,6);%读�?�串�?�
Read_num= dec2hex(Read_num)%得到 01 03 04 00 00 00 00 FA 33 ，解�?出�?��?置为 0。
%设定 X 轴速度为  '01 10 06 42 00 02 04 00 00 41 20 6C 6E'
Com_num =['01';'10'; '06'; '42'; '00'; '02'; '04'; '00'; '00'; '41'; '20'; '6C'; '6E'];%加了 CRC 校验的命
Com_num = hex2dec(Com_num);
fwrite(sr3,Com_num);%串�?��?��?
%设定 X 轴�?置为 2mm:  '01 10 06 40 00 02 04 00 00 40 00 ED FF'
Com_num =['01';'10'; '06'; '40'; '00'; '02'; '04'; '00'; '00'; '40'; '00'; 'ED'; 'FF'];%加了 CRC 校验的命
Com_num = hex2dec(Com_num);
fwrite(sr3,Com_num);%串�?��?��?
%写入�?�动按钮，  01 0F 00 96 00 01 01 01 A7 A4
Com_num =['01';'0F'; '00'; '96'; '00'; '01'; '01'; '01'; 'A7'; '4A'];%加了 CRC 校验的命令�?列。
Com_num = hex2dec(Com_num);
fwrite(sr3,Com_num);%串�?��?��?
%关闭�?�动按钮，
Com_num =['01';'0F'; '00'; '96'; '00'; '01'; '01'; '00'; '66'; '8A'];%加了 CRC 校验的命令�?列。
Com_num = hex2dec(Com_num);
fwrite(sr3,Com_num);%串�?��?��?
fclose(sr3); %关闭串�?�
delete(sr3);