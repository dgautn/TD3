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
l = l(1:info.TotalSamples); % trunca la matriz resultado de la convolucion, al mismo tamaÃ±o del audio original
s = [r, l]; % crea una matriz de audio estereo

audiowrite('numeros_eco.wav', s, info.SampleRate) % guarda el archivo de audio con eco
y = audioplayer (s, info.SampleRate, info.BitsPerSample); % reproduce la matriz de audio
playblocking(y); %evita la superposición con el segundo audio

% punto 2

K = 882; % retardo * frec.muestreo = 0.02 * 44100 = 882
N = 4410; % 0.1 * 44100 = 4410 (5 retardos de 20 ms)
a = 0.7079457844; % -3dB = 20 log(a/1) => a = 10^(3/20) = 0.7079457844

h_peine = zeros(1, N-1); % crea un vector kerne de N elementos en cero
ai = 1;

for i = 1:K:N; % iteracion desde 1 hasta N, con pasos de K
  h_peine(i) = ai; % ubica un impulso atenuado cada K (cada 0.02segundos)
  ai = ai * a; % disminuye la atenuacion
end

s_peine = conv(r,h_peine); % convoluciona el kernel con la matriz de audio
s_peine = s_peine/max(s_peine); % normaliza el resultado
audiowrite('numeros_rever.wav', s_peine, info.SampleRate) % guarda el archivo de audio con reverberancia
sound (s_peine, info.SampleRate, info.BitsPerSample) % % reproduce la matriz de audio