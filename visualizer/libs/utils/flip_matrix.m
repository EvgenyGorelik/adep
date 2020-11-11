function y = flip_matrix(A)
%input: matrix A to be flipped upside down
%output: matrix y, which is -A plus max value of A

%create correction matrix, to keep values in defined area;
corrector = double(max(max(A)))*ones(size(A));
%cast corrector matrix to type of A for addition
y = cast(corrector,class(A));
%difference matrix carves values into y, dependig on original values in A 
y = y - A;
end

