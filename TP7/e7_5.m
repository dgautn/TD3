%% <------- Guia 7 - Ejercicio 5 ----------->

clc; % borra la consola
clear all; % borra todas las variables
close all; % cierra las ventanas de imagen

L=1e5;          % Longitud de la simulacion
N=31;           % Tamaño del filtro de ecualizacion
mu=1e-4;        % Velocidad de adaptacion
sigma=0.01;      % Ruido

%% Inicializacion de vectores
sr=zeros(1,N);
h_s=zeros(1,N);
h_s((N-1)/2)=4;
x_s=zeros(1,L);
d=zeros(1,L);
e=zeros(1,L);

%% Generacion de simbolos aleatorios
x=(rand(1,L)>0.5)*2-1;

% Canal
h=[1 0.7 0.6 0.35 0.1 0.05 0.01];

% Filtrado de los simbolos por el canal
y=filter(h,1,x);

yo=y+randn(1,L)*sigma;

% Grafica de respuesta en frecuencia del canal y el ecualizador
NFFT=128;
CH=fft(h,NFFT);         % filtro canal
FC=fft(h_s,NFFT);       % filtro ecualizador

h1 = subplot(2,1,1);   % grafico superior / filtros
h1a = plot((0:NFFT/2-1)/NFFT*pi,20*log10(abs(FC(1:NFFT/2)))); % EQ
set(h1a,'linewidth',2)
hold all
h1b = plot((0:NFFT/2-1)/NFFT*pi,20*log10(abs(CH(1:NFFT/2)))); % CH
set(h1b,'linewidth',2)
xlabel('Frecuencia Normalizada','FontSize',12)
ylabel('Magnitud [dB]','FontSize',12)
legend(h1,'Respuesta del filtro adaptivo','Respuesta del canal');
set(h1,'Fontsize',12);
axis tight;
ylim([-10,30]);

%% Grafica de los simbolos recibidos
h2 = subplot(2,1,2);
h2a = plot(yo(1:500),'.');
axis tight;
ylim(h2,[-3,3]);
xlim(h2,[0,499]);
xlabel(h2,'Muestras','FontSize',12);
ylabel(h2,'Simbolos','FontSize',12);


%Bucle de procesamiento del receptor
for n=1:L

  % Registro de desplazamiento
  sr=[yo(n) sr(1:end-1)];

  %% Se insertar filtrado de muestras con h_s (^h o h sombrero) para obtener x_s[n] (^x o x sombrero)
% /-----------------\
  x_s(n) = sr * h_s';
% \-----------------/  

  % Senial de referencia obtenida a partir de x_s 
  d(n)=(x_s(n)>0)*2-1;

  % Senial de error
  e(n)=x_s(n)-d(n);

  %% Se insertar adaptacion de coeficientes para obtener los coeficientes actualizados de h_s
% /-------------------------\
  h_s = h_s - mu * e(n) * sr;
% \-------------------------/

  % Actualizacion de graficos
  if (mod(n,1000)==0)
    
    FC=fft(h_s,NFFT);  
    y_eq = 20*log10(abs(FC(1:NFFT/2)));
    set(h1a, 'YData', y_eq);                % actualiza resp. EQ
    y_datos = x_s(n-499:n);
    set(h2a, 'YData', y_datos);             % actualiza datos
    drawnow

  end
end
