% <------- Guia 4 - Ejercicio 6 ----------->

clc; % borra la consola
clear all; % borra todas las variables
close all; % cierra las ventanas de imagen
pkg load control; % paquete con 'mag2db'
pkg load signal; % ventanas

%%%%%%%%%%%
% punto 1 %
%%%%%%%%%%%

% especificaciones:
N = 3; % orden del filtro
fc = 50; % HZ - frecuencia de corte
fs = 256; % Hz - frecuencia de muestreo

fdc = 2*fc/fs; % frecuencia de corte digital

[B, A] = butter (N, fdc, 'high'); % funcion del filtro Butterworth

%%%%%%%%%%%
% punto 2 %
%%%%%%%%%%%

d = 4; % duracion del impulso
imp = zeros(1, d * fs); % genera un vector de 4 segundos a 256 muestras por segundo
imp(1) = 1; % primer elemento en 1 -> funcion impulso
h = filter (B, A, imp); % evalua la respuesta al impulso del filtro del punto 1
H = fft(h, fs); % calcula la FFT
Hdb = mag2db (abs (H (1 : fs/2))); % convierte a dB el valor absoluto de las muestras de f positiva
frec = (0 : 1 : (fs/2)-1 ); % vector con los valores de frecuencia (el primer elemento es 0Hz

figure(1, 'name','Guia 4 ejercicio 8','Units','normalized','Position',[0 0 1 1]); % pantalla completa
subplot(2,2,1);  % subplot (filas, columnas, indice)
plot (frec, Hdb, 'linewidth', 1.5); % grafica de la respuesta al impulso
axis([0 127]); % limites de los ejes
grid on;
grid minor on;
xlabel ('Frecuencia [Hz]'); % etiqueta eje X
ylabel ('Magnitud [dB]');  % etiqueta eje y
title ('Filtro Butterworth'); % titulo

%%%%%%%%%%%%%%%
% punto 3 y 4 %
%%%%%%%%%%%%%%%

hold on;
etapa = 1;
etapa_l = '1 etapa'; % para las insertar las leyendas

while( abs(Hdb(21)) <= 120 )
  etapa = etapa +1; % incrementa el contador de etapas
  h = filter (B, A, h); % agrega una etapa de filtrado
  H = fft(h, fs); % al dominio de la frecuencia
  Hdb = mag2db (abs (H (1 : fs/2))); % a dB los valores absolutos de las frec positivas
  plot (frec, Hdb, 'linewidth', 1.5); % graficala respuesta al impulso
  etapa_l = [etapa_l; num2str(etapa), ' etapas']; % agrega elemento para las leyendas
end

legend(etapa_l, 'location', 'southeast');
legend('left');
legend('boxoff');

%%%%%%%%%%%
% punto 5 %
%%%%%%%%%%%

RP = 1; % [dB] - ripple en banda de paso
RS = 20; % [dB] - ripple en banda de stop

% ----------- Filtro Chebyshev tipo I -------------

[B, A] = cheby1 (N, RP, fdc, 'high'); % funcion del filtro Chebyshev tipo I

h = filter (B, A, imp); % evalua la respuesta al impulso del filtro
H = fft(h, fs); % calcula la FFT
Hdb = mag2db (abs (H (1 : fs/2))); % convierte a dB el valor absoluto de las muestras de f positiva

subplot(2,2,2);  % subplot (filas, columnas, indice)
plot (frec, Hdb, 'linewidth', 1.5); % grafica de la respuesta al impulso
axis([0 127]); % limites de los ejes
grid on;
grid minor on;
xlabel ('Frecuencia [Hz]'); % etiqueta eje X
ylabel ('Magnitud [dB]');  % etiqueta eje y
title ('Filtro Chebyshev tipo I'); % titulo
hold on;

etapa = 1;
etapa_l = '1 etapa'; % para las insertar las leyendas

while( abs(Hdb(21)) <= 120 )
  etapa = etapa +1; % incrementa el contador de etapas
  h = filter (B, A, h); % agrega una etapa de filtrado
  H = fft(h, fs); % al dominio de la frecuencia
  Hdb = mag2db (abs (H (1 : fs/2))); % a dB los valores absolutos de las frec positivas
  plot (frec, Hdb, 'linewidth', 1.5); % graficala respuesta al impulso
  etapa_l = [etapa_l; num2str(etapa), ' etapas']; % agrega elemento para las leyendas
end

legend(etapa_l, 'location', 'southeast');
legend('left');
legend('boxoff');

% ----------- Filtro Chebyshev tipo II -------------

[B, A] = cheby2 (N, RS, fdc, 'high'); % funcion del filtro Chebyshev tipo II

h = filter (B, A, imp); % evalua la respuesta al impulso del filtro
H = fft(h, fs); % calcula la FFT
Hdb = mag2db (abs (H (1 : fs/2))); % convierte a dB el valor absoluto de las muestras de f positiva

subplot(2,2,3);  % subplot (filas, columnas, indice)
plot (frec, Hdb, 'linewidth', 1.5); % grafica de la respuesta al impulso
axis([0 127]); % limites de los ejes
grid on;
grid minor on;
xlabel ('Frecuencia [Hz]'); % etiqueta eje X
ylabel ('Magnitud [dB]');  % etiqueta eje y
title ('Filtro Chebyshev tipo II'); % titulo
hold on;

etapa = 1;
etapa_l = '1 etapa'; % para las insertar las leyendas

while( abs(Hdb(21)) <= 120 )
  etapa = etapa +1; % incrementa el contador de etapas
  h = filter (B, A, h); % agrega una etapa de filtrado
  H = fft(h, fs); % al dominio de la frecuencia
  Hdb = mag2db (abs (H (1 : fs/2))); % a dB los valores absolutos de las frec positivas
  plot (frec, Hdb, 'linewidth', 1.5); % graficala respuesta al impulso
  etapa_l = [etapa_l; num2str(etapa), ' etapas']; % agrega elemento para las leyendas
end

legend(etapa_l, 'location', 'southeast');
legend('left');
legend('boxoff');

% ----------- Filtro eliptico -------------

[B, A] = ellip (N, RP, RS, fdc, 'high'); % funcion del filtro eliptico

h = filter (B, A, imp); % evalua la respuesta al impulso del filtro
H = fft(h, fs); % calcula la FFT
Hdb = mag2db (abs (H (1 : fs/2))); % convierte a dB el valor absoluto de las muestras de f positiva

subplot(2,2,4);  % subplot (filas, columnas, indice)
plot (frec, Hdb, 'linewidth', 1.5); % grafica de la respuesta al impulso
axis([0 127]); % limites de los ejes
grid on;
grid minor on;
xlabel ('Frecuencia [Hz]'); % etiqueta eje X
ylabel ('Magnitud [dB]');  % etiqueta eje y
title ('Filtro eliptico'); % titulo
hold on;

etapa = 1;
etapa_l = '1 etapa'; % para las insertar las leyendas

while( abs(Hdb(21)) <= 120 )
  etapa = etapa +1; % incrementa el contador de etapas
  h = filter (B, A, h); % agrega una etapa de filtrado
  H = fft(h, fs); % al dominio de la frecuencia
  Hdb = mag2db (abs (H (1 : fs/2))); % a dB los valores absolutos de las frec positivas
  plot (frec, Hdb, 'linewidth', 1.5); % graficala respuesta al impulso
  etapa_l = [etapa_l; num2str(etapa), ' etapas']; % agrega elemento para las leyendas
end

legend(etapa_l, 'location', 'southeast');
legend('left');
legend('boxoff');
