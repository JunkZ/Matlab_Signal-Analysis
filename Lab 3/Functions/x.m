function x = x(t)
    x = (3/2+3/10*sin(2*pi*t)+sin((2*pi)/3*t)-sin((2*pi)/10*t)).*sinc(t);