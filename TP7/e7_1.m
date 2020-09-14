%% <------- Guia 7 - Ejercicio 1 ----------->

clc; % borra la consola
clear all; % borra todas las variables
close all; % cierra las ventanas de imagen
isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
if isOctave;
pkg load control; % paquete con 'mag2db'
pkg load signal; % ventanas
end;


fs1 = 29400;
fs2 = 44100; % [Hz] frecuencia de muestreo

relacion = fs2/fs1

L = 3;

M = 2;

[audio_orig , fs2] = audioread('Jahzzar_29400.wav'); %se carga el audio con interferencia de 1KHz
length(audio_orig)
audio_L = [1:length(audio_orig)*L];

m_max= length(audio_L)
for m=1:m_max
    if(rem(m,L)==0) audio_L(m)=audio_orig(m/L);
      else audio_L(m)=0;
    end
end