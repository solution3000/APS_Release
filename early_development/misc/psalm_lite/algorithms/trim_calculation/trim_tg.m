function [trim_data, trim_shift] = trim_caculation(seismic_mat_path,data,shift,zsmooth)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    tmp_seismic = fread(fopen(seismic_mat_path,'r'),'double');
    
    [n_samples,n_traces] = size(data);
     
    trim_data = data;
    trim_data_filt = fliplr(medfilt1(data,5,[],2));
    
    time = repmat((0:4:(n_samples-1)*4)',1,n_traces);
    
    S = (1/zsmooth)*spdiags(repmat([(1:1:zsmooth),(zsmooth-1:-1:1)],n_samples,1),[(-zsmooth+1:1:0),(1:1:zsmooth-1)],n_samples,n_samples);
    
    for ii = 2:n_traces
                
        count = 0;

        t1 = trim_data_filt(:,ii-1);
        T1 = S*spdiags(t1,0,n_samples,n_samples);
        
        t2 = trim_data_filt(:,ii);
        
        phase_shifts = bsxfun(@times,(-shift:1:shift),(1/1000).*2.*pi.*repmat((0:250/(n_samples-1):250)',1,1+2*shift));
        t2_shifts = ifft(bsxfun(@times,fft(t2),exp(1i*phase_shifts)),'symmetric');
   
        for kk = -shift:1:shift
            
            count = count+1;
                                  
            T2 = S*spdiags(t2_shifts(:,count),0,n_samples,n_samples);

            det_coef(:,count) =  ((T1*t2_shifts(:,count)).*(T2*t1))./((T1*t1).*(T2*t2_shifts(:,count)));     

        end
        
        [~,idx] = max(det_coef');
        trim_shift(:,ii-1) = idx'-shift-1;
               
    end
    
    trim_shift = [zeros(n_samples,1),cumsum(fliplr(trim_shift),2)];
    trim_shift(data==0) = 0;
    
    for ii = 1:n_traces
        trim_data(:,ii) = interp1(time(:,ii),data(:,ii),time(:,ii)-trim_shift(:,ii),'linear',0);
    end
      
end