load('adjacency.mat');
load('ApSkList.mat');
load('AxonFrags.mat');
load('InhibSkel.mat');
load('skeletons.mat');
load('somalist.mat');
load('EMidOriRGB.mat'); % for NetworkStats, from VB analsis needing connectivity
load('EMidSFTFspeed.mat'); % for NetworkStats, from VB analsis needing connectivity

RootInfo=double([skeletons somalist]);
NetworkStats
ApicalSkels = ApSkList;
DegsOfNodes=degreeOfNodes(adjacency,skeletons);
[AdjNoInh SkelNoInh]=NoInh(adjacency,skeletons,InhibSkel);
[AdjNoInhNoAx SkelNoInhNoAx]=NoInh(AdjNoInh, SkelNoInh, AxonFrags);
[AdjNoInhNoAp SkelNoInhNoAp]=NoInh(AdjNoInh, SkelNoInh, ApicalSkels);
[AdjNoInhNoAxNoAp SkelNoInhNoAxNoAp]=NoInh(AdjNoInhNoAp,SkelNoInhNoAp,AxonFrags);
[AdjNoInhNew SkelNoInhNew]=adjacencyParcer(AdjNoInh, SkelNoInh);
[AdjNoInhNoApNew SkelNoInhNoApNew]=adjacencyParcer(AdjNoInhNoAp, SkelNoInhNoAp);
[AdjNoInhNoAxNew SkelNoInhNoAxNew]=adjacencyParcer(AdjNoInhNoAx, SkelNoInhNoAx);
[AdjNoInhNoAxNoApNew SkelNoInhNoAxNoApNew]=adjacencyParcer(AdjNoInhNoAxNoAp, SkelNoInhNoAxNoAp);

Done=0;
while(Done== 0)
    [AdjNoInhNew SkelNoInhNew Done]=adjacencyParcer(AdjNoInhNew, SkelNoInhNew);
end
Done=0;
while(Done==0)
    [AdjNoInhNoApNew SkelNoInhNoApNew Done]=adjacencyParcer(AdjNoInhNoApNew, SkelNoInhNoApNew);
end
Done=0;
while(Done==0)
    [AdjNoInhNoAxNew SkelNoInhNoAxNew Done]=adjacencyParcer(AdjNoInhNoAxNew, SkelNoInhNoAxNew);
end
Done=0;
while(Done==0)
    [AdjNoInhNoAxNoApNew SkelNoInhNoAxNoApNew Done]=adjacencyParcer(AdjNoInhNoAxNoApNew, SkelNoInhNoAxNoApNew);
end
AdjNoInhUD=AdjNoInh+AdjNoInh';
AdjNoInhNewUD=AdjNoInhNew+AdjNoInhNew';


%If you want First Ord Connectivity
[FirstOrd CosAlpha FirstOrdSkels]=Neighb(AdjNoInhNew,SkelNoInhNew,ClassifiedSkeles);
%and for second ord
[SecondOrd CosAlphaSO SecondOrdSkels] = SecondNeighb(AdjNoInhNew,SkelNoInhNew,ClassifiedSkeles);


%run mod 20 times and take the highest modularity value
Groups=[];
Mod=0;
GroupsNoAp=[];
ModNoAp=0;
GroupsNoAx=[];
ModNoAx=0;
GroupsNoAxNoAp=[];
ModNoAxNoAp=0;
i=0;
while i<1000
    %undirected unweighted
