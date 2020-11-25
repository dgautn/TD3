%% <------- Guia 6 - Ejercicio 2.1 ----------->

clc; % borra la consola
clear all; % borra todas las variables
close all; % cierra las ventanas de imagen

%% especificaciones:

fs = 39062.5; % [Hz] frecuencia de muestreo

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

[Bpband_l, Apband_l] = cheby1 (N, RP, fpband_l, 'high'); % funcion del filtro Chebyshev tipo I
                                                         % orden, ripple, fc, tipo
[Bpband_h, Apband_h] = cheby1 (N, RP, fpband_h, 'low'); % funcion del filtro Chebyshev tipo I
                                                        % orden, ripple, fc, tipo

hpb = filter (Bpb, Apb, imp); % evalua la respuesta al impulso del filtro
Hpb = fft(hpb, fs); % calcula la FFT
Hdb = mag2db (abs (Hpb (1 : fs/2))); % convierte a dB el valor absoluto de las muestras de f positiva
