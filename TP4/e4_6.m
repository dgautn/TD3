% <------- Guia 4 - Ejercicio 6 ----------->

%%%%%%%%%%%
% punto 1 %
%%%%%%%%%%%

clc; % borra la consola
clear all; % borra todas las variables
close all; % cierra las ventanas de imagen
pkg load control; % paquete con 'mag2db'
pkg load signal; % ventanas

A = 0.5; % amplitud
f1 = 1000; % [Hz] tono 1
f2 = 1100; % [Hz] tono 2
fs = 22050; % [Hz] frecuencia de muestreo
ts = 1/fs; % [s] periodo de muestreo
d = 2; % [s] duracion

f = (A * sin(2*pi*f1* [0:ts:d-ts] )) + (A * sin(2*pi*f2* [0:ts:d-ts] )); % suma de 2 pulsos senoidales
% el vector contiene los valores temporales de la señal desde 0s hasta casi 2s con un paso de periodo de muestreo 

F = fft(f, fs);  % calcula la FFT con cantidad de puntos de frecuencia igual a la frec de muestreo
Fdb = mag2db( abs( F(1:fs/2) ) ); % convierte a dB el valor absoluto de las muestras de f positiva

figure(1, 'name','Guia 4 ejercicio 6','Units','normalized','Position',[0 0 1 1]); % pantalla completa
plot (Fdb, 'linewidth', 1.5); % grafica del espectro
axis([0 2000]); % limites de los ejes
grid on;
grid minor on;
xlabel ('Frecuencia [Hz]'); % etiqueta eje X
ylabel ('Nivel [dB]');  % etiqueta eje y
title ('Espectro de dos tonos senoidales de amplitud 0.5 y frecuencias f​_1​= 1000Hz  y  f​_2​= 1100Hz'); % titulo

sound (f, fs); % reproduce la señal
