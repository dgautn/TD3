% <------- Guia 4 - Ejercicio 1 ----------->

% punto 1
h = load ('low_pass.dat'); % carga el archivo .dat
stem (h,'fill');

% punto 2
H = fft(h,1000);  % calcula la FFT con 1000 puntos de frecuencia, completa con ceros
Hdb = mag2db( abs( H(1:500) ) );

