%% <------- Guia 7 - Ejercicio 4 ----------->


clc; % borra la consola
clear all; % borra todas las variables
close all; % cierra las ventanas de imagen

[h, fs_h]=audioread('s1_r1_b_cd.wav');
[x, fs_x]=audioread('Little_Wing.wav');

M = length(h); % Longitud de la respuesta al impulso del filtro
N = 4*M; % Cantidad de muestras de la FFT
L = N - (M - 1); % Cantidad de muestras procesadas por bloque

x_l = length(x);
x = [x ; zeros(L*ceil(x_l/L) - x_l, 2)]; % se agregan ceros para tenr una cantidad entera de L
x = [zeros((M-1), 2) ; x]; % se gregan ceros al comienzo, que se eliminan en el filtrado
H = fft(h, N); % Respuesta al impulso del filtro

y = [0, 0];
l = 1;
while l <= x_l
%  l
%  l + N - 1
  muestra = x(l : l + N - 1, 2);
  Muestra = fft(muestra, N);
  Muestra = Muestra .* H;
  muestra = ifft(Muestra);
  y = [y ; muestra(M:end,:)];
  l = l + N -(M-1);
endwhile

y = y(2:end - (L*ceil(x_l/L) - x_l) ,:); % se quitan los ceros agregados al final
sound(y, fs_x);
