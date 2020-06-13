% <------- Guia 3 - Ejercicio 2 ----------->

% punto 1

x = [3, 2, -2, 1, 2]; % señal
h = [1, 2, 1]; % kernel
M = length(x); % longitud e la secuencia de entrada
N = length(h); % longitud del kernel
y = zeros(1, N+M-1); % vector resultado
r_des = zeros(1, N); % vector señal
x_ext = [x, zeros(1, N-1)]; % vector x extendido

for n=1 : M+N-1
  r_des = [x_ext(n), r_des(1:N-1)];
  for i=1 : N
    y(n) = y(n) + ( h(i) * r_des(i) );
  end
end

stem(y,'filled') % graficas de secuencias

% modificaciones para los ejes

axis off;
for l=1 : M+N-1
  text (l, y(l), mat2str(y(l)),'horizontalalignment','right','verticalalignment','bottom')
  text (l, 0,  int2str(l),'verticalalignment','top')
end
