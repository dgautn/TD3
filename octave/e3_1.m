% <------- Ejercicio 1 ----------->

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
M_gris=(M_d(:,:,1)+ M_d(:,:,2)+ M_d(:,:,3))/3; % suma el valor de R+G+B para cada elemento
                                               % y divide para obtener el promedio
                                               %la matriz resultante es de 2 dimensiones
M_d=M_gris;
M_u8=uint8(M_d);   % convierte a entero sin signo
figure(4);
imshow(M_u8);

% punto 5
M_ojo(:,:,1) = uint8(255*ones(40,65,1));     % crea capa roja al 100%
M_ojo(:,:,2:3) = uint8(255*zeros(40,65,2));  % crea capas verde y azul al 0%
M_ojo(3:37,3:62,1)=M(253:287,238:297,1);     %Copia porcion de la imagen en canal rojo
M_ojo(3:37,3:62,2:3)=M(253:287,238:297,2:3); %Copia porcion en canales verde y azul
figure(5);
imshow(M_ojo); 	


% punto 6
m=[2 3 1];
M_GBR(:,:,:)=M(:,:,m);
figure(6);
imshow(M_GBR);







