t = -5:0.01:5;
x = (3/2 + (3/10)*sin(2*pi*t) + sin(2*pi*t/3) - sin(2*pi*t/10)).*sinc(t);
plot(t, x)
title('Exercise 1');
legend('x(t) = (3/2 + (3/10)sin(2\pit) + sin(2\pit/3) - sin(2\pit/10))sinc(t)');
xlabel('t');
ylabel('x(t)');