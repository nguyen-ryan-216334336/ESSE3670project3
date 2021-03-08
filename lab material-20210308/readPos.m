function [solutions] = readPos(path_file)

pos_file = fopen(path_file,'r');
solutions = struct();
epoch_index = 1;
tline = fgetl(pos_file);
while ~contains(tline, 'DIR'),    tline = fgetl(pos_file); end % Skip the header

split_line = strsplit(tline);
index_DOY = find(contains(split_line,'DAYofYEAR'));
index_YMD = find(contains(split_line,'YEAR-MM-DD'));
index_HMS = find(contains(split_line,'HR:MN:SS.SS'));
index_numSat = find(contains(split_line,'NSV'));
index_GDOP = find(contains(split_line,'GDOP'));
% index_clk = find(contains(split_line,'CLK(ns)'));
% index_TZD = find(contains(split_line,'TZD(m)'));
index_lat_d = find(contains(split_line,'LATDD'));
index_lat_m = find(contains(split_line,'LATMN'));
index_lat_s = find(contains(split_line,'LATSS'));
index_lon_d = find(contains(split_line,'LONDD'));
index_lon_m = find(contains(split_line,'LONMN'));
index_lon_s = find(contains(split_line,'LONSS'));
index_dhgt = find(contains(split_line,'DHGT(m)'));
index_hgt = find(contains(split_line,'HGT(m)'));
index_hgt = index_hgt(index_hgt~=index_dhgt);

while ~feof(pos_file)
    tline = fgetl(pos_file);
    split_line = strsplit(tline);
    solutions.DOY(epoch_index,1) = str2double(split_line(index_DOY));
    ymd = split_line{index_YMD};
    solutions.date(epoch_index, :) = [str2double(ymd(1:4)) str2double(ymd(6:7)) str2double(ymd(9:10))];
    hms = split_line{index_HMS};
    solutions.time(epoch_index, :) = [str2double(hms(1:2)) str2double(hms(4:5)) str2double(hms(7:11))];
    
    solutions.num_sat(epoch_index, 1) = str2double(split_line(index_numSat));
    solutions.GDOP(epoch_index, 1) = str2double(split_line(index_GDOP));
    %     solutions.receiver_clock(epoch_index, 1) = str2double(split_line(index_clk));
    %     solutions.TZD(epoch_index, 1) = str2double(split_line(index_TZD));
    lat_d = str2double(split_line(index_lat_d));
    lat_m = str2double(split_line(index_lat_m));
    lat_s = str2double(split_line(index_lat_s));
    signe = sign(lat_d);
    lat_degree = lat_d + signe*lat_m/60 + signe*lat_s/3600;
    
    lon_d = str2double(split_line(index_lon_d));
    lon_m = str2double(split_line(index_lon_m));
    lon_s = str2double(split_line(index_lon_s));
    signe = sign(lon_d);
    lon_degree = lon_d + signe*lon_m/60 + signe*lon_s/3600;
    
    height = str2double(split_line(index_hgt));
    
    [X, Y, Z] = llh2XYZ(lat_degree, lon_degree, height);
    
    solutions.llh(epoch_index, :) =  [lat_degree lon_degree height];
    solutions.ECEF(epoch_index, :) = [X, Y, Z];
    epoch_index = epoch_index + 1;
end

fclose(pos_file);

end