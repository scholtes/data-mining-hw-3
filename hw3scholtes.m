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
rng(2012);

% Load the data 
raw_data = xlsread('StudentData2.xlsx');
% Ignore the ID column 
data = raw_data(1:50, 2:5);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Perform k-means for k = 3, 4, 5, 6, 7, and 8

% These figure coefficients are for silhouette plots
figure;

k_values = 3:8;
sse = [];
silhouettes = [];
clusterings = cell(0);
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
    silhouettes(end+1) = median(silhouette(data, idx, 'Euclidean'));
    % Plot the silhouettes
    subplot(2,3,k-2);
    silhouette(data, idx, 'Euclidean');
    title(sprintf('Silhouette values (k=%d)', k));
    ylabel('cluster ID');
    xlabel('Silhouette Coefficient');
    % Save clusterings for later use
    clusterings(end+1) = {struct('idx',idx,'C',C,'sumd',sumd,'D',D)};
end

% 1.a) Plot SSE versus k
figure;
plot(k_values, sse, 'r*');
title('SSE versus k (number of clusters)');
xlabel('k-value (number of clusters)');
ylabel('Sum of Squared Errors (square distance)');

% Plot *total* Silhouette versus k
figure;
plot(k_values, silhouettes, 'k*');
title('Silhouette versus k (number of clusters)');
xlabel('k-value (number of clusters)');
ylabel('Silhouette (distance)');

% "Best" clustering choice  
% We will use silhouette/sse as a metric we wish to maximize
% best_metric = silhouettes./sse;
% [~, best_idx] = max(best_metric);
% It appears that k=6 is the best for this set
best_idx = 4;
%%% 1.c) Best k-value %%%
best_k = k_values(best_idx);
%%% 1.d) Best clustering %%%
% Note: best_clustering.C is the centroids of the "best" clustering
best_clustering = clusterings{best_idx};

% 1.e) Perform with random data
rand_data = 100*rand(50,4);
[rand_idx, rand_C, rand_sumd, rand_D] = kmeans(rand_data, best_k);
rand_sse = sum(rand_sumd);
rand_cluster_counts = histc(rand_idx, unique(rand_idx));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Hierarchical clustering, with single-linkage and complete-linkage

pairdists = pdist(data);
single_link = linkage(pairdists, 'single');
complete_link = linkage(pairdists, 'complete');

% 2.a) Report dendrograms  
figure; 
dendrogram(single_link);
title('Dendrogram for single-link clustering of student data set');
xlabel('Node (relative cluster or datum)');
ylabel('Relative distance between paired clusters');
figure;
dendrogram(complete_link);
title('Dendrogram for complete-link clustering of student data set');
xlabel('Node (relative cluster or datum)');
ylabel('Relative distance between paired clusters');






















