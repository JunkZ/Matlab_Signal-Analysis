Ts = 9/28;
t = -5:0.01:5;
n = -2:1:2;
nTs = n*Ts;
x = @(t) (3/2 + (3/10)*sin(2*pi*t) + sin(2*pi*t/3) - sin(2*pi*t/10)).*sinc(t);
x5 = x(nTs)*sinc((ones(length(nTs),1)*t-nTs'*ones(1,length(t)))/Ts);
plot(t, x5);
xlabel('T');
ylabel('Amp');
hold;
plot(t, x(t));
legend('x_5(t)', 'x(t)');