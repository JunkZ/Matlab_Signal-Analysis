function Ex4 = Ex4()
    n = -5:1/2:5;
    T = 1/2;
    t=-5:0.1:5;
    syms k;
    stem(t,symsum(x(n)*sinc((t-k*T)/T),k,-10,10));
    xlabel('t');
    ylabel('x(t)');