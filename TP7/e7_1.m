%% <------- Guia 7 - Ejercicio 1 ----------->

clc; % borra la consola
clear all; % borra todas las variables
close all; % cierra las ventanas de imagen
isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
if isOctave;
pkg load control; % 
pkg load signal; % 
end;

[audio_orig , fs_orig] = audioread('Jahzzar_29400.wav'); % se carga el audio

%fs1 = 29400; % [Hz] frecuencia de muestreo original
fs1 = fs_orig; % frecuencia de muestreo original
fs2 = 44100; % [Hz] frecuencia de muestreo

sound(audio_orig(1:end/20), fs2) % se reproduce una parte del audio original

[L,M] = rat(fs2/fs1); % fraccional de la relacion de conversion
f_corte = 1 / max([L M]); % frecuencia de corte mas chica para el filtro

audio_up = upsample(audio_orig, L); % se aplica upsampling

[B, A] = butter (3, f_corte, "low"); % se genera un filtro butter 

audio_filt = filter(B, A, audio_up); % se aplica el filtro

audio_down = downsample(audio_filt, M); % se aplica downsampling

sound(audio_down(1:end/30), fs2) %se reproduce una parte del audio modificado
