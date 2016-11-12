% Garrett Scholtes
% 2016-11-12

% Note: a soft way to validate this function is to
% check that a+b+c+d = n(n-1)/2

function [ ridx, a, b, c, d ] = randidx( c1, c2 )
%randidx - computes Rand Index of two partitionings c1 and c2
%   Inputs: c1 and c2 are n-by-1 matricies, each corresponding to 
%           a clustering of the same dataset, containing n data.
%           The i-th element of c1 is which cluster element i belongs
%           to in clustering 1.  Similar for c2
%   Outputs: a, b, c, and d are the standard Rand index coefficients.
%            ridx is the standard rand index computed from a, b, c, and d.

a = 0; % same c1 same c2
b = 0; % different c1 different c2
c = 0; % same c1 different c2
d = 0; % different c1 same c2

total = size(c1, 1);

for i = 1:total
    for j = (i+1):total
        same1 = c1(i) == c1(j);
        same2 = c2(i) == c2(j);
        if same1 && same2
            a = a+1;
        elseif (~same1) && (~same2)
            b = b+1;
        elseif same1 && (~same2)
            c = c+1;
        else
            d = d+1;
        end
    end
end

ridx = (a + b) / (a + b + c + d);

end