%% <------- Guia 7 - Ejercicio 3 ----------->

clc; % borra la consola
clear all; % borra todas las variables
close all; % cierra las ventanas de imagen
pkg load signal; %

for n = [4 8 16 64]
    x = rand(n,1);
    fft_oct = fft(x);
    fft_m = mi_fft(x);
    printf '\nsecuencia\t\t fft\t\t\t\tmi_fft\n'
    printf '---------\t\t ---\t\t\t\t------\n'
    tab = [x real(fft_oct) imag(fft_oct) real(fft_m) imag(fft_m)]';
    printf ('%f\t\t %f %+f j \t\t%f  %+f j \n', tab)
    printf ('-------------------------------------------------------------\n\n')
endfor
