% <------- Guia 4 - Ejercicio 3 ----------->

clc; % borra la consola
clear all; % borra todas las variables
close all; % cierra las ventanas de imagen
pkg load control; % paquete con 'mag2db'
pkg load signal; % ventanas


%%%%%%%%%%%
% punto 1 %
%%%%%%%%%%%

% filtro de ejercicio 2.2
fs = 44100; % [Hz] frecuencia de muestreo
fpass_hz = 3000; % [Hz] ^\__banda e transicion
fstop_hz = 4000; % [Hz] _/
fpass = 2 * fpass_hz / fs; %'^\_se convierte a frecuencias digitales
fstop = 2 * fstop_hz / fs; % _/
ft = (fstop + fpass) / 2; % frecuencia de corte ideal
B = fstop - fpass; % ancho de banda de transicion
M = ceil(8/B); % cantidad de taps para ventana hamming -> Ancho de lobulo principal = 8/M
M = 2*floor(M/2)+1; % convierte M al impar mayor o igual. floor(x) redondea al entero <= x
% asegura una cantidad impar de coeficientes para que el retardo D resulte en un número entero 
n = (0 : (M-1)); % elementos del vector h_sinc
h_sinc = ft * sinc (ft * (n - ((M-1)/2))); % funcion sinc del filtro pasa bajos
h_pb = h_sinc .* (hamming (M))'; % enventanado - se multiplica elemento a elemento
H_pb = fft(h_pb,1000);  % calcula la FFT con 1000 puntos de frecuencia, completa con ceros
Hdb_pb = mag2db( abs( H_pb(1:500) ) ); % convierte a dB el valor absoluto de las muestras de f positiva
frec = (0 : fs/1000 : ((fs/2)-(fs/1000)) ) / 1000; % vector con los valores de frecuencia en kHZ
% ^ ^
% | |  me parece que es de 0 a 999

d = zeros(1,M);
d ((M+1) / 2) = 1;
h_pa = d - h_pb;
H_pa = fft(h_pa,1000);  % calcula la FFT con 1000 puntos de frecuencia, completa con ceros
Hdb_pa = mag2db( abs( H_pa(1:500) ) ); % convierte a dB el valor absoluto de las muestras de f positiva

figure(2, 'name','Guia 4 ejercicio 2.2','Units','normalized','Position',[0 0 .5 1]); % pantalla completa
subplot(1,2,1);  % subplot (filas, columnas, indice)
plot (frec, Hdb_pb, 'linewidth', 3); % grafica la respuesta en frecuencia
hold on;
plot (frec, Hdb_pa, 'linewidth', 3); % grafica la respuesta en frecuencia
axis([0 20 -150 10]); % limites de los ejes
grid on;
grid minor on;
xlabel ('Frecuencia [kHz]'); % etiqueta eje X
ylabel ('Respuesta al impulso |H(f)| [dB]');  % etiqueta eje y
title ('Filtro pasa altos por reversion de espectro'); % titulo
legend('Filtro pasa bajos', 'Filtro pasa altos')
