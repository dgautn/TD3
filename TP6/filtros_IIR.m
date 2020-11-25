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


fpb = 2 * fpb_hz / fs;           % \
fpa = 2 * fpa_hz / fs;           % |_ se convierte a frecuencias digitales
fpband_pa = 2 * fpban_l_hz / fs; % |
fpband_pb = 2 * fpban_h_hz / fs; % /
