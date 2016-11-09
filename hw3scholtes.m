% Garrett Scholtes
% 2016-11-09
% Homework #3
% Intelligent data analysis
% 

% Close tree view windows
hiddenfigs = findall(0,'Type','figure', '-not', 'HandleVisibility', 'on');
close(hiddenfigs);
% Clear and close all
clear all;
close all;
% Seed the random number generator for convenience
% Can be removed if desired 
rng(2016);

% Load the data 
raw_data = xlsread('StudentData2.xlsx');
% Ignore the ID column 
data = raw_data(:, 2:5);
data = data(~any(isnan(data),2), :);

% Part 1
% Perform k-means for k = 3, 4, 5, 6, 7, and 8

k_values = 3:8;
sse = [];
silhouettes = [];
for k = k_values
    best_sse = Inf;
    for i = 1:3
        [sub_idx, sub_C, sub_sumd, sub_D] = kmeans(data, k);
        % Note: 
        % The default k-means algorithm uses squared euclidean distance
        % to find clusters.  This method produces the same clusters as 
        % euclidean distance, so the "sum of errors" produced by MATLAB's 
        % kmeans function is just a "sum of *squared* errors" for a 
        % Euclidean distance.
        % Therefore this works
        sub_sse = sum(sub_sumd);
        if sub_sse < best_sse
            best_sse = sub_sse;
           	idx = sub_idx;
            C = sub_C;
            sumd = sub_sumd;
            D = sub_D;
        end
    end
    % Sum of squared errors (one for each k)
    sse(end+1) = best_sse;
    % Silhouettes
    silhouettes(end+1) = mean(silhouette(data, idx, 'Euclidean'));
end

% Plot SSE versus k
figure;
plot(k_values, sse, 'b*');
title('SSE versus k (number of clusters)');
xlabel('k-value (number of clusters)');
ylabel('Sum of Squared Errors (square distance)');

figure;
plot(k_values, silhouettes, 'k*');
title('Silhouette versus k (number of clusters)');
xlabel('k-value (number of clusters)');
ylabel('Silhouette (distance)');