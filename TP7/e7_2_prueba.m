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

%% Original
[audio_orig , fs] = audioread('numeros.wav'); %se carga el audio

m = length(audio_orig);

figure('name','Guia 7-2 Fig.1','Units','normalized','Position',[0 0 1 1]);
plotfft(audio_orig,'FFT audio original',2,1,1);

%% ========================== Parametros ==============
f_au = 3000;           % frecuencia corte voz

fc1 = f_au/fs;       % Frec corte audible (PB pre modulacion)
fc2 = 0.5;           % Frec corte para modulacion y filtro PA
f_ny = fs /2;

%================
df = [-0.1 0 0.1];               % Corrimienros de frec en la demodulacion
%================

[B, A] = butter (3, fc1, 'low');            % Filtro PB pre

[D, C] = butter (60, fc2, 'high');      % Filtro PA

[F, E] = butter (60, fc2, 'low');            % Filtro PB dem


audio_1 = filter(B, A, audio_orig);    % Elimina frecuencias altas de audio
sound(audio_1(1:end/5), fs);          % Reproduce parte del audio


%plotfft(audio_1,'Audio original filtrado',2,1,2); % Graf. la FFT centrada

%% %%%%%==================== Modulacion ===========

%figure('name','Guia 7-2 Fig.2','Units','normalized','Position',[0 0 1 1]);
%hold on;

%% ========================== Producto ===========

coseno = cos(2*pi*(f_ny/2/fs)*(1:m));
audio_2 = audio_1 .* coseno';

%plotfft(audio_2,'Modulada etapa 1',4,2,1);

audio_3 = filter(D, C, audio_2); %PA deja solo banda superior

%plotfft(audio_3,'Modulada filtrada etapa 1',4,2,2);

%% ========================== Productos de democulacion ============
% mismo procedimiento con diferentes frecuencias fm

audio_3 = [audio_3 audio_3 audio_3];

for k=1:3

coseno = 3 * cos(2*pi*((f_ny/2)*(1+df(k))/fs)*(1:m)); % se aumenta la portadora para corregir atenuacion
audio_final(:,k) = audio_3(:,k) .* coseno';

end

%tit = 'Demodulada '; tit2 = ' con fm * ';
%tit = [tit  tit2 ];
%plotfft(audio_final,tit,4,2);

audio_final = filter(F, E, audio_final);

%tit = 'Demodulada filtrada ';
%tit = [tit int2str(k+1) tit2 mat2str(df(k))];
%plotfft(audio_final(:,k),tit,4,2,2*k+2);

sound(audio_final(0.2*end:0.4*end,1), fs);
sound(audio_final(0.4*end:0.6*end,2), fs);
sound(audio_final(0.6*end:0.8*end,3), fs);

%end

