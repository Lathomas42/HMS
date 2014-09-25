function [SecondOrd CosAlphaSO SecondOrdSkels] = SecondNeighb(A,S,CS)
%similar to the Neighb(A,S,CS) except also includes the second order
%connections (upstream or downstream specific) 
%does this by summing rows or columns depending on where you are according
%to what the parent neuron was connected to then dot producting that
n=length(CS);
indexes=[];
SecondOrdSkels=[];
for i=(1:n)
    tempskel=CS(i);
    if(find(S==tempskel))
        tempind=find(S==tempskel);
        indexes=[indexes; tempind(1)];
        SecondOrdSkels=[SecondOrdSkels; tempskel];
    end
end
m=length(A);
A=sign(A);
n=length(indexes);
SecondOrd=zeros(n);
CosAlphaSO=zeros(n);
for i=(1:n)
    for j=(1:n)
        indi=indexes(i);
        indj=indexes(j);
        dp=0;
        if(i>j)
            a=A(:,indi);
            b=A(:,indj);
%             a=zeros(m,1);
%             b=zeros(m,1);
            for k=(1:m)
                a=a+a(k)*A(:,k);
                b=b+b(k)*A(:,k);
            end
            a=sign(a);
            b=sign(b);
            dp=dot(a,b);
            ca=dp/sqrt(dot(a,a)*dot(b,b));
        end
        if(j>i)
            a=A(indi,:);
            b=A(indj,:);
%             a=zeros(1,m);
%             b=zeros(1,m);
            for k=(1:m)
                a=a+a(k)*A(k,:);
                b=b+b(k)*A(k,:);
            end
            a=sign(a);
            b=sign(b);
            dp=dot(a,b);
            ca=dp/sqrt(dot(a,a)*dot(b,b));
        end
        if(j==i)
            dp=1;
            ca=1;
        end
        SecondOrd(i,j)=dp;
        CosAlphaSO(i,j)=ca;
    end
end
