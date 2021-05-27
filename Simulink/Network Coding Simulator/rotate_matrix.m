function [rotated_matrix] = rotate_matrix(matrix, elements)
rotated_part = matrix(:,1:elements);
matrix(:,1:elements) = [];
rotated_matrix = [matrix rotated_part];
end