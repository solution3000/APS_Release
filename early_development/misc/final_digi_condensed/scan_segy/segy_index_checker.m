function segy_index_checker(seismic_mat_path)

seismic = segy_read_binary(seismic_mat_path);
scan_val = 1;
% Open the seismic segy file
    
    % Pick 1/10 random locations
    n_locations = floor(size(seismic.trace_ilxl_bytes,1)/10);
    random_rows = randi(size(seismic.trace_ilxl_bytes,1),n_locations,1);
    
    for ii = 1:1:n_locations
        fid = fopen(char(seismic.filepath),'r','b');
        fseek(fid,seismic.trace_ilxl_bytes(random_rows(ii),3)-240,'bof');
        
        if seismic.file_type == 1
            % Convert traces from IBM32FP read as UINT32 into IEEE64FP (doubles)
            traces_tmp = fread(fid,[60+seismic.n_samples,1],'*uint32');
            ilxl_read = traces_tmp(48:49,:)'; % what happens if the inline and crossline are not in this location        
            ilxl_scan = seismic.trace_ilxl_bytes(random_rows(ii),1:2);
            if ilxl_scan ~= double(ilxl_read)
                fprintf('\nScan file is invalid, row %d\n',random_rows(ii));
                scan_val = 0;
            end
       elseif seismic.file_type == 2 
            disp('This seismic file type is not currently supported. Please speak to Charles Jones.');
       elseif seismic.file_type == 5
            % Traces are IEEE32FP (doubles)   
            traces = fread(fid,[60+seismic.n_samples,1],strcat(num2str(seismic.n_samples),'*float32'));
            trace_headers = typecast(single(reshape(traces(1:60,:),1,60)),'int32');  
            trace_headers = reshape(trace_headers,60,1);
            ilxl_read = trace_headers(48:49,:)';        
            ilxl_scan = seismic.trace_ilxl_bytes(random_rows(ii),1:2);
            
            if ilxl_scan ~= double(ilxl_read)
                fprintf('\nScan file is invalid, row %d\n',random_rows(ii));
                scan_val = 0;
            end
        end 
        fclose(fid);
    end
    if scan_val == 1
        fprintf('\nChecked %d random locations and scan file is valid\n',n_locations);
    end
end