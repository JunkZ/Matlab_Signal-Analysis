function e7 = e7(n)
    nlen = length(n);
    list = size(nlen); 
    for c = 1:nlen
        i=n(c);
        if (i>=0 && i<= 127)
            list(c) = cos(pi/8*i)+cos(pi/4*i);
        else 
            list(c) = 0;
        end
    end
    e7 = list;