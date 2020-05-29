function e6 = e6(n)
    nlen = length(n);
    list = size(nlen); 
    for c = 1:nlen
        i=n(c)+2;
        if (i>=0 && i<= 10)
            list(c) = (1/2)^i;
        else 
            list(c) = 0;
        end
    end
    e6 = list;