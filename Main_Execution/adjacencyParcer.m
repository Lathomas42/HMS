function [ANew, SNew, Done] = adjacencyParcer(A,S)
% Takes a raw adjacency matrix and eliminates all rows and columns for
% vertices with 1 or less total Degree(in+out)

AUD = sign(A);
Degs = degreeOfNodes(AUD,S);
TotalDegs = Degs(:,4);
indexes = find(TotalDegs>1);
Done=0;

if(length(indexes)==length(S))
    Done=1
end

n=length(indexes);
tempAa=[];
tempAb=[];
tempS=[];

for i=(1:n)
    ind=indexes(i);
    tempS=[tempS;S(ind)];
    tempAa=[tempAa A(:,ind)];
end

for i=(1:n)
    ind=indexes(i);
    tempAb=[tempAb;tempAa(ind,:)];
end

ANew=tempAb;
SNew=tempS;
%if you want Unweighted  and Undirected then UWUD=sign(A+A') 