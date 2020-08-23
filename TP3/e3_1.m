% <------- Guia 3 - Ejercicio 1 ----------->

close all; % cierra las ventanas de imagen

% punto 1
M=imread('lena.tiff'); %lee la imagen
[F,C,cl]=size(M)       % devuelve el tamaño de cada dimension. fila, columna, RGB.
figure('name','Guia 3 ejercicio 1_a');       % crea una nueva ventana de imagen
subplot(2,2,1);             % subplot (filas, columnas, indice)
imshow(M);                  % muestra la imagen
title ('imagen original');  % titulo para la imagen

% punto 2
M_espejo=M(:,end:-1:1,:); % invierte el orden de las columnas
subplot(2,2,2);
imshow(M_espejo); 
title ('ejercicio 1.2');

% punto 3
M_volt=M(end:-1:1,:,:); % invierte el orden de las filas
subplot(2,2,3);
imshow(M_volt);
title ('ejercicio 1.3');


% punto 4
M_d=double(M);  % convierte los datos a tipo flotante
M_d=(M_d(:,:,1)+ M_d(:,:,2)+ M_d(:,:,3))/3; % suma el valor de R+G+B para cada elemento
                                               % y divide para obtener el promedio
                                               %la matriz resultante es de 2 dimensiones
M_u8=uint8(M_d);   % convierte a entero sin signo
imwrite (M_u8, 'e3_1_4.tiff') % guarda el archivo de imagen para ser usado en el ejercicio 4
subplot(2,2,4);
imshow(M_u8);
title ('ejercicio 1.4');

% punto 5
M_ojo=M(250:285,245:290,:); % recorta la imagen
M_ojo(1,:,:)=0;   % \
M_ojo(end,:,:)=0; %   >  borra la primera y ultima, fila y columna
M_ojo(:,1,:)=0;   %  |
M_ojo(:,end,:)=0; % /
M_ojo(1,:,1)=255;   % \
M_ojo(end,:,1)=255; %   >  pone en rojo la primera y ultima, fila y columna
M_ojo(:,1,1)=255;   %  |
M_ojo(:,end,1)=255; % /
figure('name','Guia 3 ejercicio 1_b');                  % crea una nueva ventana de imagen
subplot(1,3,1);             % subplot (filas, columnas, indice)
imshow(M_ojo);              % muestra la imagen
title ('ejercicio 1.5');  % titulo para la imagen

% punto 6
m=[2 3 1];
M_GBR(:,:,:)=M(:,:,m);
subplot(1,3,2);
imshow(M_GBR);
title ('ejercicio 1.6');

%punto 7
M_bc = brillo_contraste(M,0.3,0.9); %ajusta el brillo al 30% y el contraste al 90%
subplot(1,3,3);
imshow(M_bc);
title ('ejercicio 1.7');