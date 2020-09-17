%% <------- Guia 7 - Ejercicio 4 ----------->

clc; % borra la consola
clear all; % borra todas las variables
close all; % cierra las ventanas de imagen

[h, fs_h]=audioread('s1_r1_b_cd.wav'); % se carga el filtro
[x, fs_x]=audioread('Little_Wing.wav'); % se carga la secuencia de audio

M = length(h); % Longitud de la respuesta al impulso del filtro
N = 4*M; % Cantidad de muestras de la FFT
L = N - (M - 1); % Cantidad de muestras procesadas por bloque

x_l = length(x);
x_f = [x ; zeros(L*ceil(x_l/L) - x_l, 2)]; % se agregan ceros para tener una cantidad entera de L
x_f = [zeros((M-1), 2) ; x_f]; % se gregan ceros al comienzo, que se eliminan en el filtrado
H = fft(h, N); % Respuesta al impulso del filtro

y = []; % se crea la matriz resultado vacia
l = 1;
tic;
while l <= x_l % se repite hasta recorrer toda la secuencia de audio
  muestra = x_f(l : l + N - 1, 2); % se toma una muestra de tamaño N
  Muestra = fft(muestra, N); % se obtiene la DFT de N muestras
  Muestra = Muestra .* H; % se multiplica elemento a elemento con la respuesta del filtro
  muestra = ifft(Muestra); % se obtiene la DFT inversa (se vuelve al dominio del tiempo)
  y = [y ; real(muestra(M:end,:))]; % se descartan los primeros 'M - 1' elementos y se combinan los bloques de salida
  l = l + N -(M-1); % se aumenta el indice para las proximas muestras
endwhile
y = y(1:end - (L*ceil(x_l/L) - x_l) ,:); % se quitan los ceros agregados al final

printf('\nEl filtrado en frecuencia consume %d segundos.\n', toc);

%tic
%y_t = [conv(x(:,1), h(:,1)), conv(x(:,2), h(:,2))];
%printf('\nEl filtrado en frecuencia consume %d segundos.\n', toc);

sound(y, fs_x); % se reproduce el resultado
