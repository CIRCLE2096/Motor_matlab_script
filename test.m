port = serial('COM3','BaudRate',9600);
fopen(port);
set_speed(port,'x', 10);
set_position(port, 'x', 2);
start(port,1);
fclose(port);
delete(port);