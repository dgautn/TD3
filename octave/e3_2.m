% <------- Guia 3 - Ejercicio 2 ----------->

% punto 1

x = [3, 2, -2, 1, 2]; % señal
h = [1, 2, 1]; % kernel
M = length(x); % longitud e la secuencia de entrada
N = length(h); % longitud del kernel
y = zeros(1, N+M-1); % vector resultado
r_des = zeros(1, N); % registro de desplazamiento
x_ext = [x, zeros(1, N-1)]; % vector x extendido

for n=1 : M+N-1
  r_des = [x_ext(n), r_des(1:N-1)]; % llena el registro de desplazamiento con las ultimas N muestras de x
  for i=1 : N
    y(n) = y(n) + ( h(i) * r_des(i) ); % sumatoria de convolución
  end
end

figure(1);
stem(y,'filled') % graficas de secuencias

% modificaciones para los ejes
axis off;
for l=1 : M+N-1
  text (l, y(l), mat2str(y(l)),'horizontalalignment','right','verticalalignment','bottom')
  text (l, 0,  int2str(l),'verticalalignment','top')
end


% punto 2

x2 = randn(1,7)% nueva secuencia de 7 elementos
M2 = length(x2); % longitud e la secuencia de entrada
y2 = zeros(1, N+M2-1); % vector resultado
r_des = zeros(1, N); % reinicializa el registro de desplazamiento
x2_ext = [x2, zeros(1, N-1)]; % vector x2 extendido

for n=1 : M2+N-1
  r_des = [x2_ext(n), r_des(1:N-1)]; % llena el registro de desplazamiento con las ultimas N muestras de x2
  for i=1 : N
    y2(n) = y2(n) + ( h(i) * r_des(i) ); % sumatoria de convolución
  end
end

figure(2);
stem(y2,'filled') % graficas de secuencias
y2
% modificaciones para los ejes
axis off;
for l=1 : M2+N-1
  text (l, y2(l), mat2str(y2(l),3),'horizontalalignment','right','verticalalignment','bottom')
  text (l, 0,  int2str(l),'verticalalignment','top')
end
