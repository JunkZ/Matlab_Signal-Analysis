Ts = 9/28;
n = -5:Ts:5;
x = @(t) (3/2 + (3/10)*sin(2*pi*t) + sin(2*pi*t/3) - sin(2*pi*t/10)).*sinc(t);
stem(n, x(n))
grid on
title('Exercise 3');
legend('x(n) = x(nT_s)');
xlabel('n');
ylabel('x[n]');