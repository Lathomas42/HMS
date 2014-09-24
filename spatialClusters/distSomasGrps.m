load('grps.mat')
load('skeletons.mat')
load('sknumb.mat')
load('somalist.mat')

somaskels = [somalist skeletons];
somaskels_gephi = [somaskels ismember(somaskels(:,6),sknumb)];
somaskels_gephi = sortrows(somaskels_gephi,6);
sknumb_grps = [sknumb grps];
sknumb_grps = sortrows(sknumb_grps,1);
somaskels_gephi = somaskels_gephi(somaskels_gephi(:,7)==1,:);
somaskels_gephi_grps = [somaskels_gephi, sknumb_grps(:,2)];
soma_xyz = somaskels_gephi_grps(:,2:4);
temp_pd = pdist(soma_xyz);
dist_mat = squareform(temp_pd);
same_grp_mat = zeros(length(dist_mat));
dif_grp_mat = zeros(length(dist_mat));
for i = 1:length(dist_mat)
    for j = i:length(dist_mat)
        if(i~=j)
            same_grp_mat(i,j) = somaskels_gephi_grps(i,8) == somaskels_gephi_grps(j,8);
            dif_grp_mat(i,j) = somaskels_gephi_grps(i,8) ~= somaskels_gephi_grps(j,8);
        end
    end
end

dists_same = dist_mat(same_grp_mat==1);
dists_dif = dist_mat(dif_grp_mat==1);

figure;
hold on
[dif_n,dif_c]=hist(dists_dif,[0:.25:4.5]*10^5);
[same_n,same_c]=hist(dists_same,[0:.25:4.5]*10^5);
bar(same_c,same_n/max(same_n),.5,'r');
bar(dif_c-3125,dif_n/max(dif_n),.5,'b');