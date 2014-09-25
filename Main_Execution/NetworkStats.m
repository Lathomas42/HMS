n=length(skeletons);
adjacencyUW=sign(adjacency);


%this list of initialClassifiedSkeles is the skeletons that have been
%functionally classified the inhibskels generates a list of inhibitory
%skeletons based on the inhibsynapse from the csv file
%initialClassifiedSkeles=[226587,74410,222688,29376,232840,9586,14877,38321,53858,66981,72324,1403212,91013,92504,466695,103694,137800,114748,141822,139314,141721,162230,292644,162890,61056,176871,173246,189930,193636];
% initialClassifiedSkeles=EMidOriRGB(:,1)';
initialClassifiedSkeles=union(EMidOriRGB(:,1),EMidSFTFspeed(:,1))'; % adding SF, TF, speed
%InhibList from GetInhibList.m
%InhibSkels = InhibList;
%InhibSkels = [];
%m=length(InhibSynapse);
% for i=(1:m)
%     if((InhibSynapse(i,2)==1)&&(InhibSynapse(i,1)~=0)&&(isempty(find(InhibSkels==InhibSynapse(i,1)))==1))
%         InhibSkels=[InhibSkels;InhibSynapse(i,1)];
%     end
% end
%Apical Skeletons
% ApicalSkels=[];
% m=length(ApicalSynapse);
% for i=(1:m)
%     if(isempty(find(skeletons==ApicalSynapse(i,1)))==0) 
%         if((ApicalSynapse(i,2)==1)&&(ApicalSynapse(i,1)~=0)&&(isempty(find(ApicalSkels==ApicalSynapse(i,1)))==1)&&(RootInfo(find(skeletons==ApicalSynapse(i,1)),2)==0))
%             ApicalSkels=[ApicalSkels;ApicalSynapse(i,1)];
%         end
%     end
% end
%this peice goes through the classified skeletons and sees which are in the
%skeletons list(or are connected to anything)
count = length(initialClassifiedSkeles);
ClassifiedSkeles=initialClassifiedSkeles;
for i=(1:count)
    if(isempty(find(skeletons==initialClassifiedSkeles(i))))
        index=find(ClassifiedSkeles==initialClassifiedSkeles(i));
        ClassifiedSkeles(index)=[];
    end
end
clear('m','n','index','i','count')

% count=length(ClassifiedSkeles);
% firstOrderMatrix=zeros(count);
% firstOrderMatrixNops=zeros(count);
% secondOrderMatrix=zeros(count);
% secondOrderMatrixNops=zeros(count);
% sumin=sum(adjacencyUW,1);
% sumout=sum(adjacencyUW,2);
% for i=(1:count)
%     for j=(1:count)
%         if(i~=j)
%             fi=find(skeletons==ClassifiedSkeles(i));
%             fj=find(skeletons==ClassifiedSkeles(j));
%             indexi = fi(1);
%             indexj = fj(1);
%             totalin=sumin(indexi)+sumin(indexj);
%             totalout=sumout(indexi)+sumout(indexj);
%             len = length(adjacencyUW);
%             outshared=dot(adjacencyUW(indexi,:),adjacencyUW(indexj,:));
%             inshared=dot(adjacencyUW(:,indexi),adjacencyUW(:,indexj));
%             firstOrderMatrix(i,j)=(inshared+outshared)/(totalin+totalout-inshared-outshared);
%             firstOrderMatrixNops(i,j)=(inshared+outshared);      
%         end
%         if(i==j)
%             firstOrderMatrix(i,j)=1;
%             firstOrderMatrixNops(i,j)=1;
%         end
%     end
% end
% 
% 




%these are the elements with Total (in+out) degree >1 aka everything that
%is important to connectivity
% degreeBig = find(totalDegree(:,2)>1);
% %first I will go through and copy the columns into a new temp matrix
% n=length(degreeBig);
% impCol =[];
% impAdj=[];
% impSkel=[]; %gives indexing for impAdj
% for i=(1:n)
%     temp = degreeBig(i);
%     impCol=[impCol,adjacency(:,temp)];
%     impSkel=[impSkel;skeletons(temp)];
% end
% %now i will make impAdj just the important rows form impCol
% for i=(1:n)
%     temp = degreeBig(i);
%     impAdj=[impAdj;impCol(temp,:)];
% end
% %make impAdj Symmetric and Unweighted
% impAdj=sign(impAdj + impAdj')
% %commands to reorder for mod
% %[On Ar] =reorder_mod(impAdj,modularity_dir(impAdj));
% %pcolor(Ar)

% inDegree=[skeletons,reshape(sum(adjacency),n,1)];
% outDegree=[skeletons,reshape(sum(adjacency'),n,1)];
% totalDegree =[skeletons,reshape(sum(adjacency'),n,1)+reshape(sum(adjacency),n,1)];
% co=[1 0];
% for i=2:n,
%     co=[co;[cos(2*pi*i/(n-1)),sin(2*pi*i/(n-1))]];
% end
% gplot(adjacencyUW,co,'-*')
