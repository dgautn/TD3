%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% Ejercicio 1.5 %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
M=imread('lena.tiff'); 	% lee imagen
imshow(M); 				% muestra imagen

Mred = uint8(255*ones(40,65,1)); % crea capa roja al 100%
Mgb = uint8(255*zeros(40,65,2)); % crea capas verde y azul al 0%

Mred(3:37,3:62,1)=M(253:287,238:297,1);     %Copia porcion de la imagen en canal rojo
Mgb(3:37,3:62,2:3)=M(253:287,238:297,2:3);	%Copia porcion en canales verde y azul

Mcuadro(:,:,1)= Mred;			%crea matriz con primer canal rojo
Mcuadro(:,:,2:3)= Mgb(:,:,2:3); %agrega los canales verde y azul.

figure();
imshow(Mcuadro); 	%nueva imagen con seleccion


