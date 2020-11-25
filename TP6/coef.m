%% Vector de coeficientes
% Calcula los coeficientes de un filtro IIR, de cuatro etapas iguales, 
% a partir del vector numerador (B) y denominador (A) de su función 
% de transferencia. 
%
function str = coef(B, A)
% con punto fijo
B_fx = fi(B/2, 1, 16, 15); % con punto fijo S16.15
A_fx = fi(A/2, 1, 16, 15); % con punto fijo S16.15

L = length(B);

for n = 1 : length(B) % guarda cada coeficiente como texto
    B_hex(n,:) = ['0x',char(hex(B_fx(n))),','];
    A_hex(n,:) = ['0x',char(hex(-A_fx(n))),','];
end

% Se acomodan los coeficientes de la forma:
%{0x8000,0x4000,0x1000,0x0000,0xA000,  // B0,B1,?A1,B2,?A2 (Sección 0) 
% 0x8000,0x4000,0x1000,0x0000,0xA000,  // B0,B1,?A1,B2,?A2 (Sección 1)
% 0x8000,0x4000,0x1000,0x0000,0xA000,  // B0,B1,?A1,B2,?A2 (Sección 2)
% 0x8000,0x4000,0x1000,0x0000,0xA000}; // B0,B1,?A1,B2,?A2 (Sección 3)

str = '{';
for n = 1:4; 
str = [str,B_hex(1,:),B_hex(2,:) A_hex(2,:),B_hex(3,:), A_hex(3,:)];
end
str = [str(1:end-1), '}'];


end