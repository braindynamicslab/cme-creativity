%% Eigenconnectivity analysis  
% Xie, H., Beaty, R. E., Jahanikia, S., Geniesse, C., Sonalkar, N. S., & Saggar, M. (2021). 
% Spontaneous and deliberate modes of creativity: Multitask eigen-connectivity analysis 
% captures latent cognitive modes during creative thinking. BioRxiv, 2020-12.
clear;clc;close all
load('FC_L1.mat')
% FC_z: vectorized FC matrices after FC baseline regression: 200 x 65703 
% from 25 subjects and 8 tasks and 363 ROIs 
% net_id: network affliation of 363 ROIs
% Task: corresponding task acronyms 
% Task acronym 
% AUT: alternative use task
% MW: mind wandering
% ToM: theory of Mind
% VisMot: visuomotor
% WM: working memory
[U,S,V] = svd(FC_z','econ'); % SVD decomposition of vectorized FC matrices 
n_FC = size(FC_z,1); % 200 FCs 
task_str = task(1:8); 
FC_weight = V*S; % EC weights
EigenFC = U; % EC patterns
EigenFC(:,1) = -EigenFC(:,1); % flip the sign of first EC to match the hypothesis 
FC_weight(:,1) = -FC_weight(:,1);
figure
sym = ['+','*','+','o','o','o','o','+'];
title(['Eigenconnectivity 2D projection'])
box off
h = gscatter(FC_weight(:,1),FC_weight(:,2),task,[],sym,8);
set(h,'LineWidth',1.3)
set(gcf,'Color','w')
xlabel('EC1','FontSize',18)
ylabel('EC2','FontSize',18)
set(gca,'FontSize',12)
l = legend(task_str,'Location','southeast');
l.FontSize = 16;
box off
axis off
%% 3D projection of EC weights
figure
for i = 1 : 8
    idx = i:8:n_FC;
    scatter3(FC_weight(idx,1),FC_weight(idx,2),FC_weight(idx,3),20,repmat(h(i).Color,[25 1]),sym(i));
    hold on
end
xlabel('EC1')
ylabel('EC2')
zlabel('EC3')
set(gca,'FontSize',12)
l = legend(task_str,'Location','northeast');
l.FontSize = 12;
set(gcf,'Color','w')
title(['Projection of first 3 ECs'])
%% plot first 3 eigenconnectivity thresholded at 10%;
for i = 1 : 3
    
   FC_tmp = vec2mat(EigenFC(:,i)); % convert from vectorized FC to matrix form        
   FC_vis(FC_tmp,net_id);
    set(gcf,'Color','w')
    h = colorbar;
    h.FontSize = 18;
    caxis([-0.02 0.02]);
    hold off 
    title(['EC' num2str(i)])
end
%% Task separability 
p_anova = zeros(1,n_FC);
for i = 1 : 200
    [p_anova(i)] = anova1(FC_weight(:,i),task,'off');
end
FDR = mafdr(p_anova,'bhfdr',1);
figure
plot(1:n_FC,FDR,'*')
ylim([0 1])
xlabel('EC','FontSize',14)
xticks([0:20:200])
ylabel('p-value (FDR adjusted)','FontSize',14)
set(gcf,'Color','w')
set(gca,'FontSize',14)
title('task separability')
%% plot within-network connectivity 
net2keep = [6 14 11 5 12 7 3 13]; % networks of interest
figure
for i = 1 : 2
   D_tmp = vec2mat(EigenFC(:,i));    
   [FC_sorted,label_sorted,FC_avg] = FC_vis(D_tmp,net_id,0);
   hold on
   within_net(:,i) = diag(FC_avg);
   plot(within_net(net2keep,i),'-o');
   xticklabels(label_sorted((net2keep)))
end
hold off
set(gcf,'color','w')
ylabel('AU')
xlabel('Network')
legend('EC1','EC2')
colorbar off
title('within-network connectivity')