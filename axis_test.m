port = serial('COM3','BaudRate',9600);
try
    set_speed(port,'x', 10);
    set_speed(port,'y',10);
    set_speed(port,'z',10);
    set_speed(port,'u',10);
    set_position(port, 'x', 100);
    set_position(port, 'y', 10);
    set_position(port, 'z', 50);
    set_position(port, 'u', 30);
    start(port,1);
    start(port,0);
    A = check_arrive(port);
    fclose(port);
    delete(port);
catch
    delete(port);
end
delete(port);