% <------- Ejercicio 1 ----------->

% punto 1
M=imread('lena.tiff'); %lee la imagen
[F,C,cl]=size(M) % devuelve el tamaño de cada dimension. fila, columna, RGB.
imshow(M); % muestra la imagen

% punto 2
M_espejo=M(:,end:-1:1,:); % invierte el orden de las columnas
%figure(); % crea una nueva figura
imshow(M_espejo); 

% punto 3
M_volt=M(end:-1:1,:,:); % invierte el orden de las filas
%figure();
imshow(M_volt);

% punto 4
M_d=double(M); % convierte los datos a tipo flotante
M_gris=M_d(:,:,1).+M_d(:,:,2).+M_d(:,:,3); % suma el valor de R+G+B para cada elemento
M_gris=M_gris./3; % divide para obtener el promedio
%[a,b,c]=size(M_gris) %la matriz resultante es de 2 dimensiones
M_d(:,:,1)=M_gris; %\
M_d(:,:,2)=M_gris; % > carga el mismo valor en R, G y B
M_d(:,:,3)=M_gris; %/
M_u8=uint8(M_d); % convierte a entero sin signo
%figure();
imshow(M_u8);

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
%figure();
imshow(M_ojo);

% punto 6
M_GBR(:,:,1)=M(:,:,2);
M_GBR(:,:,2)=M(:,:,3);
M_GBR(:,:,3)=M(:,:,1);
%figure();
imshow(M_GBR);






