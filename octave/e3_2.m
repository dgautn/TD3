% <------- Guia 3 - Ejercicio 2 ----------->

% punto 1

x = [3, 2, -2, 1, 2]; % señal
h = [1, 2, 1]; % kernel
M = length(x); % longitud e la secuencia de entrada
N = length(h); % longitud del kernel
y = zeros(1, N+M-1); % vector resultado
r_des = zeros(1, N); % registro de desplazamiento
x_ext = [x, zeros(1, N-1)]; % vector x extendido

for n = 1:M+N-1
  r_des = [x_ext(n), r_des(1:N-1)]; % llena el registro de desplazamiento con las ultimas N muestras de x
  for i = 1:N
    y(n) = y(n) + ( h(i) * r_des(i) ); % sumatoria de convolución
  end
end

figure(1);
stem(y,'filled') % graficas de secuencias

% modificaciones para los ejes
axis off;
for l = 1:M+N-1
  text (l, y(l), mat2str(y(l)),'horizontalalignment','right','verticalalignment','bottom')
  text (l, 0,  int2str(l),'verticalalignment','top')
end


% punto 2

x2 = randn(1,7);% nueva secuencia de 7 elementos
M2 = length(x2); % longitud e la secuencia de entrada
y2 = zeros(1, N+M2-1); % vector resultado
r_des = zeros(1, N); % reinicializa el registro de desplazamiento
x2_ext = [x2, zeros(1, N-1)]; % vector x2 extendido

for n = 1:M2+N-1
  r_des = [x2_ext(n), r_des(1:N-1)]; % llena el registro de desplazamiento con las ultimas N muestras de x2
  for i = 1:N
    y2(n) = y2(n) + ( h(i) * r_des(i) ); % sumatoria de convolución
  end
end

figure(2);

plot(y2,'o-') % graficas de secuencias
y2_conv = conv(x2, h); % usando el operador convolucion
hold all;
plot(y2_conv,'x-')

% punto 3

x3 = randn(1,1000); % nuevo vector señal
h3 = randn(1,1000); % nuevo vector kernel
M3 = length(x3); % longitud e la secuencia de entrada
N3 = length(h3); % longitud del kernel
y3 = zeros(1, N3+M3-1); % nuevo vector resultado
r_des = zeros(1, N3); % reinicializa el registro de desplazamiento
x3_ext = [x3, zeros(1, N3-1)]; % vector x extendido

tic();
for n = 1:M3+N3-1
  r_des = [x3_ext(n), r_des(1:N3-1)]; % llena el registro de desplazamiento con las ultimas N muestras de x3
  h3t = h3'; %matriz transpuesta (N3 filas, 1 columna)
  y3(n) = r_des * h3t;
end
t_mat = toc(); % tiempo para la convolucion matricial

% reinicializa los vectores para la convolucion matricial
y3 = zeros(1, N3+M3-1); % vector resultado
r_des = zeros(1, N3); % registro de desplazamiento
x3_ext = [x3, zeros(1, N3-1)]; % vector x extendido

tic();
for n = 1:M3+N3-1
  r_des = [x3_ext(n), r_des(1:N3-1)]; % llena el registro de desplazamiento con las ultimas N muestras de x3
  for i = 1:N3
    y3(n) = y3(n) + ( h3(i) * r_des(i) ); % sumatoria de convolución
  end
end
t_for = toc (); % tiempo para la convolucion con bucle

printf("tiempo para la convolucion utilizando matrices: %d segundos \n", t_mat)
printf("tiempo para la convolucion utilizando iteraciones: %d segundos \n", t_for)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tiempo para la convolucion utilizando matrices: 0.0453 segundos     %
% tiempo para la convolucion utilizando iteraciones: 26.1659 segundos %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
