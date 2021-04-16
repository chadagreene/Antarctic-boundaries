function tf = inbasin(lati_or_xi,loni_or_yi,basinDataset,basinName) 
% inbasin returns true for coordinates inside a given basin in the MEaSURES Antarctic Boundaries 
% for IPY 2007-2009 from Satellite Radar dataset Version 2. 
% 
% The dataset is described on the NSIDC site here: http://nsidc.org/data/NSIDC-0709
% 
% (For Zwally's basins instead use these functions: https://www.mathworks.com/matlabcentral/fileexchange/47639)
% 
%% Syntax 
% 
%  tf = inbasin(lat,lon,basinDataset,basinName)
%  tf = inbasin(x,y,basinDataset,basinName)
% 
%% Description 
% 
% tf = inbasin(lat,lon,basinDataset,basinName) is true for all lat,lon points
% inside the polygon of the basinName inside a specified basinDataset. The
% optins for basinDataset are 'imbie' or 'imbie refined' and basin names can be 
% determined by typing plot_basins('demo'). 
% 
% tf = inbasin(x,y,basinDataset,basinName) as above, but for input coordinates 
% x,y in polar stereographic meters (ps71 aka EPSG:3031)
% 
%% Examples 
% For examples type 
% 
%  amt inbasin
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
% See also basin_data, isgrounded, and plot_basins. 

%% Error checking and input parsing: 

narginchk(4,4) 
assert(isequal(size(lati_or_xi),size(loni_or_yi))==1,'Error: Dimensions of input coordinates must agree.') 
assert(isnumeric(basinDataset)==0,'Error: basin dataset must be IMBIE or IMBIE refined.') 
assert(isnumeric(basinName)==0,'Error: There are no numbered basin names in the IMBIE or IMBIE refined datasets. Perhaps you''re looking for Zwally''s numbered basins?') 

if islatlon(lati_or_xi,loni_or_yi)
   [xi,yi] = ll2ps(lati_or_xi,loni_or_yi); 
else
   xi = lati_or_xi; 
   yi = loni_or_yi; 
end

%% Load basin data: 

[xv,yv] = basin_data(basinDataset,basinName,'xy'); 

%% Mathematics: 

tf = inpolygon(xi,yi,xv,yv); 

end



