%% <------- Guia 7 - Ejercicio 4 ----------->

clc; % borra la consola
clear all; % borra todas las variables
close all; % cierra las ventanas de imagen

[h, fs_h]=audioread('s1_r1_b_cd.wav');
[x, fs_x]=audioread('_');

M = length(h);
N = 4*M;
L = N - (M - 1);