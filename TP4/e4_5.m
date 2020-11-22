%% <------- Guia 4 - Ejercicio 5 ----------->

clc; % borra la consola
clear all; % borra todas las variables
close all; % cierra las ventanas de imagen
isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
if isOctave;
pkg load control; % paquete con 'mag2db'
pkg load signal; % ventanas
end;
% especificaciones:
fs = 44100; % [Hz] frecuencia de muestreo
fc1_hz = 950; % [Hz]  ^\__banda e transicion
fc2_hz = 1050; % [Hz] _/
% Sba = 60; % [dB] (min) -60 [dB]

% se elige la ventana blackman - Amplitud del pico mayor: -74 dB

fc1 = 2 * fc1_hz / fs; %'^\_se convierte a frecuencias digitales
fc2 = 2 * fc2_hz / fs; % _/

B = 0.01; % Este valor es arbitrario, no hay especificacion

% ^                B          B
% |H(f)         |<--->|    |<--->|
% |-------------.     |    |     .--------------
% |             |\    |    |    /|
% |             | \   |    |   / |
% |             |  \  |    |  /  |
% |             |  |\ |    | /|  |
% |             |  | '------' |  |
% |             |  |          |  |
% +-------------+--+----------+--+--------------->
%             fc1  |          |  fc2             f
%                 ft_pb  |  ft_pa
%    Fpb                 |                   Fpa
%  <---------------------+---------------------->

ft_pb = fc1 + B/2; % frec transicion del pasa bajos
ft_pa = fc2 - B/2; % frec transicion del pasa altos

n_fft = 4000; % muestras para el fft
pn_fft = n_fft/2; % muestras para el fft
frec = (0 : fs/n_fft : ((fs/2)-(fs/n_fft)) ) / 1000; % vector con los valores de frecuencia en kHZ

M = ceil(12/B); % cantidad de taps para ventana blackman -> Ancho de lobulo principal = 12/M
M = 2*floor(M/2)+1; % convierte M al impar mayor o igual. floor(x) redondea al entero <= x
% asegura una cantidad impar de coeficientes para que el retardo D resulte en un número entero
n = (0 : (M-1)); % elementos de los vectores h_sinc

%% pasa bajos
h_sinc = ft_pb * sinc (ft_pb * (n - ((M-1)/2))); % funcion sinc del filtro pasa bajos
h_pb = h_sinc .* (blackman (M))'; % enventanado - se multiplica elemento a elemento

%% pasa altos
h_sinc = ft_pa * sinc (ft_pa * (n - ((M-1)/2))); % funcion sinc del filtro pasa bajos para convertir
h_pa = h_sinc .* (blackman (M))'; % enventanado - se multiplica elemento a elemento
d = zeros(1,M); % vector para retardo
d ((M+1) / 2) = 1; % El retardo es un impulso desplazado ( un unico 1 en el centro del vector) pasa todo
h_pa = d - h_pa; % el filtro pasa alto es el retardo menos el pasa bajos

%% elimina banda
h_eb = h_pb - h_pa; % se restan el pasa bajos y el pasa altos (en el apunte dice que se suman)

H_eb = fft(h_eb,n_fft);  % calcula la FFT con n_fft puntos de frecuencia, completa con ceros
Hdb_eb = mag2db( abs( H_eb(1:pn_fft) ) ); % convierte a dB el valor absoluto de las muestras de f positiva

figure('name','Guia 4 ejercicio 5','Units','normalized','Position',[0 0 1 1]); % pantalla completa
plot (frec, Hdb_eb, 'linewidth', 1.5); % grafica la respuesta en frecuencia
axis([0 2 -50 10]); % limites de los ejes
grid on;
grid minor;
xlabel ('Frecuencia [kHz]'); % etiqueta eje X
ylabel ('Respuesta al impulso |H(f)| [dB]');  % etiqueta eje y
title ('Filtro elimina banda con f_{c1}= 950Hz  ,  f_{c2}= 1050Hz  ,  f_s= 44.1kHz  ,  ventana Blackman'); % titulo

%% Aplicacion del filtro al archivo de audio
% [Y, FS] = audioread (FILENAME) Read the audio file FILENAME and return the audio data Y and sampling rate FS.
%Y = filter (B, A, X) Apply a 1-D digital filter to the data X.

[audio_orig , Fs] = audioread('numeros_humm.wav'); %se carga el audio con interferencia de 1KHz
audio_filt = filter (h_eb, 1, audio_orig); %se aplica el filtro elimina banda
y = audioplayer (audio_orig, Fs); % reproduce la matriz de audio original
playblocking(y); %evita la superposicion con el segundo audio
sound(audio_filt, Fs) %se reproduce el audio filtrado