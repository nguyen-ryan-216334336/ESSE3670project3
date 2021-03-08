function [ X, Y, Z ] = llh2XYZ(lat, long, h)
%LLH2XYZ Converts LLH coordinates to IRTS coordinates
%   The input angles are in degrees

%Constants
a = 6378137;
f = 1/298.257222101;
b = a*(1-f);

%Degrees to radians
lat = lat*pi/180;
long = long*pi/180;

N = (a^2)/sqrt((a*cos(lat))^2+(b*sin(lat))^2);

X = (N+h)*cos(lat)*cos(long);
Y = (N+h)*cos(lat)*sin(long);
Z = (N*(b/a)^2+h)*sin(lat);

end
