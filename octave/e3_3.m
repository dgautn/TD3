% <------- Guia 3 - Ejercicio 3 ----------->

% punto 1

r = audioread('numeros.wav'); % lee el archivo de audio
info = audioinfo('numeros.wav'); % obtiene informacion del archivo de audio
% info.BitsPerSample  --> bits por muestra = 24
% info.SampleRate --> frecuencia de muestreo = 44100 Hz
% info.TotalSamples --> total de muestras
h = [zeros(1, 13230), 1]; % crea una matriz con un impulso desplazado 0.3 s
                          % cantidad de muestras a 0.3 segundos => 0.3 s * fs  
                          % => 0.3 * 44100 = 13230
                          % cada muestra tiene un valor entre 0 y 1
l = conv(r, h); % convolucion del kernel con la matriz de audio
l = l(1:info.TotalSamples); % trunca la matriz resultado de la convolucion, al mismo tamaño del audio original
s = [r, l]; % crea una matriz de audio estereo
audiowrite('numeros_eco.wav', s, info.SampleRate) % guarda el archivo de audio con eco
sound (s, info.SampleRate, info.BitsPerSample) % reproduce la matriz de audio