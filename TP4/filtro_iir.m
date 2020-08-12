function y = filtro_iir (B, A, senial)
% e4_7  punto 1  
% Programa que calcula la salida de un filtro IIR
% salida = filtro_iir (B, A, señal)
% señal -> señal de entrada
% salida -> salida filtrada
% B, A -> coeficientes
  
N = length(B); % o length(A) ??? Orden del filtro
M = length(senial); % longitud de la señal de entrada

y = zeros(1, N+M-1); % vector resultado
r_des_ent = zeros(1, N); % registro de desplazamiento para las muestras de entrada
r_des_sal = zeros(1, N); % registro de desplazamiento para las muestras de salida puede ser de N-1 ??

senial_ext = [senial, zeros(1, N-1)]; % vector de señal extendido
for n = 1:M+N-1
  r_des_ent = [senial_ext(n), r_des_ent(1:N-1)]; % llena el registro de desplazamiento con las ultimas N muestras de x
  for i = 1:N
    y(n) = y(n) + ( B(i) * r_des_ent(i) ); % algoritmo del filtro IIR suma productos de b[i]
  end
  for i = 2:N % empieza del segundo elemento
    y(n) = y(n) - ( A(i) * r_des_sal(i) ); % algoritmo del filtro IIR resta productos de a[i]
  end
  r_des_sal = [y(n), r_des_sal(1:N-1)]; %llena el registro de desplazamiento con las ultimas N salidas
end

y = y / A(1); % segun el algoritmo y[n] = 1/ a[0] (......)