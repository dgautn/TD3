%% <------- Guia 6 - Ejercicio 1.1 ----------->

clc; % borra la consola
clear all; % borra todas las variables
close all; % cierra las ventanas de imagen

% especificaciones:
fs = 39062.5; % [Hz] frecuencia de muestreo
fc1_hz = 2800; % [Hz] \__ banda e transicion
fc2_hz = 3200; % [Hz] /
% Sba = 45; % [dB] (min) -45 [dB]

% se elige la ventana Hamming - Amplitud del pico mayor: -53 dB

fc1 = 2 * fc1_hz / fs; % \__ se convierte a frecuencias digitales
fc2 = 2 * fc2_hz / fs; % /

B = 0.035; % Este valor es arbitrario, no hay especificacion

% ^                B          B
% |H(f)         |<--->|    |<--->|
% |-------------.     |    |     .--------------
% |             |\    |    |    /|
% |             | \   |    |   / |
% |             |  \  |    |  /  |
% |             |  |\ |    | /|  |
% |             |  | '------' |  |
% |             |  |          |  |
% +-------------+--+----------+--+--------------->
%             fc1  |          |  fc2             f
%                 ft_pb  |  ft_pa
%    Fpb                 |                   Fpa
%  <---------------------+---------------------->

ft_pb = fc1 + B/2; % frec transicion del pasa bajos
ft_pa = fc2 - B/2; % frec transicion del pasa altos

n_fft = 4000; % muestras para el fft
pn_fft = n_fft/2; % muestras para el fft
frec = (0 : fs/n_fft : ((fs/2)-(fs/n_fft)) ) / 1000; % vector con los valores de frecuencia en kHZ

%M = ceil(8/B); % cantidad de taps para ventana Hamming -> Ancho de lobulo principal = 8/M

%M = 2*floor(M/2)+1; % convierte M al impar mayor o igual. floor(x) redondea al entero <= x
% asegura una cantidad impar de coeficientes para que el retardo D resulte en un número entero
M = 399;
n = (0 : (M-1)); % elementos de los vectores h_sinc

%% pasa bajos
h_sinc = ft_pb * sinc (ft_pb * (n - ((M-1)/2))); % funcion sinc del filtro pasa bajos
h_pb = h_sinc .* (hamming (M))'; % enventanado - se multiplica elemento a elemento

%% pasa altos
h_sinc = ft_pa * sinc (ft_pa * (n - ((M-1)/2))); % funcion sinc del filtro pasa bajos para convertir
h_pa = h_sinc .* (hamming (M))'; % enventanado - se multiplica elemento a elemento
d = zeros(1,M); % vector para retardo
d ((M+1) / 2) = 1; % El retardo es un impulso desplazado ( un unico 1 en el centro del vector) pasa todo
h_pa = d - h_pa; % el filtro pasa alto es el retardo menos el pasa bajos

%% elimina banda
h_eb = h_pb - h_pa; % se restan el pasa bajos y el pasa altos (en el apunte dice que se suman)

H_eb = fft(h_eb,n_fft);  % calcula la FFT con n_fft puntos de frecuencia, completa con ceros
Hdb_eb = mag2db( abs( H_eb(1:pn_fft) ) ); % convierte a dB el valor absoluto de las muestras de f positiva

%% con punto fijo
h_eb_fx = fi(h_eb, 1, 16, 15); % con punto fijo S16.15
h_eb_fix = h_eb_fx.double;
H_eb_fix = fft(h_eb_fix,n_fft);  % calcula la FFT con coeficientes en punto fijo
Hdb_eb_fix = mag2db( abs( H_eb_fix(1:pn_fft) ) ); % convierte a dB

%% Vector ed coeficientes
str = '{';
for n = 1 : M
    fix_i = h_eb_fx(n);
    str = [str, '0x', fix_i.hex, ','];
end
str = [str(1:end-1), '}'];
disp(str);

%% Grafica
figure('name','Guia 6 ejercicio 1.1','Units','normalized','Position',[0 0 1 1]); % pantalla completa
plot (frec, Hdb_eb, 'c', 'linewidth', 4); % grafica la respuesta en frecuencia
hold on;
plot (frec, Hdb_eb_fix, 'r--', 'linewidth', 1.2); % grafica la respuesta en frecuencia con punto fijo
legend ({'Sin cuantizar', 'Cuantizado S16.15'});
axis([2 4 -60 10]); % limites de los ejes
grid on;
grid minor;
xlabel ('Frecuencia [kHz]'); % etiqueta eje X
ylabel ('G [dB]');  % etiqueta eje y
title ('Filtro elimina banda con f_{c1}= 2800Hz  ,  f_{c2}= 3200Hz  ,  f_s= 39062,5Hz  ,  ventana Hamming'); % titulo

