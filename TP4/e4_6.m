% <------- Guia 4 - Ejercicio 6 ----------->

clc; % borra la consola
clear all; % borra todas las variables
close all; % cierra las ventanas de imagen
pkg load control; % paquete con 'mag2db'
pkg load signal; % ventanas

%%%%%%%%%%%
% punto 1 %
%%%%%%%%%%%

a = 0.5; % amplitud
f1 = 1000; % [Hz] tono 1
f2 = 1100; % [Hz] tono 2
fs = 22050; % [Hz] frecuencia de muestreo
ts = 1/fs; % [s] periodo de muestreo
d = 2; % [s] duracion

tonos = (a * sin(2*pi*f1* [0:ts:d-ts] )) + (a * sin(2*pi*f2* [0:ts:d-ts] )); % suma de 2 pulsos senoidales
% el vector contiene los valores temporales de la señal desde 0s hasta casi 2s con un paso de periodo de muestreo

TONOS = fft(tonos, fs); % calcula la FFT con cantidad de puntos de frecuencia igual a la frec de muestreo
TONOSdb = mag2db( abs( TONOS(1:fs/2) ) ); % convierte a dB el valor absoluto de las muestras de f positiva

figure(1, 'name','Guia 4 ejercicio 6','Units','normalized','Position',[0 0 1 1]); % pantalla completa
subplot(2,2,1);  % subplot (filas, columnas, indice)
plot (TONOSdb, 'linewidth', 1.5); % grafica del espectro
axis([0 2000]); % limites de los ejes
grid on;
grid minor on;
xlabel ('Frecuencia [Hz]'); % etiqueta eje X
ylabel ('Nivel [dB]');  % etiqueta eje y
title ('Espectro de dos tonos senoidales de amplitud 0.5 y frecuencias f​_1​= 1000Hz  y  f​_2​= 1100Hz'); % titulo

sound (tonos, fs); % reproduce la señal

%%%%%%%%%%%
% punto 2 %
%%%%%%%%%%%

N_firls = 650; % cantidad de taps para el filtro firls (arbitrario)
N_remez = 500; % cantidad de taps para el filtro remez (arbitrario)
f1d = 2 * f1 / fs; %'^\_se convierte a frecuencias digitales
f2d = 2 * f2 / fs; % _/

F = [0 f1d f2d 1]; % vector de frecuencias para el filtro
A = [1 1 0.01 0.01]; % vector con atenuaciones para el filtro - db2mag(-40) =  0.010000 -> -40dB

h_firls = firls (N_firls, F, A); % filtro firls
h_remez = remez (N_remez, F, A); % filtro remez

ton_firls = conv (tonos, h_firls); % señal filrada con firls
ton_remez = conv (tonos, h_remez); % señal filrada con remez

H_firls = fft(h_firls, fs);  % calcula la FFT con cantidad de puntos de frecuencia igual a la frec de muestreo
H_firls_db = mag2db( abs( H_firls(1:fs/2) ) ); % convierte a dB el valor absoluto de las muestras de f positiva
H_remez = fft(h_remez, fs);
H_remez_db = mag2db( abs( H_remez(1:fs/2) ) );
TON_firls = fft(ton_firls, fs);
TON_firls_db = mag2db( abs( TON_firls(1:fs/2) ) );
TON_remez = fft(ton_remez, fs);
TON_remez_db = mag2db( abs( TON_remez(1:fs/2) ) );

subplot(2,2,2);  % subplot (filas, columnas, indice)
plot (H_firls_db, 'linewidth', 1.5); % grafica del espectro
hold on;
plot (H_remez_db, 'linewidth', 1.5); % grafica del espectro
axis([0 2000]); % limites de los ejes
grid on;
grid minor on;
xlabel ('Frecuencia [Hz]'); % etiqueta eje X
ylabel ('Nivel [dB]');  % etiqueta eje y
title (['Espectro de los filtros']); % titulo
legend({'firls', 'remez'}, 'location', 'northwest');
legend('boxoff');


subplot(2,2,3);  % subplot (filas, columnas, indice)
plot (TON_firls_db, 'linewidth', 1.5); % grafica del espectro
axis([0 2000]); % limites de los ejes
grid on;
grid minor on;
xlabel ('Frecuencia [Hz]'); % etiqueta eje X
ylabel ('Nivel [dB]');  % etiqueta eje y
title (['Señal filtrada con filtro firls de ', num2str(N_firls), ' taps']); % titulo
subplot(2,2,4);  % subplot (filas, columnas, indice)
plot (TON_remez_db, 'linewidth', 1.5); % grafica del espectro
axis([0 2000]); % limites de los ejes
grid on;
grid minor on;
xlabel ('Frecuencia [Hz]'); % etiqueta eje X
ylabel ('Nivel [dB]');  % etiqueta eje y
title (['Señal filtrada con filtro remez de ', num2str(N_remez), ' taps']); % titulo

sound (ton_firls, fs); % reproduce la señal con filtro firls
sound (ton_remez, fs); % reproduce la señal con filtro remez