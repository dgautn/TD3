function y = filtro_iir (B, A, senial)
% e4_7  punto 1
% Programa que calcula la salida de un filtro IIR
% salida = filtro_iir (B, A, señal)
% señal -> señal de entrada
% salida -> salida filtrada
% B, A -> coeficientes

N = length(B); % Orden del filtro
M = length(A); % si es mayor Orden del filtro
L = length(senial); % longitud de la señal de entrada

y = zeros(1, N+L-1); % vector resultado
r_des_ent = zeros(1, N); % registro de desplazamiento para las muestras de entrada
r_des_sal = zeros(1, N); % registro de desplazamiento para las muestras de salida puede ser de N-1 ??

senial_ext = [senial, zeros(1, N-1)]; % vector de señal extendido
for n = 1:L+N-1
  r_des_ent = [senial_ext(n), r_des_ent(1:N-1)]; % llena el registro de desplazamiento con las ultimas N muestras de x
  for i = 1:N
    y(n) = y(n) + ( B(i)/ A(1) * r_des_ent(i) ); % algoritmo del filtro IIR suma productos de b[i]
  end
% se divide por A(1) -> segun el algoritmo y[n] = 1/ a[0] (......)
  for i = 2:M % comienza del segundo elemento
    y(n) = y(n) - ( A(i)/ A(1) * r_des_sal(i-1) ); % algoritmo del filtro IIR resta productos de a[i]
  end
  r_des_sal = [y(n), r_des_sal(1:N-1)]; % llena el registro de desplazamiento con las ultimas N salidas
end
