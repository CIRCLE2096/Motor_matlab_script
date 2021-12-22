function Scan_Motor
%SCAN_MOTOR 此处显示有关此函数的摘要
%   此处显示详细说明
persistent x;
persistent port;
if isempty(port)
   port = serial('COM3','BaudRate',9600);
   fopen(port);
end
if isempty(x)
   x=0;
   set_speed(port,'x', 10);
end
set_position(port, 'x', x);
start(port,1);
while 1 ~= check_arrive(port)
end
if x<50
    x = x+5;
else
    fclose(port);
    delete(port);
    clear port
end

end

