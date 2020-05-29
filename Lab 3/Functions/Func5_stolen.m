function x = funcEx5(t)
if ~isvector(t)
    error('Input must be a vector');
end
x = (3/2 + (3/10)*sin(2*pi*t) + sin(2*pi*t/3) - sin(2*pi*t/10)).*sinc(t);