t = linspace(0,31,32) /32
%t = linspace(0,1,32)
sen = floor((2^15-1)*sin(2*pi*t));
sen = sen + (sen < 0) * 65535;
sen_h=strcat('0x', dec2hex(sen), ',');
st = '{';
for n = 1 : 32
  st = [st, sen_h(n,:)];
endfor
st = [st(1:end-1), '}'];