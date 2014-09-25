function [ArMod SkelMod]=newMod(A,S,M)
%newMod(A,S,M) takes input values of adjacency matrix=A, skeleton list=S for
%said matrix and the modularity_dir(A) =M
%then orders the rows and columns by modularity group
n=length(S);
ngroups=max(M);
noutof=[];
for i=(1:ngroups)
    noo=length(find(M~=i));
    while (isempty(find(noutof==noo))==0)
        noo=noo+1;
    end
    noutof=[noutof;noo];
end
OtherGrps=[];

for i=(1:n)
    OtherGrps=[OtherGrps; noutof(M(i))];
end
SkelModa=[S,M,reshape(1:n,n,1) OtherGrps];
ReOrderedSkel=sortrows(SkelModa,4);
ArMod=[];
tempAr=[];
for i=(1:n)
    index=ReOrderedSkel(i,3);
    tempAr=[tempAr,A(:,index)];
end
for i=(1:n)
    index=ReOrderedSkel(i,3);
    ArMod=[ArMod;tempAr(index,:)];
end
SkelMod=ReOrderedSkel;
line=1;
grpnmb=1;
i=1;
lastsize=0;
val=3 %line color 0 or 3;
while i<=n
    if (SkelMod(i,2)~=grpnmb|i==n)
        grpnmb=SkelMod(i,2);
        lastsize=i-line;
        for j=(line:(i-1))
            %up
            if(ArMod(i-1,j)==0)
                ArMod(i-1,j)=val;
            end
            %right
            if(ArMod(j,i-1)==0)
                ArMod(j,i-1)=val;
            end
            %left
            if(ArMod(j,line)==0)
                ArMod(j,line)=val;
            end
        end
        line=i;
    end
    if SkelMod(i,2)==grpnmb
        %bottom
        if ArMod(line,i)==0
            ArMod(line,i)=val;
        end
    end
    i=i+1;
end