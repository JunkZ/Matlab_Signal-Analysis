function system1 = system1(n)
    nlen = length(n);
    list = size(nlen); 
    for c = 1:nlen
        i=n(c);
        list(c) = (x(i)+x(i-1)+x(i-2)+x(i-3)+x(i-4)+x(i-5)+x(i-6)+x(i-7))/8;
    end
    system1 = list;