%     cd 'MATLAB toolbox'
%     [tempg tempm]=modularity_und(sign(AdjNoInhNewUD));
%     [tempgna tempmna]=modularity_und(sign(AdjNoInhNoApNew+AdjNoInhNoApNew'));
%     [tempgnax tempmnax]=modularity_und(sign(AdjNoInhNoAxNew+AdjNoInhNoAxNew'));
%     [tempgnaxna tempmnaxna]=modularity_und(sign(AdjNoInhNoAxNoApNew+AdjNoInhNoAxNoApNew'));
%     cd ..
%undirected weighted
%     cd 'MATLAB toolbox'
%     [tempg tempm]=modularity_und(AdjNoInhNewUD);
%     [tempgna tempmna]=modularity_und(AdjNoInhNoApNew+AdjNoInhNoApNew');
%     [tempgnax tempmnax]=modularity_und(AdjNoInhNoAxNew+AdjNoInhNoAxNew');
%     [tempgnaxna tempmnaxna]=modularity_und(AdjNoInhNoAxNoApNew+AdjNoInhNoAxNoApNew');
%     cd ..

%   cd ..
% % %directed unweighted
%     cd 'MATLAB toolbox'
%     [tempg tempm]=modularity_dir(sign(AdjNoInhNew));
%     [tempgna tempmna]=modularity_dir(sign(AdjNoInhNoApNew));
%     [tempgnax tempmnax]=modularity_dir(sign(AdjNoInhNoAxNew));
%     [tempgnaxna tempmnaxna]=modularity_dir(sign(AdjNoInhNoAxNoApNew));
%     cd ..

% %directed weighted
%   cd 'MATLAB toolbox'
%    [tempg tempm]=modularity_dir(AdjNoInhNew);
%    [tempgna tempmna]=modularity_dir(AdjNoInhNoApNew);
%    [tempgnax tempmnax]=modularity_dir(AdjNoInhNoAxNew);
%    [tempgnaxna tempmnaxna]=modularity_dir(AdjNoInhNoAxNoApNew);
   
% % %directed weighted louvain
% %   cd 'MATLAB toolbox'
   [tempg tempm]=modularity_louvain_dir(AdjNoInhNew);
   [tempgna tempmna]=modularity_louvain_dir(AdjNoInhNoApNew);
   [tempgnax tempmnax]=modularity_louvain_dir(AdjNoInhNoAxNew);
   [tempgnaxna tempmnaxna]=modularity_louvain_dir(AdjNoInhNoAxNoApNew);

    if(tempm>Mod)
        Mod=tempm;
        Groups=tempg;
        Mod
        i
    end
    if(tempmna>ModNoAp)
        ModNoAp=tempmna;
        GroupsNoAp=tempgna;
        ModNoAp
        i
    end
    if(tempmnax>ModNoAx)
        ModNoAx=tempmnax;
        GroupsNoAx=tempgnax;
        ModNoAx
        i
    end
    if(tempmnaxna>ModNoAxNoAp)
        ModNoAxNoAp=tempmnaxna;
        GroupsNoAxNoAp=tempgnaxna;
        ModNoAxNoAp
        i
    end
    i=i+1;
end

%%
% G=sortrows([SkelNoInhNew Groups],2);
% GNA=sortrows([SkelNoInhNoApNew GroupsNoAp],2);
% GNAX=sortrows([SkelNoInhNoAxNew GroupsNoAx],2);
% GNAXNA=sortrows([SkelNoInhNoAxNoApNew GroupsNoAxNoAp],2);

% % for modularity_dir
% G=[SkelNoInhNew Groups];
% GNA=[SkelNoInhNoApNew GroupsNoAp];
% GNAX=[SkelNoInhNoAxNew GroupsNoAx];
% GNAXNA=[SkelNoInhNoAxNoApNew GroupsNoAxNoAp];

% for modularity_louvain_dir
G=[SkelNoInhNew Groups'];
GNA=[SkelNoInhNoApNew GroupsNoAp'];
GNAX=[SkelNoInhNoAxNew GroupsNoAx'];
GNAXNA=[SkelNoInhNoAxNoApNew GroupsNoAxNoAp'];

% [ReOrdNoInhAM, ReOrdNoInhSK]=newMod(AdjNoInhNew,SkelNoInhNew,Groups);
% [ReOrdNoApAM, ReOrdNoApSK]=newMod(AdjNoInhNoApNew,SkelNoInhNoApNew,GroupsNoAp);
% [ReOrdNoAxAM, ReOrdNoAxSK]=newMod(AdjNoInhNoAxNew,SkelNoInhNoAxNew,GroupsNoAx);
% [ReOrdNoAxNoApAM, ReOrdNoAxNoApSK]=newMod(AdjNoInhNoAxNoApNew,SkelNoInhNoAxNoApNew,GroupsNoAxNoAp);

% % for modularity_dir
% [ReOrdNoInhAM, ReOrdNoInhSK]=newModNoGroupBoundariesOriRGB(AdjNoInhNew,SkelNoInhNew,Groups,EMidOriRGB);
% [ReOrdNoApAM, ReOrdNoApSK]=newModNoGroupBoundariesOriRGB(AdjNoInhNoApNew,SkelNoInhNoApNew,GroupsNoAp,EMidOriRGB);
% [ReOrdNoAxAM, ReOrdNoAxSK]=newModNoGroupBoundariesOriRGB(AdjNoInhNoAxNew,SkelNoInhNoAxNew,GroupsNoAx,EMidOriRGB);
% [ReOrdNoAxNoApAM, ReOrdNoAxNoApSK]=newModNoGroupBoundariesOriRGB(AdjNoInhNoAxNoApNew,SkelNoInhNoAxNoApNew,GroupsNoAxNoAp,EMidOriRGB);

% for modularity_louvain_dir
% within group Ori ordered
[ReOrdNoInhAM, ReOrdNoInhSK]=newModNoGroupBoundariesOriRGB(AdjNoInhNew,SkelNoInhNew,Groups',EMidOriRGB);
[ReOrdNoApAM, ReOrdNoApSK]=newModNoGroupBoundariesOriRGB(AdjNoInhNoApNew,SkelNoInhNoApNew,GroupsNoAp',EMidOriRGB);
[ReOrdNoAxAM, ReOrdNoAxSK]=newModNoGroupBoundariesOriRGB(AdjNoInhNoAxNew,SkelNoInhNoAxNew,GroupsNoAx',EMidOriRGB);
[ReOrdNoAxNoApAM, ReOrdNoAxNoApSK]=newModNoGroupBoundariesOriRGB(AdjNoInhNoAxNoApNew,SkelNoInhNoAxNoApNew,GroupsNoAxNoAp',EMidOriRGB);

% % for modularity_louvain_dir
% % within group Speed ordered
% [ReOrdNoInhAM, ReOrdNoInhSK]=newModNoGroupBoundariesSpeed(AdjNoInhNew,SkelNoInhNew,Groups',EMidSFTFspeed);
% [ReOrdNoApAM, ReOrdNoApSK]=newModNoGroupBoundariesSpeed(AdjNoInhNoApNew,SkelNoInhNoApNew,GroupsNoAp',EMidSFTFspeed);
% [ReOrdNoAxAM, ReOrdNoAxSK]=newModNoGroupBoundariesSpeed(AdjNoInhNoAxNew,SkelNoInhNoAxNew,GroupsNoAx',EMidSFTFspeed);
% [ReOrdNoAxNoApAM, ReOrdNoAxNoApSK]=newModNoGroupBoundariesSpeed(AdjNoInhNoAxNoApNew,SkelNoInhNoAxNoApNew,GroupsNoAxNoAp',EMidSFTFspeed);


% %if you want to do a check to see what skels are in the same group over n
% %times use
% [modAnalysis modAnalysisUD sureCi] = sameGroup(sign(AdjNoInhNewUD),100);
% [ArMod SkelMod]=newMod(sign(AdjNoInhNewUD),SkelNoInhNew,sureCi);
% % pcolor(ArMod)

%%
figure;
h = pcolor(ReOrdNoAxAM);
set(h, 'EdgeColor', 'none');
colormap(hot);
colorbar('location','EastOutside');
set(gcf,'renderer','painters');

% co=[1 0];
% n=length(SkelMod);
% for i=2:n,
%     co=[co;[cos(2*pi*i/(n-1)),sin(2*pi*i/(n-1))]];
% end
% gplot(ArMod,co,'-*')
%% 140903 just showning deg > 1 cells with postsynaptics, rotated, quantized

selAdj = ReOrdNoAxAM(~all(ReOrdNoAxAM == 0,2),:); % keep only with postsynaptics
figure;
h = pcolor(selAdj);
set(h, 'EdgeColor', 'none');
axis equal tight
colormap(hot(7));
% can use colormapeditor to set 0
% colormap(jet(7)); % quantize color map with 7 values
colorbar('location','EastOutside');
set(gcf,'renderer','painters');
view([90 90]); % rotate 90 deg


%%
figure;
h = pcolor(ReOrdNoAxAM);
set(h, 'EdgeColor', 'none');
colormap('hot');
colorbar('location','EastOutside');
set(gca,'TickDir','out')
set(gca,'XTick',0:10:200)
set(gca,'YTick',0:10:200)
%set(gca,'XTickLabel',1:200)

%%
% EMconn_excPairwise = connected.txt for VB analysis

EMconn = PrePost(AdjNoInhNoAx,SkelNoInhNoAx);

% sorted by highest number of synapses

EMconnSynSort = sortrows(EMconn, -3);

%%
save('EMconn_excPairwise.mat','EMconn');
dlmwrite('EMconn_excPairwise.csv',EMconn,'precision',8);

%%
save('EMconn_excPairwiseSynSort.mat','EMconnSynSort');
dlmwrite('EMconn_excPairwiseSynSort.csv',EMconnSynSort,'precision',8);

%%
EMconnAll = PrePost(adjacency,skeletons);
save('EMconn_allPairwise.mat','EMconnAll');

%%
% Includes only exc-exc, deg > 1, no split axons
load('EMidOriRGB.mat');
% figure;
% h = pcolor(ReOrdNoAxAM);
% set(h, 'EdgeColor', 'none');
% colormap('hot');
% colorbar('location','EastOutside');

skelAxisOri = ReOrdNoAxSK;
% rgbNull = NaN(length(skelAxisOri),1);
% 
% skelAxisOri = [skelAxisOri rgbNull rgbNull rgbNull rgbNull];
% 
% [~,iA,iB] = intersect(skelAxisOri(:,1),EMidOriRGB(:,1));
% skelAxisOri(iA,5:8) = EMidOriRGB(iB,2:5);

figure;
%bar(skelAxis(:,5));
stem(skelAxisOri(:,5));
title('Oris in Adjacency');
xlabel('Neuron #');
ylabel('Orientation (degrees)');
%%
save('skelAxisOri_noInhAxNew.mat','skelAxisOri')
%% TODO SF, TF and speed clustering
load('EMidSFTFspeed.mat');

skelAxisSFTF = double(ReOrdNoAxSK);
Null = NaN(length(skelAxisSFTF),3);

skelAxisSFTF = [skelAxisSFTF Null];

[~,iA,iB] = intersect(skelAxisSFTF(:,1),EMidSFTFspeed(:,1));
skelAxisSFTF(iA,9:11) = EMidSFTFspeed(iB,2:4);

% SF clustering
figure;
stem(skelAxisSFTF(:,9));
title('SFs in Adjacency');
xlabel('Neuron #');
ylabel('SF (cpd)');

% TF clustering
figure;
stem(skelAxisSFTF(:,10));
title('TFs in Adjacency');
xlabel('Neuron #');
ylabel('TF (Hz)');

% Speed clustering
figure;
stem(skelAxisSFTF(:,11));
title('Speed in Adjacency');
xlabel('Neuron #');
ylabel('Speed (degrees/second)');


%% save directed modulatiry variables
save('../../figs_slides/assets/Dir/adjacency.mat','adjacency');
save('../../figs_slides/assets/Dir/skeletons.mat','skeletons');
save('../../figs_slides/assets/Dir/AdjNoInh.mat','AdjNoInh');
save('../../figs_slides/assets/Dir/SkelNoInh.mat','SkelNoInh');
save('../../figs_slides/assets/Dir/AdjNoInhNew.mat','AdjNoInhNew');
save('../../figs_slides/assets/Dir/SkelNoInhNew.mat','SkelNoInhNew');
save('../../figs_slides/assets/Dir/ReOrdNoAxAM.mat','ReOrdNoAxAM');
save('../../figs_slides/assets/Dir/ReOrdNoAxSK.mat','ReOrdNoAxSK');
saveFigure('../../figs_slides/assets/Dir/ReOrdNoAxAM.fig');