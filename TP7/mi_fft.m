function y = mi_fft(x)
% Implementacion de la FFT de x
N = length(x);
k = [0 : N/2-1];
tfv = exp(-1i*2*pi*k/N);
y = bitrevorder(x)

for step = 2.^(0:log2(N/2)) % recorre las etapas
  for j = 0 : step-1 %  
    for i = 1 : step*2 : N-j %
      [y(i+j), y(i+j+step)] = mi_butterfly(y(i+j), y(i+j+step), tfv(j*(N/2)/step+1));
    end
  end
end

end