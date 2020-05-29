Ts = 9/28;
t = -5:0.01:5;
x = @(t) (3/2 + (3/10)*sin(2*pi*t) + sin(2*pi*t/3) - sin(2*pi*t/10)).*sinc(t);
x0 = x(0)*sinc(t/Ts);
plot(t, x0)
xlabel('T');
ylabel('Amp');
hold;
plot(t, x(t));
legend('x_0(t)', 'x(t)');