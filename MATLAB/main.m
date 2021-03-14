function [] = main()

% main is used to analyze the effect of data arc length and the effect of
% the data processing mode

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

% **************** enter filenames here **************************
station1 = 'ALGO00CAN_2_24hr_kin.pos'; 
station2 = 'DUBO00CAN_2_24hr_kin.pos'; 
station3 = 'WHIT00CAN_2_24hr_kin.pos'; 
station4 = 'GOLD00USA_2_24hr_kin.pos'; 
station5 = 'WUHN00CHN_2_24hr_kin.pos'; 
station6 = 'IISC00IND_2_24hr_kin.pos';
station7 = 'ALGO00CAN_2_24hr_static.pos'; 
station8 = 'DUBO00CAN_2_24hr_static.pos'; 
station9 = 'WHIT00CAN_2_24hr_static.pos'; 
station10 = 'GOLD00USA_2_24hr_static.pos'; 
station11 = 'WUHN00CHN_2_24hr_static.pos'; 
station12 = 'IISC00IND_2_24hr_static.pos';
station13 = 'ALGO00CAN_2_30min_kin.pos';
station14 = 'DUBO00CAN_2_30min_kin.pos'; 
station15 = 'WHIT00CAN_2_30min_kin.pos'; 
station16 = 'GOLD00USA_2_30min_kin.pos'; 
station17 = 'WUHN00CHN_2_30min_kin.pos'; 
station18 = 'IISC00IND_2_30min_kin.pos'; 
station19 = 'ALGO00CAN_2_30min_static.pos'; 
station20 = 'DUBO00CAN_2_30min_static.pos'; 
station21 = 'WHIT00CAN_2_30min_static.pos'; 
station22 = 'GOLD00USA_2_30min_static.pos'; 
station23 = 'WUHN00CHN_2_30min_static.pos'; 
station24 = 'IISC00IND_2_30min_static.pos'; 
station25 = 'ALGO00CAN_3_24hr_kin.pos'; 
station26 = 'DUBO00CAN_3_24hr_kin.pos'; 
station27 = 'WHIT00CAN_3_24hr_kin.pos'; 
station28 = 'GOLD00USA_3_24hr_kin.pos'; 
station29 = 'WUHN00CHN_3_24hr_kin.pos'; 
station30 = 'IISC00IND_3_24hr_kin.pos'; 
station31 = 'ALGO00CAN_3_24hr_static.pos'; 
station32 = 'DUBO00CAN_3_24hr_static.pos'; 
station33 = 'WHIT00CAN_3_24hr_static.pos'; 
station34 = 'GOLD00USA_3_24hr_static.pos'; 
station35 = 'WUHN00CHN_3_24hr_static.pos'; 
station36 = 'IISC00IND_3_24hr_static.pos';
station37 = 'ALGO00CAN_3_30min_kin.pos';
station38 = 'DUBO00CAN_3_30min_kin.pos'; 
station39 = 'WHIT00CAN_3_30min_kin.pos'; 
station40 = 'GOLD00USA_3_30min_kin.pos'; 
station41 = 'WUHN00CHN_3_30min_kin.pos'; 
station42 = 'IISC00IND_3_30min_kin.pos'; 
station43 = 'ALGO00CAN_3_30min_static.pos'; 
station44 = 'DUBO00CAN_3_30min_static.pos'; 
station45 = 'WHIT00CAN_3_30min_static.pos'; 
station46 = 'GOLD00USA_3_30min_static.pos'; 
station47 = 'WUHN00CHN_3_30min_static.pos'; 
station48 = 'IISC00IND_3_30min_static.pos'; 

%data lists
data = {station1;station2;station3;station4;station5;station6;station7;station8;station9;station10;
    station11;station12;station13;station14;station15;station16;station17;station18;station19;station20;
    station21;station22;station23;station24;station25;station26;station27;station28;station29;station30;
    station31;station32;station33;station34;station35;station36;station37;station38;station39;station40;
    station41;station42;station43;station44;station45;station46;station47;station48};

%stations
stationALGO = {station1;station7;station13;station19;station25;station31;station37;station43};
stationDUBO = {station2;station8;station14;station20;station26;station32;station38;station44};
stationWHIT = {station3;station9;station15;station21;station27;station33;station39;station45};
stationGOLD = {station4;station10;station16;station22;station28;station34;station40;station46};
stationWUHN = {station5;station11;station17;station23;station29;station35;station41;station47};
stationIISC = {station6;station12;station18;station24;station30;station36;station42;station48};

%data arc
station24H = {station1;station2;station3;station4;station5;station6;station7;station8;station9;station10;
    station11;station12;station25;station26;station27;station28;station29;station30;
    station31;station32;station33;station34;station35;station36};

station30MIN = {station13;station14;station15;station16;station17;station18;station19;station20;
    station21;station22;station23;station24;station37;station38;station39;station40;
    station41;station42;station43;station44;station45;station46;station47;station48};

%mode
stationKIN = {station1;station2;station3;station4;station5;station6;station13;station14;station15;
    station16;station17;station18;station25;station26;station27;station28;station29;station30;
    station37;station38;station39;station40;station41;station42};

