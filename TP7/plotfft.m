%% Graf las senales en el espectro de la frecuencia.
% plotfft(senial de entrada,titulo del graf,fil,col, nro de imagen)
function plotfft(senial,titulo,fil,col,j)

transf_s = fftshift(fft(senial));

y = [1:length(transf_s)];

subplot(fil,col,j);
plot(y,abs(transf_s)); title(titulo);
grid on;

x  = (1:max(abs(transf_s)*1.2));
y = x;
y(:)= fix(length(transf_s)/2);
hold on;
plot(y,x,'--k');
y(:)= fix(length(transf_s)/4);
hold on;
plot(y,x,'--m');
y(:)= fix(length(transf_s)/4*3);
hold on;
plot(y,x,'--m');

clear x
clear y


% figure('name','Guia 4 ejercicio 3.1 y 3.2','Units','normalized','Position',[0 0 1 1]); % pantalla completa
% subplot(1,2,1);  % subplot (filas, columnas, indice)
% plot (frec, Hdb_pb, 'linewidth', 1.5); % grafica la respuesta en frecuencia
% hold on;
% plot (frec, Hdb_pa, 'linewidth', 1.5); % grafica la respuesta en frecuencia
% axis([0 20 -150 10]); % limites de los ejes
% grid on;
% grid minor;
% xlabel ('Frecuencia [kHz]'); % etiqueta eje X
% ylabel ('Respuesta al impulso |H(f)| [dB]');  % etiqueta eje y
% title ('Filtro pasa altos por inversion de espectro'); % titulo
% legend({'Filtro pasa bajos', 'Filtro pasa altos'}, 'location', 'northwest');
% legend('boxoff')



end