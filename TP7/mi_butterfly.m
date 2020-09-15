function [y0, y1] = mi_butterfly(x0, x1, twf)
% Implementacion de la funcion butterfly, para el calculo de FFT
y1 = x0 - (x1 * twf)
y0 = x0 + (x1 * twf)
end
