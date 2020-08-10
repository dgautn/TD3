% <------- Guia 4 - Ejercicio 4 ----------->

clc; % borra la consola
clear all; % borra todas las variables
close all; % cierra las ventanas de imagen
pkg load control; % paquete con 'mag2db'
pkg load signal; % ventanas

% especificaciones:
fc1 = 0.1; % · fd ^\__banda e transicion
fc2 = 0.2; % · fd _/
B = 0.01; % ancho de la banda de paso
% Sba = 60; % [dB] (min) -60 [dB]

% se elige la ventana blackman - Amplitud del pico mayor: -74 dB

% ^                B            B             
% |H(f)         |<--->|      |<--->|                      
% |             |    .--------.    |                 
% |             |   /          \   |                 
% |             |  /            \  |                 
% |             | /|            |\ |                 
% |             |/ |            | \|                 
% |-------------'  |            |  '--------------   
% |             |  |            |  |                
% |-------------+--+------------+--+--------------->
%             fc1  |            |  fc2             f 
%                 ft_pa   |   ft_pb                 
%    Fpa                  |                   Fpb    
%  <----------------------+------------------------> 

ft_pa = fc1 + B/2; % frec transicion del pasa altos
ft_pb = fc2 - B/2; % frec transicion del pasa bajos

%Bt = (ft_pa + fc1)/2; % ancho de banda de transicion

n_fft = 4000; % muestras para el fft
pn_fft = n_fft/2; % muestras para el fft
fd = (0 : 1/pn_fft : 1-(1/pn_fft) ); % vector con los valores de frecuencia digital fd = 2f / fs

M = ceil(12/B); % cantidad de taps para ventana blackman -> Ancho de lobulo principal = 12/M
M = 2*floor(M/2)+1; % convierte M al impar mayor o igual. floor(x) redondea al entero <= x
% asegura una cantidad impar de coeficientes para que el retardo D resulte en un número entero
n = (0 : (M-1)); % elementos de los vectores h_sinc

% pasa bajos
h_sinc = ft_pb * sinc (ft_pb * (n - ((M-1)/2))); % funcion sinc del filtro pasa bajos
h_pb = h_sinc .* (blackman (M))'; % enventanado - se multiplica elemento a elemento

% pasa altos
h_sinc = ft_pa * sinc (ft_pa * (n - ((M-1)/2))); % funcion sinc del filtro pasa bajos para convertir
h_pa = h_sinc .* (blackman (M))'; % enventanado - se multiplica elemento a elemento
d = zeros(1,M); % vector para retardo
d ((M+1) / 2) = 1; % El retardo es un impulso desplazado ( un unico 1 en el centro del vector) pasa todo
h_pa = d - h_pa; % el filtro pasa alto es el retardo menos el pasa bajos

% pasa banda
h_pbanda = conv (h_pb, h_pa);

H_pbanda = fft(h_pbanda,n_fft);  % calcula la FFT con n_fft puntos de frecuencia, completa con ceros
Hdb_pbanda = mag2db( abs( H_pbanda(1:pn_fft) ) ); % convierte a dB el valor absoluto de las muestras de f positiva

%H_pb = fft(h_pb,n_fft);  % calcula la FFT con n_fft puntos de frecuencia, completa con ceros
%Hdb_pb = mag2db( abs( H_pb(1:pn_fft) ) ); % convierte a dB el valor absoluto de las muestras de f positiva

figure(1, 'name','Guia 4 ejercicio 4','Units','normalized','Position',[0 0 1 1]); % pantalla completa
%subplot(1,2,1);  % subplot (filas, columnas, indice)
%plot (fd, Hdb_pb, 'linewidth', 1.5); % grafica la respuesta en frecuencia
%hold on;
%plot (fd, Hdb_pa, 'linewidth', 1.5); % grafica la respuesta en frecuencia
plot (fd, Hdb_pbanda, 'linewidth', 1.5); % grafica la respuesta en frecuencia
axis([0 .3 -150 10]); % limites de los ejes
grid on;
grid minor on;
xlabel ('Frecuencia digital ( f_d = 2·f / f_s )'); % etiqueta eje X
ylabel ('Respuesta al impulso |H(f_d)| [dB]');  % etiqueta eje y
title ('Filtro pasa banda - f_{c1} = 0.1  ,  f_{c2} = 0.2  ,  B = 0.01 - ventana blackman'); % titulo


