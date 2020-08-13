%% <------- Guia 4 - Ejercicio 2 ----------->

clc; % borra la consola
clear all; % borra todas las variables
close all; % cierra las ventanas de imagen
isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
if isOctave;
pkg load control; % paquete con 'mag2db'
pkg load signal; % ventanas
end;

%%%%%%%%%%%%
%% punto 1 %
%%%%%%%%%%%%

% especificaciones:
fpass = 0.1; % \  banda de transicion
fstop = 0.2; % /
% ventana rectangular

ft = (fstop + fpass) / 2; % frecuencia de corte ideal
B = fstop - fpass; % ancho de banda de transicion
M = 4/B; % cantidad de taps - para ventana rectangular -> Ancho de lobulo principal = 4/M
n = (0 : (M-1)); % elementos del vector h_sinc

h_sinc = ft * sinc (ft * (n - ((M-1)/2))); % funcion sinc del filtro
h = h_sinc .* (rectwin (M))'; % se aplica la ventana rectangular, no tiene 
                              % ningun efecto porque es un vector de unos
% nota: se hace la transpuesta porque la funcion de ventana devuelve un 
% arreglo de M x 1, y nuestro vector es de 1 x M

figure('name','Guia 4 ejercicio 2.1','Units','normalized','Position',[0 0 1 1]); % pantalla completa
subplot(1,2,1);  % subplot (filas, columnas, indice)
stem (h,'fill');

H = fft(h,1000);  % calcula la FFT con 1000 puntos de frecuencia, completa con ceros
Hdb = mag2db( abs( H(1:500) ) ); % convierte a dB el valor absoluto de las muestras de f positiva
fd = (0 : 1/500 : 1-(1/500) ); % vector con los valores de frecuencia digital fd = 2f / fs

subplot(1,2,2);
plot (fd, Hdb, 'linewidth', 1.5); % grafica la respuesta en frecuencia
xlabel ('Frecuencia digital ( f_d = 2·f / f_s )'); % etiqueta eje X
ylabel ('Respuesta al impulso |H(f_d)| [dB]');  % etiqueta eje y
title ('Filtro pasa-bajos con f_{pass}=0.1·f_d  y  f_{stop} = 0.2·f_d'); % titulo
grid on;

%%%%%%%%%%%%
%% punto 2 %
%%%%%%%%%%%%

clear all; % borra todas las variables

% especificaciones:
fs = 44100; % [Hz] frecuencia de muestreo
fpass_hz = 3000; % [Hz] ^\__banda e transicion
fstop_hz = 4000; % [Hz] _/
% Rp = 0.5; % [dB] (max) mag2db(db2mag(0.5)-1) -> ans = -24.546  [dB]
% Sba = 50; % [dB] (min) -50 [dB] es la condicion mas exigente
% minima cantidad de taps

% se elige la ventana hamming - Amplitud del pico mayor: -53 dB

fpass = 2 * fpass_hz / fs; %'^\_se convierte a frecuencias digitales
fstop = 2 * fstop_hz / fs; % _/
ft = (fstop + fpass) / 2; % frecuencia de corte ideal
B = fstop - fpass; % ancho de banda de transicion
M = ceil(8/B); % cantidad de taps para ventana hamming -> Ancho de lobulo principal = 8/M
% ceil (x) redondea al entero mayor o igual, mas cercano a 'x'
n = (0 : (M-1)); % elementos del vector h_sinc

h_sinc = ft * sinc (ft * (n - ((M-1)/2))); % funcion sinc del filtro
h = h_sinc .* (hamming (M))'; % enventanado - se multiplica elemento a elemento

H = fft(h,1000);  % calcula la FFT con 1000 puntos de frecuencia, completa con ceros
Hdb = mag2db( abs( H(1:500) ) ); % convierte a dB el valor absoluto de las muestras de f positiva
frec = (0 : fs/1000 : ((fs/2)-(fs/1000)) ) / 1000; % vector con los valores de frecuencia en kHZ

figure('name','Guia 4 ejercicio 2.2','Units','normalized','Position',[0 0 .5 1]); % mitad de pantalla
plot (frec, Hdb, 'linewidth', 1.5); % grafica la respuesta en frecuencia
axis([0 20 -150 10]); % limites de los ejes
xlabel ('Frecuencia [kHz]'); % etiqueta eje X
ylabel ('Respuesta al impulso |H(f)| [dB]');  % etiqueta eje y
title ('Filtro pasa-bajos con f_{pass}=3kHz  ,  f_{stop} = 4kHz  ,  f_s = 44.1kHz  ,  ventana Hamming'); % titulo
grid on;
grid minor;