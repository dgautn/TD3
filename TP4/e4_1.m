% <------- Guia 4 - Ejercicio 1 ----------->

clc; % borra la consola
close all; % cierra las ventanas de imagen

% punto 1
h = load ('low_pass.dat'); % carga el archivo .dat
figure('name','Guia 4 ejercicio 1');
subplot(1,2,1);  % subplot (filas, columnas, indice)
stem (h,'fill');

% punto 2
H = fft(h,1000);  % calcula la FFT con 1000 puntos de frecuencia, completa con ceros
Hdb = mag2db( abs( H(1:500) ) ); % convierte a dB el valor absoluto de las muestras de f positiva
fd = (0 : 1/500 : 1-(1/500) ); % vector con los valores de frecuencia digital fd = 2f / fs

subplot(1,2,2);
plot (fd, Hdb); % grafica la respuesta en frecuencia
xlabel ('Frecuencia digital ( fd = 2f / fs )'); % etiqueta eje X
ylabel ('Respuesta al impulso (H [dB])');  % etiqueta eje y
title ('Respuesta en frecuencia de un filtro FIR pasa-bajos'); % titulo

line ([0 1], [ max(Hdb) max(Hdb) ], "linestyle", "--", "color", "g");
Hfc = find( Hdb <= ( max(Hdb)-3 ) );
fc = fd( Hfc(1) );
line ([fc fc], [( min(Hdb) ) ( max(Hdb)-3 )], "linestyle", "--", "color", "g");