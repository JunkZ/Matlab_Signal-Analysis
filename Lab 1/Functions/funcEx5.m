function x = funcEx5(n)
if ~isvector(n)
    error('Input must be a vector');
end
list = size(length(n)); 
for i=1:length(n)
    elm = n(i);
    if (elm <= 10 && elm >= 0)
        list(i) = power(1/2, elm);
    else
        list(i) = 0;
    end
end
x = list;