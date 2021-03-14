function [solutions] = readPos(path_file, station)

% "stations" is composed of all station reference ECEF (XYZ) coordinates
% station 1: ALGO, station 2: DUBO, station 3: WHIT, station 4: GOLD,
% station 5: WUHN, station 6: IISC
stations = [
    918129.141083288,  -4346071.33022714, 4561977.91758169;
    -417603.962870248, -4064529.8449063, 4881432.13633575;
    -2218338.20747883, -2201205.12864275, 5543057.48187619;
    -2353614.52398991, -4641385.25666469, 3676976.37155807;
    -2267750.266, 5009156.142, 3221291.898;
    1337935.78387858, 6070317.12914242, 1427877.31632779];


% *****************************************************************

pos_file = fopen(path_file,'r');
solutions = struct();
epoch_index = 1;
hdiff = 0;
vdiff = 0;
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
    
    % decimal hours (used for time series instead of just HMS)
    solutions.decimalHour(epoch_index, :) = [str2double(hms(1:2)) + str2double(hms(4:5))/60 + str2double(hms(7:11))/3600];
    
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
       
    % enu relative to reference station
    [e, n, u] = XYZ2enu(stations(station,1), stations(station,2), stations(station,3), X, Y, Z, lat_degree, lon_degree);
    solutions.enu(epoch_index, :) = [e, n, u];
  
    % horizontal error
    hor_error = sqrt(e^2 + n^2);
    solutions.hor_error(epoch_index, :) = hor_error;
    
    % vertical error
    vert_error = abs(u);
    solutions.vert_error(epoch_index, :) = vert_error;
    
    % sum of differences used for horizontal RMSE
    hdiff = hdiff + hor_error^2;
    
    % sum of differences used for vertical RMSE
    vdiff = vdiff + vert_error^2;
    
    epoch_index = epoch_index + 1;
end
    
% horizontal root mean square error
h_RMSE = sqrt(hdiff/epoch_index);
solutions.h_RMSE = h_RMSE;

% vertical root mean square error
v_RMSE = sqrt(vdiff/epoch_index);
solutions.v_RMSE = v_RMSE;

% time to reach 5cm horizontal error
solutions.h_error_5cm = 0;
terminate = 1;
k = 1;
while terminate == 1
    if solutions.hor_error(k) <= 0.05
         solutions.h_error_5cm = solutions.decimalHour(k);
         terminate = -1;
    elseif k == length(solutions.hor_error)
         terminate = -1;
         solutions.h_error_5cm = NaN;
    else
        k = k+1;
    end
end


% time to reach 5cm vertical error
solutions.v_error_5cm = 0;
terminate = 1;
k = 1;
while terminate == 1
    if solutions.vert_error(k) <= 0.05
        solutions.v_error_5cm = solutions.decimalHour(k);
        terminate = -1;
    elseif k == length(solutions.vert_error)
        terminate = -1;
        solutions.v_error_5cm = NaN;
    end
    k = k+1;
end

fclose(pos_file);

% ************* plotting ************************
% ********** GDOP and Number of Satellites ******
% figure('Position', [50 50 1000 600])
% title(sprintf('GDOP and Number of Satellites vs Time for %s', path_file), 'Interpreter', 'none');
% yyaxis right
% plot(solutions.decimalHour, solutions.GDOP);
% ylabel('GDOP'); ylim([0 5])
% yyaxis left
% plot(solutions.decimalHour, solutions.num_sat);
% ylabel('Number of Satellites'); ylim([0 25])
% grid on; xlabel('Time (Hours)')
 
% ********* horizontal and vertical error vs time *************
% figure('Position', [50 50 1000 600])
% subplot(2,1,1)
% plot(solutions.decimalHour, solutions.hor_error)
% title(sprintf('Horizontal Error vs Time for %s', path_file), 'Interpreter', 'none');
% ylabel('Horizontal Error (m)'); ylim([0 0.5]); grid on; xlabel('Time (Hours)')
% % annotation('textbox', [0.5, 0.8, 0.1, 0.1], 'String', "Time to reach 5 cm horizontal error: " + h_error_5cm(1) +"h " + h_error_5cm(2)+"m " + h_error_5cm(3)+"s");
% subplot(2,1,2)
% plot(solutions.decimalHour, solutions.vert_error)
% title(sprintf('Vertical Error vs Time for %s', path_file), 'Interpreter', 'none');
% ylabel('Vertical Error (m)'); ylim([0 0.5]); grid on; xlabel('Time (Hours)')
% % annotation('textbox', [0.5, 0.3, 0.1, 0.1], 'String', "Time to reach 5 cm vertical error: " + v_error_5cm(1) +"h " + v_error_5cm(2)+"m " + v_error_5cm(3)+"s");

end