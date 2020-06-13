% <------- Guia 3 - Ejercicio 1 ----------->

% punto 1
M=imread('lena.tiff'); %lee la imagen
[F,C,cl]=size(M)       % devuelve el tamaño de cada dimension. fila, columna, RGB.
imshow(M);             % muestra la imagen

% punto 2
M_espejo=M(:,end:-1:1,:); % invierte el orden de las columnas
figure(2);                % crea una nueva figura
imshow(M_espejo); 

% punto 3
M_volt=M(end:-1:1,:,:); % invierte el orden de las filas
figure(3);
imshow(M_volt);

% punto 4
M_d=double(M);  % convierte los datos a tipo flotante
M_d=(M_d(:,:,1)+ M_d(:,:,2)+ M_d(:,:,3))/3; % suma el valor de R+G+B para cada elemento
                                               % y divide para obtener el promedio
                                               %la matriz resultante es de 2 dimensiones
M_u8=uint8(M_d);   % convierte a entero sin signo
figure(4);
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
figure(5);
imshow(M_ojo); 	


% punto 6
m=[2 3 1];
M_GBR(:,:,:)=M(:,:,m);
figure(6);
imshow(M_GBR);


%punto 7
M_bc = brillo_contraste(M,0.3,0.9); %ajusta el brillo al 30% y el contraste al 90%
figure(7);
imshow(M_bc);
