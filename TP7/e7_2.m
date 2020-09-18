%% <------- Guia 7 - Ejercicio 2 ----------->

clc; % borra la consola
clear all; % borra todas las variables
close all; % cierra las ventanas de imagen
isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
if isOctave;
pkg load control; 
pkg load signal; 
pkg load communications;
end;

fs2 = 44100; % [Hz] frecuencia de muestreo deseada

%% Original
[audio_orig , fs1] = audioread('numeros.wav'); %se carga el audio


m = length(audio_orig);

figure('name','Guia 7-2 Fig.1','Units','normalized','Position',[0 0 1 1]);
plotfft(audio_orig,'FFT audio original',2,1,1);



%% ========================== Parametros ==============
f_au = 20000;           % frecuencia audible max

fc1 = f_au/(2*fs1)       % Frec corte audible (PB pre modulacion)
fc2 = 0.5                % Frec corte para modulacion y filtro PA
fm = fs1/16;             % Cada ciclo del coseno consta de 16 puntos

%================
df = [0.21 0.2 0.19];               % Corrimienros de frec en la demodulacion
%================

[B, A] = butter (6, fc1, 'low');            % Filtro PB pre
[D, C] = butter (6, fc2+0.05, 'high');      % Filtro PA

[F, E] = butter (6, fc2-0.05, 'low');            % Filtro PB dem


audio_1 = filter(B, A, audio_orig);    % Elimina frecuencias altas de audio
%audio_1 = filter(B, A, audio_1);
sound(audio_1(1:end/5), fs1);          % Reproduce parte del audio


plotfft(audio_1,'Audio original filtrado',2,1,2); % Graf. la FFT centrada

%% %%%%%==================== Modulacion ===========

am_t = zeros(m,1); % senial modulada am en el tiempo 

tm = gcd(fs1,m);  % long de las muestras. (max comun div)
p = fix(m/tm);    % Partes a calcular;
am = zeros(tm,1); % c7u de las partes
t = [1:tm];       % longitud temporal del coseno

figure('name','Guia 7-2 Fig.2','Units','normalized','Position',[0 0 1 1]);
hold on;

%% ========================== Producto ===========
cos_t = cos(2*pi*fm*t);
cos_t = cos_t';

for i=1:p;
   tii =tm*(i-1)+1;
   tmi = tii +tm-1;
    am(:,1) = cos_t(:,1).*audio_1(tii:tmi,1);
if i == 1
    am_t = am;
else
    am_t = [am_t; am];
end
end

am_1 = 10*am_t;         % corrige atenuacion
plotfft(am_1,'Modulada etapa 1',4,2,1);

[am_1,fs] = filter(D, C, am_1); %PA deja solo banda superior
[am_1,fs] = filter(D, C, am_1); %PA

plotfft(am_1,'Modulada filtrada etapa 1',4,2,2);
sound(am_1(1:end/5), fs1);

%% ========================== Productos de democulacion ============
% mismo procedimiento con diferentes frecuencias fm

audio_final = zeros(m,3);


for k=1:3;
cos_t = cos(2*pi*(fm*df(k))*t);
cos_t = cos_t';

for i=1:p;
   tii =tm*(i-1)+1;
   tmi = tii +tm-1;
    am(:,1) = cos_t(:,1).*am_1(tii:tmi,1);

if i == 1
    am_t = am;
else
    am_t = [am_t; am];
end
end

audio_final(:,k) = 10*am_t;

tit = 'Demodulada '; tit2 = ' con fm * ';
tit = [tit int2str(k+1) tit2 mat2str(df(k))];
plotfft(audio_final(:,k),tit,4,2,2*k+1);

[audio_final(:,k),fs] = filter(F, E, audio_final(:,k));
%[audio_final(k),fs] = filter(H, G, audio_final(k));

tit = 'Demodulada filtrada ';
tit = [tit int2str(k+1) tit2 mat2str(df(k))];
plotfft(audio_final(:,k),tit,4,2,2*k+2);

sound(audio_final(1:end/5,k), fs1);

end

