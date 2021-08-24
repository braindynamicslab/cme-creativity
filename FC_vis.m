function [FC_sorted,label_sorted,FC_avg] = FC_vis(FC,label,show_image)
% author: OX 07/18/19
% reorder and visualize FC matrices
if nargin < 3
    show_image = 1;
end
[label_sorted,~,ic] = unique(label);
[ic_s,ind_s] = sort(ic);
ic_s_uni = unique(ic_s);
FC_sorted = FC(ind_s,ind_s);
c = [0.9375    1.0000    0.0625
    0         0    0.5625
    1.0000    0.5000         0
    0    0.2000    0.6000
    1.0000    0.1250         0
    0.5625    1.0000    0.4375
    0.7500         0         0
    1.0000    0.3125         0
    0         0    0.7500
    0    1.0000    1.0000
    0.7500    1.0000    0.2500
    0.9375         0         0
    0    0.5000    1.0000
    0.3750    1.0000    0.6250]; % colormap
FC_avg = zeros(length(ic_s_uni),length(ic_s_uni));
for i = 1 : length(ic_s_uni)
    for j = 1 : length(ic_s_uni)
        idx1 = ic_s == i;
        idx2 = ic_s == j;
        FC_avg(i,j) = nanmean(nanmean(FC_sorted(idx1,idx2)));
    end
end
if show_image
    figure
    fz = 20; %fontsize
    imagesc(FC_sorted)
    colormap(parula)
    for i = 1 : length(ic_s_uni)
        xlim1 = find(ic_s==i,1,'first')-1;
        xlim2 = find(ic_s==i,1,'last');
        line([0.5 0.5],[xlim1 xlim2-0.3],'Color',c(i,:),'LineWidth',4)
        line([xlim1 xlim1],[xlim1 xlim2],'Color',c(i,:),'LineWidth',2)
        line([xlim2 xlim2],[xlim1 xlim2],'Color',c(i,:),'LineWidth',2)
        line([xlim1 xlim2],[xlim1 xlim1],'Color',c(i,:),'LineWidth',2)
        line([xlim1 xlim2],[xlim2 xlim2],'Color',c(i,:),'LineWidth',2)
        t = text((xlim1+xlim2)/2-5,size(FC_sorted,1)+10,label_sorted{i});
        t.FontSize = fz;            set(t,'Rotation',-45);
        t = text(-5,(xlim1+xlim2)/2,label_sorted{i});
        set(t, 'horizontalAlignment', 'right')
        t.FontSize = fz;
        set(gca,'xtick',[])
        set(gca,'ytick',[])
    end

end
