%% <------- Guia 6 - Ejercicio 2.1 ----------->

clc; % borra la consola
clear all; % borra todas las variables
close all; % cierra las ventanas de imagen

%% especificaciones:

fs = 39062; % [Hz] frecuencia de muestreo

fpb_hz = 500;       % [Hz] pasa bajos
fpa_hz = 3000;      % [Hz] pasa altos
fpban_l_hz = 700;   % [Hz] \__ pasa banda
fpban_h_hz = 2000;  % [Hz] /

N = 2;              % orden del filtro
RP = 0.1;           % ripple en la banda de paso

fpb = 2 * fpb_hz / fs;           % \
fpa = 2 * fpa_hz / fs;           % |_ se convierte a frecuencias digitales
fpband_pa = 2 * fpban_l_hz / fs; % |
fpband_pb = 2 * fpban_h_hz / fs; % /

imp = zeros(1, 4 * fs); % \__ funcion impulso con un vector de 4 segundos
imp(1) = 1;             % /

%% pasa bajos

[Bpb, Apb] = cheby1 (N, RP, fpb, 'low'); % funcion del filtro Chebyshev tipo I
                                          % orden, ripple, fc, tipo

hpb = filter (Bpb, Apb, imp); % evalua la respuesta al impulso del filtro
Hpb = fft(hpb, fs); % calcula la FFT
Hdb_pb = mag2db (abs (Hpb (1 : fs/2))); % convierte a dB el valor absoluto de las muestras de f positiva

%% pasa altos

[Bpa, Apa] = cheby1 (N, RP, fpa, 'high'); % funcion del filtro Chebyshev tipo I 
                                          % orden, ripple, fc, tipo

hpa = filter (Bpa, Apa, imp); % evalua la respuesta al impulso del filtro
Hpa = fft(hpa, fs); % calcula la FFT
Hdb_pa = mag2db (abs (Hpa (1 : fs/2))); % convierte a dB el valor absoluto de las muestras de f positiva

%% pasa banda

[Bpband_l, Apband_l] = cheby1 (N, RP, fpband_pa, 'high'); % funcion del filtro Chebyshev tipo I
                                                          % orden, ripple, fc, tipo
[Bpband_h, Apband_h] = cheby1 (N, RP, fpband_pb, 'low'); % funcion del filtro Chebyshev tipo I
                                                         % orden, ripple, fc, tipo

hpband_l = filter (Bpband_l, Apband_l, imp); % evalua la respuesta al impulso del filtro pasa alto
hpband_h = filter (Bpband_h, Apband_h, imp); % evalua la respuesta al impulso del filtro pasa bajo
hpband = conv(hpband_l, hpband_h); % filtro pasa banda convolucionando pa y pb

Hpband = fft(hpband, fs); % calcula la FFT
Hdb_pband = mag2db (abs (Hpband (1 : fs/2))); % convierte a dB el valor absoluto de las muestras de f positiva

%% combinacion en serie de 4 etapas 

%hpb4 = hpb;
%hpa4 = hpa;
%hpband4 = hpband;

%for n = 1:4
%    hpb4 = conv (hpb4, hpb);
%    hpa4 = conv (hpa4, hpa);
%    hpband4 = conv (hpband4, hpband);
%end

for etapa = 1:3
    hpb = filter (Bpb, Apb, hpb); % Agrega 3 etapas pasa bajo
    hpa = filter (Bpa, Apa, hpa);  % Agrega 3 etapas pasa alto
    hpband_l = filter (Bpband_l, Apband_l, hpband_l); %Obtiene 4 etapas pb y pa para
    hpband_h = filter (Bpband_h, Apband_h, hpband_h); %construir pasabanda de 4 etapas  
end
hpband = conv(hpband_l,hpband_h); % Obtiene pasabanda de 4 etapas

Hpb4 = fft(hpb, fs); % calcula la FFT
Hdb_pb4 = mag2db (abs (Hpb4 (1 : fs/2))); % convierte a dB el valor absoluto de las muestras de f positiva

Hpa4 = fft(hpa, fs); % calcula la FFT
Hdb_pa4 = mag2db (abs (Hpa4 (1 : fs/2))); % convierte a dB el valor absoluto de las muestras de f positiva

