function tf = isopenocean(lati_or_xi,loni_or_yi)
% isopenocean returns logical true wherever there is open ocean in Antarctica  
% according to MEaSURES Antarctic Boundaries for IPY 2007-2009 from Satellite Radar, Version 2. 
% 
% The dataset is described on the NSIDC site here: http://nsidc.org/data/NSIDC-0709
% 
%% Syntax
% 
%  tf = isopenocean(lati,loni)
%  tf = isopenocean(xi,yi) 
% 
%% Description
% 
% tf = isopenocean(lati,loni) returns true for all geo locations (lati,loni) identified as ocean
% in the Mask_Antarctica_v1.tif dataset. 
%  
% tf = isopenocean(xi,yi) returns true for all locations identified as ocean in Mask_Antactica_v2.tif (sic), where
% input coordinates are automatically determined to be polar stereographic (true lat 71 S) meters if their values
% exceed the normal lat,lon range.  
%
%% Example: Mask a gravity dataset:  
% 
% % Create a 300 km wide grid centered on PIG, at 0.25 km resolution:
%
%    [lat,lon] = psgrid('pine island glacier',300,0.25); 
% 
% % And perhaps you have a gravity dataset: 
%  
%    FA = gravity_interp(lat,lon,'free air');
% 
% % Use isopenocean to find out which parts of the dataset are oceanic: 
% 
%    ocean = isopenocean(lat,lon); 
% 
% % Mask-out all non-grounded ice (use the tilde for NOT) by setting it to NaN: 
% 
%    FA(~ocean) = NaN; 
% 
% % Plot the grounded gravity data: 
% 
%    pcolorps(lat,lon,FA)
%    axis tight
%    mapzoomps('ne')
%
%% Citing this dataset
% If you use this dataset, please cite the following: 
% 
% The dataset: 
% Mouginot, J., B. Scheuchl, and E. Rignot. 2017. MEaSUREs Antarctic Boundaries for IPY 2007-2009 from 
% Satellite Radar, Version 2. [Indicate subset used]. Boulder, Colorado USA. NASA National Snow and Ice 
% Data Center Distributed Active Archive Center. http://dx.doi.org/10.5067/AXE4121732AD. 
% 
% Literature citation:
% Rignot, E., S. S. Jacobs, J. Mouginot, and B. Scheuchl. 2013. Ice-shelf melting around Antarctica, 
% Science. 341. 266-270. http://dx.doi.org/10.1126/science.1235798. 
% 
% Antarctic Mapping Tools: 
% Greene, C. A., Gwyther, D. E., & Blankenship, D. D. Antarctic Mapping Tools for Matlab. 
% Computers & Geosciences. 104 (2017) pp.151-157. http://dx.doi.org/10.1016/j.cageo.2016.08.003
% 
%% Author Info
% This function and supporting documentation were written by Chad A. Greene of the University
% of Texas Institute for Geophysics (UTIG), November 2016. 
% http://www.chadagreene.com 
% 
% See also: isice, istidal, isopenocean, and isiceshelf. 

%% Error checks and input parsing: 

narginchk(2,2) 
assert(isequal(size(lati_or_xi),size(loni_or_yi))==1,'Input error: Dimensions of input coordinates must match.') 

if islatlon(lati_or_xi,loni_or_yi)
   [xi,yi] = ll2ps(lati_or_xi,loni_or_yi); 
else
   xi = lati_or_xi; 
   yi = loni_or_yi; 
end

%% Load data

% x and y coordinates of full .tif dataset: 
x = -2799750:500:2800750;
y = 2799750:-500:-2800750; 

% Get range of image coordinates corresponding to interpolation points: 
cols = find(x>=(min(xi(:))-1000) & x<=(max(xi(:))+1000)); 
rows = find(y>=(min(yi(:))-1000) & y<=(max(yi(:))+1000)); 

% Trim x and y to range of data: 
x = x(cols); 
y = y(rows); 

% Read rows and columns of data:  
Z = imread('Mask_Antactica_v2.tif','PixelRegion',{[min(rows) max(rows)] [min(cols)  max(cols)]});

%% Interpolate: 

tf = interp2(x,y,Z,xi,yi,'nearest')==0; 

end