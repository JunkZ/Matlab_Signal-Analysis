
function x = funcEx8(n)
if ~isvector(n)
    error('Input must be a vector');
end
list = size(length(n));
for i=1:length(n)
    elm = n(i);
    if (elm <= 127 && elm >= 0)
        list(i) = cos(pi*elm/8) + cos(pi*elm/4);
    else
        list(i) = 0;
    end
end
x = list;
