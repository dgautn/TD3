% <------- Guia 3 - Ejercicio 4 ----------->
clc % borra la consola 

% punto 1

x = [1 1 1 1; 1 -2 -1 0; 1 0 0 0; 1 -1 -1 2];
h = [-1 1; 1 -2];
[F,C] = size(x); % Filas,Columnas de x
[N,M] = size(h); % filas,Columnas de h
y = zeros(F+N-1,C+M-1); % matriz resultado 
hi = h(end:-1:1,end:-1:1); % matriz de kernel invertida en filas y coluumnas

% se crea una matriz con 2N+F-2 filas y 2M+C-2 columnas con la matriz x en el centro
x_amp = [zeros(M-1, 2*M+C-2); zeros(F, M-1), x, zeros(F, M-1); zeros(M-1, 2*M+C-2)];

for i = 1:F+N-1
  for j = 1:C+M-1
    m_aux = x_amp(i:i+N-1, j:j+M-1); % crea una matriz movil de N x M
    y(i, j) = sum(sum(m_aux .* hi)); 
    end
end

y % muestra la matriz convolucion del ejerciccio 4.1

% punto 2

h2 = floor(rand(2)*6); % llena el kernel con con numeros aleatorios entre 0 y 6
y2 = zeros(F+N-1,C+M-1); % reinicializa matriz resultado 
hi2 = h2(end:-1:1,end:-1:1); % matriz de kernel invertida en filas y coluumnas

for i = 1:F+N-1
  for j = 1:C+M-1
    m_aux = x_amp(i:i+N-1, j:j+M-1);
    y2(i, j) = sum(sum(m_aux .* hi2));
    end
end

y2 % muestra la matriz convolucion del ejercicio 4.2
y2_conv = conv2(x, h2) % muestra la misma matriz con el operador convolucion



% punto 3

img_1_4 = imread('e3_1_4.tiff'); % lee la imagen
img_d = double(img_1_4); % convierte a flotante
h3 = [1 -1; 0 0]; % kernel del ejercicio 4.3
y3 = conv2(img_d, h3); % convolucion
y3 = y3 / max(max(y3)) * 255; % escala de 0 a 255 
y3uint8 = uint8(y3); % convierte a entero sin signo de 8 bits

figure('name','Guia 3 ejercicio 4_a');
subplot(2,2,1); % subplot (filas, columnas, indice)
imshow(img_1_4);
title ('imagen original'); % titulo para la imagen
subplot(2,2,2);
imshow(y3uint8);
title ('ejercicio 4.3');

%Detecta "bordes" de nivel de izq a derecha.
% Indica cuanto incrementa o decrementa la intensidad.
% La im�gen resultante solo muestra valores positivos (los dem�s los pone
% a cero), por lo que solo se ven incrementos de intensidad en esa
%direcci�n.
% Ejemplo:
% [250 230 235 236 220 5]  -> [250  0   5   1   0   0]


% punto 4
h4 = [1 0; -1 0]; % kernel del ejercicio 4.4
y4 = conv2(img_d, h4);
y4 = y4 / max(max(y4)) * 255;
y4uint8 = uint8(y4);
subplot(2,2,3);
imshow(y4uint8);
title ('ejercicio 4.4');

%Detecta "bordes" de nivel de arriba hacia abajo.
% Idem anterior, con direcci�n vertical descendente.
% Compara con el pixel de "arriba". y pone en negro (cero) los que no
% crezcan en esa direcci�n.


% punto 5

y5 = sqrt(y3.^2 + y4.^2);
y5 = y5 / max(max(y5)) * 255;

umbral=15; % Nivel relacionado al menor gradiente positivo 
           % que se va a considerar, con direc. izq->der, arriba->abajo.
           
[alto, ancho] = size(y5); %obtiene las dimensiones de la imagen
for i = 1:alto %recorre la matriz y binariza los colores
    for j  = 1:ancho
        if y5(i,j) < umbral
            y5(i,j) = 0;
        else
            y5(i,j) = 255;
        end
    end
end

subplot(2,2,4);
imshow(y5);
title ('ejercicio 4.5');


% punto 6

h6_1 = [1 0 -1; 2 0 -2; 1 0 -1]; % kernel del ejercicio 4.6-1
h6_2 = [1 2 1; 0 0 0; -1 -2 -1]; % kernel del ejercicio 4.6-2

y6_1 = conv2(img_d, h6_1);
y6_1 = y6_1 / max(max(y6_1)) * 255;
y6_1uint8 = uint8(y6_1);
figure('name','Guia 3 ejercicio 4_b');
subplot(1,3,1);
imshow(y6_1uint8);
title ('ejercicio 4.6.1');

%Similar al punto 4.3, pero toma una ventana de comparaci�n mas amplia, lo
%que dependiendo de las caracteristicas de la imagen puede ayudar a reducir
%el ruido.
%Ademas los gradientes ahora son oblicuos, el primero hacia la derecha y
%ascendete y el segundo hacia la izquierda y descendente. 

y6_2 = conv2(img_d, h6_2);
y6_2 = y6_2 / max(max(y6_2)) * 255;
y6_2uint8 = uint8(y6_2);
subplot(1,3,2);
imshow(y6_2uint8);
title ('ejercicio 4.6.2');


y7 = sqrt(y6_1.^2 + y6_2.^2);
y7 = y7 / max(max(y7)) * 255;

[alto, ancho] = size(y7);   %obtiene las dimensiones de la imagen
for i = 1:alto              %recorre la matriz y binariza los colores
    for j  = 1:ancho
        if y7(i,j) < umbral
            y7(i,j) = 0;
        else
            y7(i,j) = 255;
        end
    end
end

subplot(1,3,3);
imshow(y7);
title ('ejercicio 4.6.3');
