function Q=brillo_contraste(I,B,C)
I_d=imread(I); %lee la imagen
I_d=double(I_d); % convierte los datos a tipo flotante
I_bn=I_d(:,:,1).+I_d(:,:,2).+I_d(:,:,3); % suma el valor de R+G+B para cada elemento
I_bn=I_bn./3; % divide para obtener el promedio
%[a,b,c]=size(M_gris) %la matriz resultante es de 2 dimensiones
%I_d(:,:,1)=I_bn; %\
%I_d(:,:,2)=I_bn; % > carga el mismo valor en R, G y B
%I_d(:,:,3)=I_bn; %/
I_max=max(I_bn(:)); % obtiene el valor maximo de la matriz
I_min=min(I_bn(:)); % obtiene el minimo
I_d=((I_d.-I_min)./(I_max-I_min).*(C+1).+(1-C)).*128;
I_d=I_d.+(255*(2*B-1));
Q=uint8(I_d); % convierte a entero sin signo
imshow(Q)
end