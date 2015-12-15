clear all

xmin = 8959;
xmax = 19559;
ymin = 2100;
ymax = 9860;

% plot the top 25
min_plot = 1;
max_plot = 50;

[filter_files,nfiles] = directory_scan({'/data/TZA/dtect/2014_TZA_block_1_kusini_prestm/Misc/sas_min_eer/output_sas/horizons_top29Jan2015_0.98_3000000_25000/'},'anom'); %directory_scan({'/data/TZA/Data/interp_export/2014Grids/Depth/'},'hrd_skip');

file_split = regexp(filter_files.names, '_', 'split');


for i_file = 1:nfiles
    depth_files = regexp(file_split{i_file}(4), 'z', 'split');
    files_mat(i_file,1) = str2num(cell2mat(depth_files{1}(2)));
    area_files = regexp(file_split{i_file}(5), 'area', 'split');
    files_mat(i_file,2) = str2num(cell2mat(area_files{1}(2)));
    files_mat(i_file,3) = i_file;    
end
str_date = date;
str_date = regexprep(str_date, '-', '');
files_mat = sortrows(files_mat,[-2 3]);
for i_file = min_plot:max_plot
    file_names{i_file,1} = filter_files.names{files_mat(i_file,3)};
    dlmwrite([filter_files.path{files_mat(i_file,3)},str_date,'sorted_hors.txt'], file_names(i_file,1), '-append')
end
clear file_names
for i_file = 1:nfiles
    file_names{i_file,1} = filter_files.names{files_mat(i_file,3)};
    dlmwrite([filter_files.path{files_mat(i_file,3)},str_date,'sorted_hors_all.txt'], file_names(i_file,1), '-append')
end

for i_file = min_plot:1:max_plot
    fprintf('Plotting horizon %d of %d\n',i_file,max_plot);
    hor_file = dlmread([filter_files.path{files_mat(i_file,3)},filter_files.names{files_mat(i_file,3)}]); 
    figure(1)
    map3=pmkmp(256);
    str1{i_file} = ['\leftarrow ',num2str(hor_file(1,4))];
    arrows(i_file,1) = hor_file(1,1);
    arrows(i_file,2) = hor_file(1,2);
    if i_file == 1
        scatter(hor_file(:,1),hor_file(:,2),10,hor_file(:,3))        
    else
        hold all
        scatter(hor_file(:,1),hor_file(:,2),10,hor_file(:,3))
        hold off
    end
    
    if i_file == max_plot
        title(sprintf('%d to %d anomalous features',min_plot,max_plot))
        colormap(map3);
        colorbar
        xlabel('Inline')
        ylabel('Crossline')
        for ii_file = min_plot:1:max_plot
            hold all
            text(arrows(ii_file,1),arrows(ii_file,2),str1{ii_file})
            hold off
        end
        axis([xmin xmax ymin ymax])
    end
end
save_path = [filter_files.path{i_file}];
saveas(1,[save_path,str_date,'anom_z_img_'], 'png');

for i_file = min_plot:1:max_plot
    hor_file = dlmread([filter_files.path{files_mat(i_file,3)},filter_files.names{files_mat(i_file,3)}]); 
    figure(2)
        
    if i_file == 1
        scatter(hor_file(:,1),hor_file(:,2),10,hor_file(:,4))
    else
        hold all
        scatter(hor_file(:,1),hor_file(:,2),10,hor_file(:,4))
        hold off
    end
    
    if i_file == max_plot
        title(sprintf('%d to %d anomalous features',min_plot,max_plot))
        colorbar
        xlabel('Inline')
        ylabel('Crossline')
        for ii_file = min_plot:1:max_plot
            hold all
            text(arrows(ii_file,1),arrows(ii_file,2),str1{ii_file})
            hold off
        end
        axis([xmin xmax ymin ymax])
    end
end
saveas(2,[save_path,str_date,'anom_a_img_'], 'png');