Hpband4 = fft(hpband, fs); % calcula la FFT
Hdb_pband4 = mag2db (abs (Hpband4 (1 : fs/2))); % convierte a dB el valor absoluto de las muestras de f positiva

%% Graficos

% pasa bajos - 1 etapa
frec = (0 : 1 : (fs/2)-1 ); % vector con los valores de frecuencia (el primer elemento es 0Hz)
figure('name','Guia 6 ejercicio 2.1 - Filtros Chebyshev tipo I de segundo orden','Units','normalized','Position',[0 0 1 1]); % pantalla completa
subplot(2,3,1);  % subplot (filas, columnas, indice)
semilogx (frec, Hdb_pb, 'linewidth', 1.5); % grafica de la respuesta al impulso
xlim([0 10000]); % limites de los ejes
ylim([-30 0]); % limites de los ejes
grid on;
grid minor;
xlabel ('Frecuencia [Hz]'); % etiqueta eje X
ylabel ('Magnitud [dB]');  % etiqueta eje y
title ('Filtro pasa bajos - 1 etapa'); % titulo

% pasa altos - 1 etapa
subplot(2,3,2);  % subplot (filas, columnas, indice)
semilogx (frec, Hdb_pa, 'linewidth', 1.5); % grafica de la respuesta al impulso
xlim([0 10000]); % limites de los ejes
ylim([-30 0]); % limites de los ejes
grid on;
grid minor;
xlabel ('Frecuencia [Hz]'); % etiqueta eje X
ylabel ('Magnitud [dB]');  % etiqueta eje y
title ('Filtro pasa altos - 1 etapa'); % titulo

% pasa banda - 1 etapa
subplot(2,3,3);  % subplot (filas, columnas, indice)
semilogx (frec, Hdb_pband, 'linewidth', 1.5); % grafica de la respuesta al impulso
xlim([0 10000]); % limites de los ejes
ylim([-30 0]); % limites de los ejes
grid on;
grid minor;
xlabel ('Frecuencia [Hz]'); % etiqueta eje X
ylabel ('Magnitud [dB]');  % etiqueta eje y
title ('Filtro pasa banda - 1 etapa'); % titulo

% pasa bajos - 4 etapas
subplot(2,3,4);  % subplot (filas, columnas, indice)
semilogx (frec, Hdb_pb4, 'linewidth', 1.5); % grafica de la respuesta al impulso
xlim([0 10000]); % limites de los ejes
ylim([-30 0]); % limites de los ejes
grid on;
grid minor;
xlabel ('Frecuencia [Hz]'); % etiqueta eje X
ylabel ('Magnitud [dB]');  % etiqueta eje y
title ('Filtro pasa bajos - 4 etapas'); % titulo

% pasa altos - 4 etapas
subplot(2,3,5);  % subplot (filas, columnas, indice)
semilogx (frec, Hdb_pa4, 'linewidth', 1.5); % grafica de la respuesta al impulso
xlim([0 10000]); % limites de los ejes
ylim([-30 0]); % limites de los ejes
grid on;
grid minor;
xlabel ('Frecuencia [Hz]'); % etiqueta eje X
ylabel ('Magnitud [dB]');  % etiqueta eje y
title ('Filtro pasa altos - 4 etapas'); % titulo

% pasa banda - 4 etapas
subplot(2,3,6);  % subplot (filas, columnas, indice)
semilogx (frec, Hdb_pband4, 'linewidth', 1.5); % grafica de la respuesta al impulso
xlim([0 10000]); % limites de los ejes
ylim([-30 0]); % limites de los ejes
grid on;
grid minor;
xlabel ('Frecuencia [Hz]'); % etiqueta eje X
ylabel ('Magnitud [dB]');  % etiqueta eje y
title ('Filtro pasa banda - 4 etapas'); % titulo

%% Vector de Coeficientes (ver coef.m)

pasa_bajos = coef(Bpb, Apb) %pasa bajos
pasa_altos = coef(Bpa, Apa) %pasa altos
pasa_banda_l = coef(Bpband_l, Apband_l) %pasa Banda inf
pasa_banda_h = coef(Bpband_h, Apband_h) %pasa Banda sup

