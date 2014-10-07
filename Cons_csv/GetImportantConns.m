%% Loading
clear
load('connectors.mat')
load('EMidOriRGBneuronIDSFTFspeed.mat')

%% Variable setting
tot_cons = connectors;
classified_skels = EMidOriRGBneuronIDSFTFspeed(:,1);
tot_skels = unique(connectors(:,2:3));
tot_skels = tot_skels(~isnan(tot_skels));
un_class_skels = setdiff(tot_skels,classified_skels);

%% get all cons involving 2 classified skels or just1

cons_class_row2 = tot_cons(ismember(tot_cons(:,2),classified_skels),:);
cons_class_row3 = tot_cons(ismember(tot_cons(:,3),classified_skels),:);

cons_both_class = cons_class_row2(ismember(cons_class_row2(:,1),cons_class_row3(:,1)),:);
cons_just_one_2 = cons_class_row2(~ismember(cons_class_row2(:,1),cons_class_row3(:,1)),:);
%cons_just_one = [cons_just_one; cons_class_row3(~ismember(cons_class_row3(:,1),cons_class_row2(:,1)),:)];
cons_just_one_3 = cons_class_row3(~ismember(cons_class_row3(:,1),cons_class_row2(:,1)),:);
%% get repeated skeletons (non_classified)

% cons_just_one_unclass_L = cons_just_one(ismember(cons_just_one(:,2),un_class_skels),:);
% cons_just_one_unclass_R = cons_just_one(ismember(cons_just_one(:,3),un_class_skels),:);
% rep_cons_unclass_L = cons_just_one_unclass_L(ismember(cons_just_one_unclass_L(:,2),repval(cons_just_one_unclass_L(:,2))),:);
% rep_cons_unclass_R = cons_just_one_unclass_R(ismember(cons_just_one_unclass_R(:,3),repval(cons_just_one_unclass_L(:,3))),:);
cons_unclass_rep_3 = cons_just_one_3(ismember(cons_just_one_3(:,2),cons_just_one_2(:,3)),:);
cons_unclass_rep_2 = cons_just_one_2(ismember(cons_just_one_2(:,3),cons_just_one_3(:,2)),:);
% cons_just_one_unclass_skels = [cons_just_one_unclass(:,2);cons_just_one_unclass(:,3)];
% rep_skels = repval(cons_just_one_unclass_skels(~ismember(cons_just_one_unclass_skels,classified_skels)));
% cons_just_one_unclass = cons_just_one_unclass(cons_just_one_unclass(:,3)

cons_to_seed = [cons_both_class;cons_unclass_rep_2;cons_unclass_rep_3];