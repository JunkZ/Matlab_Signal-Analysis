function e5 = e5(n)
    nlen = length(n);
    list = size(nlen); 
    for c = 1:nlen
        i=n(c);
        if (i>=0 && i<= 10)
            list(c) = (1/2).^i;
        else 
            list(c) = 0;
        end
    end
    e5 = list;