% <------- Guia 4 - Ejercicio 7 ----------->

clc; % borra la consola
clear all; % borra todas las variables
close all; % cierra las ventanas de imagen
pkg load control; % paquete con 'mag2db'
pkg load signal; % ventanas

%%%%%%%%%%%
% punto 1 %
%%%%%%%%%%%

% en funcion << filtro_iir.m >>

%%%%%%%%%%%
% punto 2 %
%%%%%%%%%%%

fs = 256; % [Hz] - frecuencia de muestreo
f1 = 50; % [Hz] - frec del tono 1
f2 = 100; % [Hz] - frec del tono 2
d = 8; % [s] duracion de la señall

% especificaciones:
B = [0.0528556 0.0017905 0.0017905 0.0528556];
A = [1.00000 -2.12984 1.78256 -0.54343];

ts = 1/fs; % [s] periodo de muestreo
frec = (0 : 1 : (fs/2)-1 ); % vector con los valores de frecuencia (el primer elemento es 0Hz

tonos = (sin(2*pi*f1* [0:ts:d-ts] )) + (sin(2*pi*f2* [0:ts:d-ts] )); % suma de 2 tonos senoidales
y = filtro_iir (B, A, tonos); % aplica el filtro IIR del punto 1
Y = fft (y, fs); % calcula la FFT con cantidad de puntos de frecuencia igual a la frec de muestreo
Ypos = abs( Y(1:(fs/2)) ); % guarda el valor absoluto de las muestras de f positiva
%Ydb = mag2db( abs( Y(1:fs/2) ) ); % convierte a dB el valor absoluto de las muestras de f positiva

figure(1, 'name','Guia 4 ejercicio 7','Units','normalized','Position',[0 0 1 1]); % mitad de pantalla
subplot(2,1,1);  % subplot (filas, columnas, indice)
plot (frec, Ypos, 'c', 'linewidth', 3.5); % grafica del espectro
axis([0 127]); % limites de los ejes
grid on;
grid minor on;
xlabel ('Frecuencia [Hz]'); % etiqueta eje X
ylabel ('Amplitud');  % etiqueta eje y
title ('Señal bitonal de 50Hz y 100Hz filtrada'); % titulo

text (50, Ypos(51), [num2str(Ypos(51)), "\n  50Hz"], "horizontalalignment", "left");
text (100, Ypos(101), [num2str(Ypos(101)), "\n  100Hz"], "horizontalalignment", "left");

%%%%%%%%%%%
% punto 3 %
%%%%%%%%%%%

y2 = filter (B, A, tonos); % aplica el filtro IIR 
Y2 = fft (y2, fs); % calcula la FFT con cantidad de puntos de frecuencia igual a la frec de muestreo
Y2pos = abs (Y2 (1:fs/2)); % guarda el valor absoluto de las muestras de f positiva
%Y2db = mag2db (abs (Y2 (1:fs/2))); % convierte a dB el valor absoluto de las muestras de f positiva

hold on;
plot (frec, Y2pos,  'r--', 'linewidth', 1); % grafica del espectro
legend({'IIR implementado', 'funcion filter'}, 'location', 'northwest');
legend('boxoff');
hold off;

%%%%%%%%%%%
% punto 4 %
%%%%%%%%%%%

[H, W] = freqz (B, A); % devuelve la respuesta en frec de un IIR - W vector de frecuencias
W_hz = W/(2*pi)*fs; % W esta en frec angular - pasamos a Hz
H_db = mag2db(abs(H)); % convierte a dB
subplot(2,1,2);  % subplot (filas, columnas, indice)
plot (W_hz, H_db, 'linewidth', 1.5);
axis([0 127]); % limites de los ejes
grid on;
grid minor on;
xlabel ('Frecuencia [Hz]'); % etiqueta eje X
ylabel ('Magnitud [dB]');  % etiqueta eje y
title ('Respuesta en frecuencia del filtro'); % titulo

hold on;
plot(50, H_db(200),'rx', 'linewidth', 3)
plot(100, H_db(400),'rx', 'linewidth', 3)
text (50, H_db(200), [num2str(H_db(200)), " dB\n  50Hz"], "verticalalignment", "top");
text (100, H_db(400), [num2str(H_db(400)), " dB\n  100Hz"], "verticalalignment", "top");

% 50 * length (H_db) / (fs/2) -> ans =  200  % elemento del vector para cada frec
% 100 * length (H_db) / (fs/2) -> ans =  400 %