stationSTAT = {station7;station8;station9;station10;station11;station12;station19;station20;
    station21;station22;station23;station24;station31;station32;station33;station34;station35;
    station36;station43;station44;station45;station46;station47;station48};

%day
stationD2 = {station1;station2;station3;station4;station5;station6;station7;station8;station9;station10;
    station11;station12;station13;station14;station15;station16;station17;station18;station19;station20;
    station21;station22;station23;station24};

stationD3 = {station25;station26;station27;station28;station29;station30;
    station31;station32;station33;station34;station35;station36;station37;station38;station39;station40;
    station41;station42;station43;station44;station45;station46;station47;station48};

% ****** horizontal and vertical RMSE for 24 hour data arc ***********
% j counts through the stations numbers (1 to 6) to be used in readPos
% i iterates through each element of the 24H vector
% h_RMSE_24hr = zeros(24,1);
% v_RMSE_24hr = zeros(24,1);
% j = 1;
% for i = 1:24 
%     solutions = readPos(sprintf('%s', station24H{i}), j);
%     h_RMSE_24hr(i) = solutions.h_RMSE;
%     v_RMSE_24hr(i) = solutions.v_RMSE;
%     j = j+1;
%     if j > 6
%         j = 1;
%     end
% end
% 
% % 30 min
% h_RMSE_30min = zeros(24,1);
% v_RMSE_30min = zeros(24,1);
% j = 1;
% for i = 1:24 
%     solutions = readPos(sprintf('%s', station30MIN{i}), j);
%     h_RMSE_30min(i) = solutions.h_RMSE;
%     v_RMSE_30min(i) = solutions.v_RMSE;
%     j = j+1;
%     if j > 6
%         j = 1;
%     end
% end

% %kinematic
% h_RMSE_kin = zeros(24,1);
% v_RMSE_kin = zeros(24,1);
% j = 1;
% for i = 1:24 
%     solutions = readPos(sprintf('%s', stationKIN{i}), j);
%     h_RMSE_kin(i) = solutions.h_RMSE;
%     v_RMSE_kin(i) = solutions.v_RMSE;
%     j = j+1;
%     if j > 6
%         j = 1;
%     end
% end
% 
% %static
% h_RMSE_stat = zeros(24,1);
% v_RMSE_stat = zeros(24,1);
% j = 1;
% for i = 1:24 
%     solutions = readPos(sprintf('%s', stationSTAT{i}), j);
%     h_RMSE_stat(i) = solutions.h_RMSE;
%     v_RMSE_stat(i) = solutions.v_RMSE;
%     j = j+1;
%     if j > 6
%         j = 1;
%     end
% 
% %day 2
% h_RMSE_day2 = zeros(24,1);
% v_RMSE_day2 = zeros(24,1);
% j = 1;
% for i = 1:24 
%     solutions = readPos(sprintf('%s', stationD2{i}), j);
%     h_RMSE_day2(i) = solutions.h_RMSE;
%     v_RMSE_day2(i) = solutions.v_RMSE;
%     j = j+1;
%     if j > 6
%         j = 1;
%     end
% end
% 
% %day 3
% h_RMSE_day3 = zeros(24,1);
% v_RMSE_day3 = zeros(24,1);
% j = 1;
% for i = 1:24 
%     solutions = readPos(sprintf('%s', stationD3{i}), j);
%     h_RMSE_day3(i) = solutions.h_RMSE;
%     v_RMSE_day3(i) = solutions.v_RMSE;
%     j = j+1;
%     if j > 6
%         j = 1;
%     end
% end

% ************ time to reach 5cm error ************************

% h_5cm_24hr = zeros(24,1);
% v_5cm_24hr = zeros(24,1);
% j = 1;
% for i = 1:24 
%     solutions = readPos(sprintf('%s', station24H{i}), j);
%     h_5cm_24hr(i) = solutions.h_error_5cm;
%     v_5cm_24hr(i) = solutions.v_error_5cm;
%     j = j+1;
%     if j > 6
%         j = 1;
%     end
% end

% 30 min
% h_5cm_30min = zeros(24,1);
% v_5cm_30min = zeros(24,1);
% j = 1;
% for i = 1:24 
%     solutions = readPos(sprintf('%s', station30MIN{i}), j);
%     h_5cm_30min(i) = solutions.h_error_5cm;
%     v_5cm_30min(i) = solutions.v_error_5cm;
%     j = j+1;
%     if j > 6
%         j = 1;
%     end
% end

% %kinematic
% h_5cm_kin = zeros(24,1);
% v_5cm_kin = zeros(24,1);
% j = 1;
% for i = 1:24 
%     solutions = readPos(sprintf('%s', stationKIN{i}), j);
%     h_5cm_kin(i) = solutions.h_error_5cm;
%     v_5cm_kin(i) = solutions.v_error_5cm;
%     j = j+1;
%     if j > 6
%         j = 1;
%     end
% end
% 
% %static
% h_5cm_stat = zeros(24,1);
% v_5cm_stat = zeros(24,1);
% j = 1;
% for i = 1:24 
%     solutions = readPos(sprintf('%s', stationSTAT{i}), j);
%     h_5cm_stat(i) = solutions.h_error_5cm;
%     v_5cm_stat(i) = solutions.v_error_5cm;
%     j = j+1;
%     if j > 6
%         j = 1;
%     end
% end

end



