function [eds] = PrePost(Adj,Skels)
%PREPOST inputs adjacency and skeleton outputs [presynaptic postsynaptic
%degreebetween]
%   outputs [<from><to><amountbetween>]
n=length(Skels);
eds=[];
for i=(1:n)
    for j=(1:n)
        if Adj(i,j)~=0
            eds=[eds; Skels(i) Skels(j) Adj(i,j)];
        end
    end
end

end

