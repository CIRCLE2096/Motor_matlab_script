function hex = hex_add_single(Com_num,singl)
%HEX_ADD_SINGLE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
positionHex = num2hex(single(singl));
positionHex = reshape(positionHex,2,[])';

hex = [Com_num; positionHex(3:4,:) ;positionHex(1:2,:) ];
end

