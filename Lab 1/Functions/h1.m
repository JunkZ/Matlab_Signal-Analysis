function f = h1(n)
list = size(length(n));
for i=1:length(n)
    elm = n(i);
    if (elm <= 7 && elm >= 0)
        list(i) = 1/8;
    else
        list(i) = 0;
    end
end
f = list;