% <------- Guia 3 - Ejercicio 4 ----------->

% punto 1

x = [1 1 1 1; 1 -2 -1 0; 1 0 0 0; 1 -1 -1 2];
h = [-1 1; 1 -2];
F = size(x,1); % filas de x
C = size(x,2); % columnas de x
N = size(h,1); % filas de h
M = size(h,2); % columnas de h
y = zeros(F+N-1,C+M-1); % matriz resultado 
hi = h(end:-1:1,end:-1:1); % matriz de kernel invertida en filas y coluumnas

% se crea una matriz con 2N+F-2 filas y 2M+C-2 columnas con la matriz x en el centro
x_amp = [zeros(M-1, 2*M+C-2); zeros(F, M-1), x, zeros(F, M-1); zeros(M-1, 2*M+C-2)];

for i = 1:N
  for j = 1:M
    y(i) = y(i) + sum(x_amp(i,j) .* h(i,j));
  end
  y(i);
end

%y

% punto 2
%y_conv = conv2(x, h)


% punto 3

img_1_4 = imread('e3_1_4.tiff'); %lee la imagen
img_d = double(img_1_4);
h3 = [1 -1; 0 0];
y3 = conv2(img_d, h3);
y3 = uint8(y3);
figure(1);
imshow(y3);

% punto 4

h4 = [1 0; -1 0];
y4 = conv2(img_d, h4);
y4 = uint8(y4);
figure(2);
imshow(y4);

% punto 5

y5 = sqrt(y3.^2 + y4.^2);
max(max(y5))
figure(3);
imshow(y5);
