function Degs = degreeOfNodes(A, S)
%degreeOfNodes(A,S) takes an adjacency Matrix (A) and a list of
%corresponding skeletons (S) and returns a matrix with rows as follows:
% [Skeleton# InDegree OutDegree TotalDegree]

n = length(S);

%returns an n-by-1 matrix of sums of columns and rows respectively
InDegree = reshape(sum(A), n, 1);
OutDegree = reshape(sum(A'), n, 1);
TotalDegree = InDegree + OutDegree;

Degs = [S, InDegree, OutDegree, TotalDegree];