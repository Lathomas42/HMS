function [FirstOrd CosAlpha FirstOrdSkels]=Neighb(A,S,CS)
%Neigh(A,S,CS) takes adjacency matrix (A) and its correpsonding Skeleton
%List (S) and makes a matrix for the first order shared connections of the
%skeletons listed in a list of connected Skeletons (CS)
%does this by dot producting skeletons rows with eachother (use AdjNoInhNew
%to ignore inh and low degree(<=1 nodes)
n=length(CS);
indexes=[];
FirstOrdSkels=[];
A=sign(A);
for i=(1:n)
    tempskel=CS(i);
    if(find(S==tempskel))
        tempind=find(S==tempskel);
        indexes=[indexes; tempind(1)];
        FirstOrdSkels=[FirstOrdSkels; tempskel];
    end
end
n=length(FirstOrdSkels);
FirstOrd=zeros(n);
CosAlpha=zeros(n);
for i=(1:n)
    for j=(1:n)
        dp=0;
        ca=1/0;
        indi=indexes(i);
        indj=indexes(j);
        if(i>j)
            a=A(:,indi);
            b=A(:,indj);
            dp=dot(a,b);
            ca=dp/sqrt(dot(a,a)*dot(b,b));

        end
        if(j>i)
            a=A(indi,:);
            b=A(indj,:);
            dp=dot(a,b);
            ca=dp/sqrt(dot(a,a)*dot(b,b));

        end
        if(i==j)
            ca=1;
        end
        FirstOrd(i,j)=dp;
        CosAlpha(i,j)=ca;

    end
end