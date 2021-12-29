port = serial('COM4','BaudRate',9600);
try
    set_speed(port,'x', 10);
    set_position(port, 'x', 50);
    start(port,1);
    A = check_arrive(port);
    fclose(port);
    delete(port);
catch
    delete(port);
end
delete(port);

