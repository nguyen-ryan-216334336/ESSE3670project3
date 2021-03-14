ALGOlat = 45.9558; 
ALGOlong = 281.92863;

DUBOlat = 50.25881;
DUBOlong = 264.13382;

WHITlat = 60.75051;
WHITlong = 224.77788;

GOLDlat = 35.42516;
GOLDlong = 243.11075;

WUHNlat = 30.53165 ;
WUHNlong = 114.35726;

IISClat = 13.02117 ;
IISClong = 77.57038;

lat = [ALGOlat DUBOlat WHITlat GOLDlat WUHNlat IISClat]';
long = [ALGOlong DUBOlong WHITlong GOLDlong WUHNlong IISClong]';

geoplot([ALGOlat, DUBOlat, WHITlat, GOLDlat, WUHNlat, IISClat],[ALGOlong, DUBOlong, WHITlong, GOLDlong, WUHNlong, IISClong],'^')
geobasemap streets

title('Map of Locations of Stations');
text(ALGOlat,ALGOlong,'ALGO00CAN');
text(DUBOlat,DUBOlong,'DUBO00CAN');
text(WHITlat,WHITlong,'WHIT00CAN');
text(GOLDlat,GOLDlong,'GOLD00USA');
text(WUHNlat,WUHNlong,'WUHN00CHN');
text(IISClat,IISClong,'IISC00IND');

