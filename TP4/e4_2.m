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

ft = (fstop - fpass) / 2; % frecuencia de corte ideal
B = fstop - fpass; % ancho de banda de transicion
M = 4/B % para ventana rectangular -> Ancho de lobulo principal = 4/M
