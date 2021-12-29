port = serial('COM4','BaudRate',9600);
try
    set_speed(port,'x', 10);
    set_position(port, 'x', 50);
    set_position(port, 'y', 0);
    set_position(port, 'z', 0);
    start(port,1);
    start(port,0);
    A = check_arrive(port);
    delete(port);
catch
    delete(port);
end
delete(port);

