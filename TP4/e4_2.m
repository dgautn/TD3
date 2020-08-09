% <------- Guia 4 - Ejercicio 2 ----------->

clc; % borra la consola
clear all; % borra todas las variables
close all; % cierra las ventanas de imagen
pkg load control; % paquete con 'mag2db'

% punto 1

% especificaciones:
fpass = 0.1;
fstop = 0.2;
% ventana rectangular

ft = (fstop + fpass) / 2; % frecuencia de corte ideal
B = fstop - fpass; % ancho de banda de transicion
M = 4/B; % cantidad de taps - para ventana rectangular -> Ancho de lobulo principal = 4/M
n = (0 : (M-1)); % elementos del vector h_sinc

h_sinc = ft * sinc (ft * (n - ((M-1)/2))); % funcion sinc del filtro
h = h_sinc .* (rectwin (M))'; % se aplica la ventana rectangular, no tiene ningun efecto porque es un vector de unos
% nota se hace la transpuesta porque la funcion de ventana devuelve un arreglo de M x 1, y nuestro vector es de 1 x M

figure(2, 'name','Guia 4 ejercicio 2','Units','normalized','Position',[0 0 1 1]); % pantalla completa
subplot(1,2,1);  % subplot (filas, columnas, indice)
stem (h,'fill');

H = fft(h,1000);  % calcula la FFT con 1000 puntos de frecuencia, completa con ceros
Hdb = mag2db( abs( H(1:500) ) ); % convierte a dB el valor absoluto de las muestras de f positiva
fd = (0 : 1/500 : 1-(1/500) ); % vector con los valores de frecuencia digital fd = 2f / fs
% ^ ^
% | |  me parece que es de 0 a 499

subplot(1,2,2);
plot (fd, Hdb, 'linewidth', 3); % grafica la respuesta en frecuencia
limits = axis; % vector con los limites de los ejes [xmin xmax ymin ymax]
xmin = limits(1);
xmax = limits(2);
ymin = limits(3);
ymax = limits(4);
xlabel ('Frecuencia digital ( f_d = 2·f / f_s )'); % etiqueta eje X
ylabel ('Respuesta al impulso |H(f_d)| [dB]');  % etiqueta eje y
title ('Filtro pasa-bajos con f_{pass}=0.1·f_d  y  f_{stop} = 0.2·f_d'); % titulo