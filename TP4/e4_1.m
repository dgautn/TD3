% <------- Guia 4 - Ejercicio 1 ----------->

clc; % borra la consola
clear all; % borra todas las variables
close all; % cierra las ventanas de imagen
pkg load control; % paquete con 'mag2db'
pkg load signal; % 'findpeaks'

% punto 1
h = load ('low_pass.dat'); % carga el archivo .dat
figure('name','Guia 4 ejercicio 1','Units','normalized','Position',[0 0 1 1]); % pantalla completa
subplot(1,2,1);  % subplot (filas, columnas, indice)
stem (h,'fill');

% punto 2
H = fft(h,1000);  % calcula la FFT con 1000 puntos de frecuencia, completa con ceros
Hdb = mag2db( abs( H(1:500) ) ); % convierte a dB el valor absoluto de las muestras de f positiva
fd = (0 : 1/500 : 1-(1/500) ); % vector con los valores de frecuencia digital fd = 2f / fs
% ^ ^
% | |  me parece que es de 0 a 499

subplot(1,2,2);
plot (fd, Hdb, 'linewidth', 3); % grafica la respuesta en frecuencia
limits = axis; % vector con los limites de los ejes [xmin xmax ymin ymax]
xmin = limits(1);
xmax = limits(2);
ymin = limits(3);
ymax = limits(4);
xlabel ('Frecuencia digital ( f_d = 2·f / f_s )'); % etiqueta eje X
ylabel ('Respuesta al impulso |H(f_d)| [dB]');  % etiqueta eje y
title ('Respuesta en frecuencia de un filtro FIR pasa-bajos'); % titulo

% punto 3

Gp = Hdb(1); % ganancia de continua
fc_H = find( Hdb <= ( Gp-3 ) ); % encuentra elemento con Gp-3dB
fc_H = fc_H(1); % solo la primera ocurrencia
Gfc = Hdb(fc_H); % ganancia en la frecuencia de corte
fc = fd(fc_H); % frecuencia de corte
Rp = max(Hdb); % ripple en banda de paso
fRp_H = find( Hdb == Rp ); % encuentra elemento de ripple
fRp = fd( fRp_H(1) ); % frecuencia donde se produce el maximo ripple
[H_sba, loc] = findpeaks(Hdb(fc_H:end), "DoubleSided"); % maximos [pico, ocurrencia], "DoubleSided" -> valores negativos
f_btr = fd( fc_H+loc(1) ); % f_max banda transicion
H_sba = max(H_sba); % busca el mayor pico
elem_sba = find ( Hdb(fc_H:end) == H_sba ); % busca el indice del mayor pico en la banda de rechazo
f_sba = fd( fc_H+elem_sba ); % frecuencia del mayor pico en la banda de rechazo

line ([0 f_sba], [Gp Gp], "linestyle", "-.", "color", "r", 'linewidth', 1);
line ([f_sba f_sba], [H_sba Gp], "linestyle", ":", "color", "b", 'linewidth', 1);
line ([fc fc], [ymin Gfc], "linestyle", "-.", "color", "r", 'linewidth', 1);
line ([fc fc], [Gfc Gp], "linestyle", ":", "color", "b", 'linewidth', 1);

text_Gp = ['Gp = ', num2str(Gp), ' dB '];
text_Rp = ['Rp = ', num2str(Rp), ' dB'];
text_fc = [' fc = ', num2str(fc), ' · fd'];
text_Sba = [' Sba = ', num2str(Gp-H_sba), ' dB'];

text (0, Gp, text_Gp, "horizontalalignment", "right");
text (fRp, Rp, text_Rp, "horizontalalignment", "center", "verticalalignment", "bottom");
text (fc, ymin, text_fc, "verticalalignment", "bottom");
text (f_sba, Gp+(H_sba/2), text_Sba);
text (fc, Gp-1.5, ' 3dB');
text (0, ymax, 'Banda de paso', "verticalalignment", "top");
text (xmax, ymax, 'Banda de rechazo', "horizontalalignment", "right", "verticalalignment", "top");

patch ([xmin xmin fc fc], [ymin ymax ymax ymin], [0.7 1 0.7],'EdgeColor', 'none');
patch ([fc fc f_btr f_btr], [ymin ymax ymax ymin], [1 1 0.5],'EdgeColor', 'none');
patch ([f_btr f_btr xmax xmax], [ymin ymax ymax ymin], [1 0.8 0.8],'EdgeColor', 'none');

axis ('auto'); % se vuelve a dibujar los ejes por si se sobreescribio alguna parte
%grid on;