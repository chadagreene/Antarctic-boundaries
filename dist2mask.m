function d = dist2mask(masktype,lati_or_xi,loni_or_yi)
% dist2mask returns the distance in kilometers from given datapoints to any mask type (grounded, iceshelf, etc.) 
% according to MEaSURES Antarctic Boundaries for IPY 2007-2009 from Satellite Radar, Version 2. 
%  
% The dataset is described on the NSIDC site here: http://nsidc.org/data/NSIDC-0709
% 
%% Syntax
%
%  d = dist2mask(masktype,lati,loni)
%  d = dist2mask(masktype,xi,yi) 
% 
%% Description 
%
% d = dist2mask(masktype,lati,loni) gives the distance di from the geo locations (lati,loni) to the nearest mask
% type, which can be any of the following: 
% 
%     'grounded'  all ice or rocks on the landward side of the InSAR-detected landward limit of flexure.
%     'iceshelf'  all the bits of the ice sheet (not sea ice) on the seaward side of the landward limit of flexure.
%     'ice'       any part of the ice sheet (not sea ice).
%     'openocean' any part of the open ocean (not ice shelves or sea ice).
%     'tidal'     everything seaward of the landward limit of flexure, including ice shelves. 
%
% d = dist2mask(masktype,xi,yi) is the same as above, except coordinates are polar stereographic meters (ps71), which
% are automatically parsed by the islatlon function. 
% 
%% Example
% Given these scattered points, let's say it's mooring data: 
% 
%   lat = -70+4*randn(50,1);
%   lon = -45+6*randn(50,1);
% 
%   plotps(lat,lon,'ko');
%   antbounds('coast') 
% 
% Suppose you want to know the distance of each mooring to the nearest bit of ice sheet: 
% 
%   d = dist2mask('ice',lat,lon); 
%   scatterps(lat,lon,50,d,'filled') 
%   cb = colorbar; 
%   ylabel(cb,' distance from coast (km) ') 
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
% See also: isgrounded, isocean, isice, istidal, and isiceshelf. 

%% Error checking and input parsing:

assert(license('test','image_toolbox')==1,'License error: I''m afraid the dist2mask function requires a license for Matlab''s Image Processing Toolbox.')

if islatlon(lati_or_xi,loni_or_yi)
   [xi,yi] = ll2ps(lati_or_xi,loni_or_yi); 
else
   xi = lati_or_xi; 
   yi = loni_or_yi; 
end

%% Load mask: 

extra = 1600; 

% x and y coordinates of full .tif dataset: 
x = -2799750:500:2800750;
y = 2799750:-500:-2800750; 

% Get range of image coordinates corresponding to interpolation points: 
cols = find(x>=(min(xi(:))-extra*1000) & x<=(max(xi(:))+extra*1000)); 
rows = find(y>=(min(yi(:))-extra*1000) & y<=(max(yi(:))+extra*1000)); 

% Trim x and y to range of data: 
x = x(cols(1:2:end)); 
y = y(rows(1:2:end)); 

% Read rows and columns of data, skip every other row and column b/c 1 km resolution is probably okay and processing time is 1/4 of what it'd be with 500 m resolution.
Z = imread('Mask_Antactica_v2.tif','PixelRegion',{[min(rows) 2 max(rows)] [min(cols) 2 max(cols)]});

%% Select mask and calculate distance

switch lower(masktype) 
   case 'grounded' 
      mask = Z==255;
   case 'iceshelf' 
      mask = Z==125; 
   case 'openocean'
      mask = Z==0;
   case 'tidal' 
      mask = Z<255; 
   case 'ice' 
      mask = Z>0; 
   otherwise 
      error('Mask type can only be ''grounded'', ''iceshelf'', ''openocean'', ''tidal'', or ''ice''.')
end

dst = double(bwdist(mask)); % Distance in kilometers is bwdist * res, where res is 0.5 km natively, but we're skipping every other row and column, which brings it to 1 km resolution.  

%% Interpolate: 

d = interp2(x,y,dst,xi,yi); 

end