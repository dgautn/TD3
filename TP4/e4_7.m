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

tonos = (sin(2*pi*f1* [0:ts:d-ts] )) + (sin(2*pi*f2* [0:ts:d-ts] )); % suma de 2 tonos senoidales
y = filtro_iir (B, A, tonos); % aplica el filtro IIR del punto 1
Y = fft (y, fs); % calcula la FFT con cantidad de puntos de frecuencia igual a la frec de muestreo
Ydb = mag2db( abs( Y(1:fs/2) ) ); % convierte a dB el valor absoluto de las muestras de f positiva

figure(1, 'name','Guia 4 ejercicio 7','Units','normalized','Position',[0 0 1 1]); % pantalla completa
subplot(2,2,1);  % subplot (filas, columnas, indice)
%plot (Ydb, 'linewidth', 1.5); % grafica del espectro
%axis([0 2000]); % limites de los ejes
grid on;
grid minor on;
xlabel ('Frecuencia [Hz]'); % etiqueta eje X
ylabel ('Amplitud');  % etiqueta eje y
title (''); % titulo

%%%%%%%%%%%
% punto 3 %
%%%%%%%%%%%

y2 = filter (B, A, tonos); % aplica el filtro IIR 
Y2 = fft (y2, fs); % calcula la FFT con cantidad de puntos de frecuencia igual a la frec de muestreo
Y2db = mag2db (abs (Y2 (1:fs/2))); % convierte a dB el valor absoluto de las muestras de f positiva

hold on;
%plot (Ydb, 'linewidth', 1.5); % grafica del espectro
%sound (tonos, fs);