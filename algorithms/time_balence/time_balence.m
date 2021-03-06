function [ trim_data_filt scalepos ] = time_balence( trim_data )
%% ------------------ Disclaimer  ------------------
% 
% BG Group plc or any of its respective subsidiaries, affiliates and 
% associated companies (or by any of their respective officers, employees 
% or agents) makes no representation or warranty, express or implied, in 
% respect to the quality, accuracy or usefulness of this repository. The code
% is this repository is supplied with the explicit understanding and 
% agreement of recipient that any action taken or expenditure made by 
% recipient based on its examination, evaluation, interpretation or use is 
% at its own risk and responsibility.
% 
% No representation or warranty, express or implied, is or will be made in 
% relation to the accuracy or completeness of the information in this 
% repository and no responsibility or liability is or will be accepted by 
% BG Group plc or any of its respective subsidiaries, affiliates and 
% associated companies (or by any of their respective officers, employees 
% or agents) in relation to it.
%% ------------------ License  ------------------ 
% GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007
%% github
% https://github.com/AnalysePrestackSeismic/
%% ------------------ FUNCTION DEFINITION ---------------------------------
% time_balence: function to scales a gather or setion from the envelope 
% of the amplitudes to make the envelope tend to the value +/- 2000
%   Arguments:
%       trim_data = a matrix containing a pre-stack seismic gather 
%	[rows: samples, cols: tertiary key] 
%   
%   Outputs:
%       trim_data_filt = scaled version of trim_data 
%	scalepos = amount of scaling applied for undo
%
%   Writes to Disk:
%       nothing 

filt_smo =  ones(1,3)/3;
filttraces = [1 2 2 3 3 3 2 2 1]/19;

% find the max of the data across the gather and smooth
td_max = max(trim_data,[],2);
td_max =  conv(td_max,filttraces,'same');

% find the first and second derivatives of the max
max_1st_deriv = diff(td_max);
max_2nd_deriv = diff(td_max,2);

% apply a signum filter to get samples at zero crossings and make only 1
% and 0's
sign_1_deriv = sign(max_1st_deriv);
sign_1_deriv(sign_1_deriv == 0) = 1;

% find the point where sign of 1st deriv changes
diffsign = diff(sign_1_deriv);

% set the point to zro where second derivative is positive and pad, this
% finds the peaks in the max dataset
diffsign(sign(max_2nd_deriv) > 0) = 0;
diffsign = [1;diffsign];

%use the peaks logical to get the values and indexes to then interpolate to
%make and envelope which includes the signal, but preserves the wiggles in
%the dataset
itpsval = td_max(diffsign < 0);
itpslocs = single(1:size(trim_data,1))';
itpslocsin = itpslocs(diffsign < 0);

% interpolate to make the envelope only using fast linear interp
posenv = double(interp1q(itpslocsin,itpsval,itpslocs));

% now make the scaler to make envlope all fit the value 2000
%scalepos = 2000 ./ posenv;
scalepos = bsxfun(@rdivide,2000,posenv);
scalepos(isnan(scalepos)) = 0;

% apply a median filter to remove sudden jumps in scaling and the small
% averaging to make sure it is a smooth scalar
scalepos = medfilt3nt(scalepos,15,0);
scalepos =  conv(scalepos,filt_smo,'same');


%Apply the scaling to the input data
trim_data_filt = bsxfun(@times,scalepos,trim_data);

%     td_max = max(trim_data,[],2);
%     td_max =  conv(td_max,filt_smo,'same');
% 
%     cjdiff2 = diff(td_max,2);
%     cjdiff = diff(td_max);
%     cjdiffb = sign(cjdiff);
%     cjdiffb(cjdiffb == 0) = 1;
%     diffsign = diff(sign(cjdiff));
%     cjdiff2sign = sign(cjdiff2);
%     diffsign(cjdiff2sign > 0) = 0;
%     diffsign = [1;diffsign];
%     %td_max(diffsign == 0) = 0;
%     itpsval = td_max(diffsign < 0);
%     itpslocs = single(1:size(trim_data,1))';
%     itpslocsin = itpslocs(diffsign < 0);
%     posenv = double(interp1q(itpslocsin,itpsval,itpslocs));
%     %scalepos = 2000 ./ posenv;
%     scalepos = bsxfun(@rdivide,2000,posenv);
%     scalepos(isnan(scalepos)) = 0;
%     scalepos =  conv(scalepos,filttraces,'same');
%     scaltd = bsxfun(@times,scalepos,trim_data);

end

