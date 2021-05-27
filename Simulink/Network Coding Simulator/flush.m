%flush the kth row of matrix a with elements of a GF
function [a] = flush(a, k, field_size)
b = a.x;
b(k,:) = [];
a = gf(b,field_size);
end