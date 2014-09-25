function [A1, S1] = NoInh(A,S,I)
%NoInh(A,S,I) removes inhibitory rows/columns from an adjacency matrix(A) and
%its corresponding skeleton list(S) according to a list of inhibitory
%skeletons (I) (Can also be used for any list of skeletons you want
%removed)
n = length(I);
indexes = [];
tempA = [];
A1 = [];
S1 = [];

for i = 1:n
    if (find(S == I(i)))
        temp = find(S == I(i));
        indexes = [indexes; temp(1)];
    end
end

n=length(S);

for i = 1:n
    if (isempty(find(indexes == i)))
        tempA = [tempA A(:,i)];
        S1 = [S1; S(i)];
    end
end

for i = 1:n
    if (isempty(find(indexes == i)))
        A1 = [A1; tempA(i,:)];
    end
end