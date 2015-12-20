fhandle = @wamp;

filenames{1,1} = '/segy/MAD/inversion_test/test_data/input_angle_stacks/10_nears_sq.bin';
filenames{2,1} = '/segy/MAD/inversion_test/test_data/input_angle_stacks/20_mids_sq.bin';
filenames{3,1} = '/segy/MAD/inversion_test/test_data/input_angle_stacks/30_fars_sq.bin';

bitsperbyte = 4;

nil = 768;
nxl = 1687;
nt = 1626;

nil_stepout = 250;
nxl_stepout = 250;
nt_stepout = 250;

il_olap = 0.50;
xl_olap = 0.48;
t_olap = 0.50;

[wvol] = minivolread(fhandle,filenames,bitsperbyte,nil,nxl,nt,nil_stepout,nxl_stepout,nt_stepout,il_olap,xl_olap,t_olap);