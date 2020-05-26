function Q=brillo_contraste(I,B,C)
I_d=double(I); % convierte los datos a tipo flotante
I_bn=I_d(:,:,1)+I_d(:,:,2)+I_d(:,:,3); % suma el valor de R+G+B para cada elemento
I_bn=I_bn/3; % divide para obtener el promedio
I_max=max(I_bn(:)); % obtiene el valor maximo de la matriz
I_min=min(I_bn(:)); % obtiene el minimo
I_d=((I_d-I_min)/(I_max-I_min)*(C+1)+(1-C))*128; % funcion para ajustar contraste
I_d=I_d+(255*(2*B-1)); % funcion para ajustar brillo
Q=uint8(I_d); % convierte a entero sin signo
end