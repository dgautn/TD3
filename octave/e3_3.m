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

% punto 2

K = 882; % 0.02 * 44100 = 882
N = 4410; % 0.1 *44100 = 4410
a = 0.7079457844; % -3dB = 20 log(a/1) => a = 10^(3/20) = 0.7079457844
h_peine = [1, zeros(1, N-1)]; % crea un vector kerne de N elementos con el primer elemento = 1
for i = K:K:N; % iteracion desde K hasta N, con pasos de K
  h_peine(i) = a; % ubica un impulso atenuado cada K (cada 0.02segundos)
  a = a^2; % disminuye la atenuacion
end
s_peine = conv(r,h_peine); % convoluciona el kernel con la matriz de audio
s_peine = s_peine/max(s_peine); % normaliza el resultado
audiowrite('numeros_rever.wav', s_peine, info.SampleRate) % guarda el archivo de audio con reverberancia
sound (s_peine, info.SampleRate, info.BitsPerSample) % % reproduce la matriz de audio