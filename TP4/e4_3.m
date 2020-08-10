% <------- Guia 4 - Ejercicio 3 ----------->

clc; % borra la consola
clear all; % borra todas las variables
close all; % cierra las ventanas de imagen
pkg load control; % paquete con 'mag2db'
pkg load signal; % ventanas


%%%%%%%%%%%   ______________________________________
% punto 1 %  | pasa altos por inversion de espectro |
%%%%%%%%%%%   """"""""""""""""""""""""""""""""""""""

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

d = zeros(1,M); % vector para retardo
d ((M+1) / 2) = 1; % El retardo es un impulso desplazado ( un unico 1 en el centro del vector) pasa todo
h_pa = d - h_pb; % el filtro pasa alto es el retardo menos el pasa bajos
H_pa = fft(h_pa,1000);  % calcula la FFT con 1000 puntos de frecuencia, completa con ceros
Hdb_pa = mag2db( abs( H_pa(1:500) ) ); % convierte a dB el valor absoluto de las muestras de f positiva

figure(1, 'name','Guia 4 ejercicio 3.1 y 3.2','Units','normalized','Position',[0 0 1 1]); % pantalla completa
subplot(1,2,1);  % subplot (filas, columnas, indice)
plot (frec, Hdb_pb, 'linewidth', 1.5); % grafica la respuesta en frecuencia
hold on;
plot (frec, Hdb_pa, 'linewidth', 1.5); % grafica la respuesta en frecuencia
axis([0 20 -150 10]); % limites de los ejes
grid on;
grid minor on;
xlabel ('Frecuencia [kHz]'); % etiqueta eje X
ylabel ('Respuesta al impulso |H(f)| [dB]');  % etiqueta eje y
title ('Filtro pasa altos por inversion de espectro'); % titulo
legend({'Filtro pasa bajos', 'Filtro pasa altos'}, 'location', 'northwest');
legend('boxoff')

%%%%%%%%%%%   ______________________________________
% punto 2 %  | pasa altos por reversion de espectro |
%%%%%%%%%%%   """"""""""""""""""""""""""""""""""""""

h_pa_r = h_pb; % copia el filtro pasa bajos
h_pa_r(1:2:end) = h_pa_r(1:2:end) * -1; % multiplica por -1 los elementos impares
H_pa_r = fft(h_pa_r,1000);  % calcula la FFT con 1000 puntos de frecuencia, completa con ceros
Hdb_pa_r = mag2db( abs( H_pa_r(1:500) ) ); % convierte a dB el valor absoluto de las muestras de f positiva

subplot(1,2,2);  % subplot (filas, columnas, indice)
plot (frec, Hdb_pb, 'linewidth', 1.5); % grafica la respuesta en frecuencia
hold on;
plot (frec, Hdb_pa_r, 'linewidth', 1.5); % grafica la respuesta en frecuencia
axis([0 22 -150 10]); % limites de los ejes
grid on;
grid minor on;
xlabel ('Frecuencia [kHz]'); % etiqueta eje X
ylabel ('Respuesta al impulso |H(f)| [dB]');  % etiqueta eje y
title ('Filtro pasa altos por reversion de espectro'); % titulo
legend({'Filtro pasa bajos', 'Filtro pasa altos'}, 'location', 'northwest');
legend('boxoff')

%%%%%%%%%%%   _____________________________
% punto 3 %  | diseño de filtro pasa altos |
%%%%%%%%%%%   """""""""""""""""""""""""""""

clear all; % borra todas las variables

% especificaciones:
fs = 44100; % [Hz] frecuencia de muestreo
fpass_hz = 6000; % [Hz] ^\__banda e transicion
fstop_hz = 6100; % [Hz] _/  fpass del pb = fstop del pa, y viceversa
% Rp = 0.1; % [dB] (max) mag2db(db2mag(0.1)-1) -> ans = -38.726 [dB]
% Sba = 80; % [dB] (min) -80 [dB] es la condicion mas exigente
% se permite ripple en la banda de transicion ??????

% se elige la ventana blackman - Amplitud del pico mayor: -74 dB (insuficiente)
% diseño con inversion de espectro, copia el procedimieno del punto 1
% ¡¡¡¡¡ con otra ventana !!!!!

n_fft = 4000; % muestras para el fft
pn_fft = n_fft/2; % muestras para el fft

fpass = 2 * fpass_hz / fs; %'^\_se convierte a frecuencias digitales
fstop = 2 * fstop_hz / fs; % _/
ft = (fstop + fpass) / 2; % frecuencia de corte ideal
B = fstop - fpass; % ancho de banda de transicion
M = ceil(12/B); % cantidad de taps para ventana blackman -> Ancho de lobulo principal = 12/M
M = 2*floor(M/2)+1; % convierte M al impar mayor o igual. floor(x) redondea al entero <= x
% asegura una cantidad impar de coeficientes para que el retardo D resulte en un número entero
n = (0 : (M-1)); % elementos del vector h_sinc
h_sinc = ft * sinc (ft * (n - ((M-1)/2))); % funcion sinc del filtro pasa bajos
h_pb = h_sinc .* (blackman (M))'; % enventanado - se multiplica elemento a elemento
frec = (0 : fs/n_fft : ((fs/2)-(fs/n_fft)) ) / 1000; % vector con los valores de frecuencia en kHZ
% ^ ^
% | |  me parece que es de 0 a n_fft-1

d = zeros(1,M); % vector para retardo
d ((M+1) / 2) = 1; % El retardo es un impulso desplazado ( un unico 1 en el centro del vector) pasa todo
h_pa = d - h_pb; % el filtro pasa alto es el retardo menos el pasa bajos
H_pa = fft(h_pa,n_fft);  % calcula la FFT con n_fft puntos de frecuencia, completa con ceros
Hdb_pa = mag2db( abs( H_pa(1:pn_fft) ) ); % convierte a dB el valor absoluto de las muestras de f positiva

figure(2, 'name','Guia 4 ejercicio 3.3','Units','normalized','Position',[0 0 .5 1]); % mitad de pantalla
plot (frec, Hdb_pa, 'linewidth', 1); % grafica la respuesta en frecuencia
axis([0 10 -250 10]); % limites de los ejes
grid on;
grid minor on;
xlabel ('Frecuencia [kHz]'); % etiqueta eje X
ylabel ('Respuesta al impulso |H(f)| [dB]');  % etiqueta eje y
title ('Filtro pasa altos con f_{pass}= 6.1kHz  ,  f_{stop}= 6kHz  ,  f_s= 44.1kHz  ,  ventana Blackman'); % titulo