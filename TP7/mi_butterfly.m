function [y0, y1] = mi_butterfly(x0, x1, twf)
% Implementacion de la funcion butterfly, para el calculo de FFT
% 'twf' : factor de giro
%
%
%               twf |  factor de giro
%                   |
%          +--------|-------------------+
%          |        v                   |
%    X1    |      +---+     - .---.     |    Y1
%   ------------->| X |---+-->| + |----------->
%          |      +---+   |   '---'     |
%          |              |     ^  +    |
%          |            .-|-----'       |
%          |            | '-----.       |
%          |            |       v  +    |
%    X0    |            |   + .---.     |    Y0
%   --------------------+---->| + |----------->
%          |                  '---'     |
%          |                            |
%          +----------------------------+

  y1 = x0 - (x1 * twf);
  y0 = x0 + (x1 * twf);
end
