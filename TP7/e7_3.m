%% <------- Guia 7 - Ejercicio 3 ----------->

printf 'secuencia\t\t fft\t\t\t\t mi_ff\n'
vect_fft = fft(x);
for i = 1:length(x)
  printf ('%f\t\t%f  %+fj \n', x(i), real(vect_fft(i)), imag(vect_fft(i)))
%  printf ('%d',num2str(x(i)))
%  printf (num2str(vect_fft(i)),'\n')
endfor
