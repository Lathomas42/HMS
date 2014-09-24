max_clusters = 20;
goodness = zeros(max_clusters,1);
for i = 1:20
    idx = kmeans(xyz,i,'dist','city','display','iter');
    [silh,h] = silhouette(xyz,idx,'city');
    goodness(i) = mean(silh);
end