function Scan_Motor
%SCAN_MOTOR 此处显示有关此函数的摘要
%   此处显示详细说明
persistent x;
if isempty(x)
   x=0;
end

port = serial('COM3','BaudRate',9600);
set_speed(port,'x', 10);
set_position(port, 'x', x);
set_position(port, 'y', 0);
set_position(port, 'z', 0);
start(port,1);
start(port,0);
while 1 ~= check_arrive(port)
end
if x<50
    x = x+5;
else
    delete(port);
    clear port;
end

end

