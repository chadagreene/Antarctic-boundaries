function [lat_or_x,lon_or_y] = basin_data(basinDataset,varargin)
% antbounds_data returns the coordinates of line data in the MEaSURES Antarctic Boundaries 
% for IPY 2007-2009 from Satellite Radar dataset Version 2. 
% 
% The dataset is described on the NSIDC site here: http://nsidc.org/data/NSIDC-0709
% 
% (For Zwally's basins instead use these functions: https://www.mathworks.com/matlabcentral/fileexchange/47639)
% 
%% Syntax
% 
%  [lat,lon] = basin_data(basinDataset)
%  [...] = basin_data(basinDataset,basinName)
%  [x,y] = basin_data(...,'xy')
% 
%% Description 
% 
% [lat,lon] = basin_data(basinDataset) returns geocoordinates of all basins 
% in the basinDataset, which can be 'imbie' or 'imbie refined'. 
% 
% [...] = basin_data(basinDataset,basinName) specifies a single basin name. 
% To see a list of basins available in each dataset type plot_basins('demo').
% 
% [x,y] = basin_data(...,'xy') returns data in x,y polar stereographic meters (ps71). 
% 
%% Examples
% For examples type 
% 
%  amt basin_data
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
% See also inbasin and plot_basins. 

%% Error checking and input parsing:  

narginchk(1,3); 
nargoutchk(1,3); 

switch(lower(basinDataset))
   case 'imbie'
      filename = 'basins_IMBIE_v2.mat'; 
      
   case {'refined','imbie refined','imbierefined'} 
      filename = 'basins_refined_v2.mat'; 

   otherwise
      error('basinDataset can only be ''imbie'' or ''imbie refined''.') 
end

xyout = false; % by default 
OneBasin = false; 
if nargin>1
   tmp = strcmpi(varargin,'xy');
   if any(tmp)
      xyout = true; 
      varargin = varargin(~tmp); 
   end
   
   if ~isempty(varargin)
      basinName = varargin{1};     
      OneBasin = true; 
   end
   
end

%% Load data

B = load(filename);

if OneBasin
   % Find the basin of interest: 
   ind = strcmpi(B.name,basinName); 
   if ~any(ind)
      error('Cannot find the requested basin. Check the spelling and try again.')
   end
      
else
   ind = 1:length(B.x);
end

if xyout
   lat_or_x = cell2mat(B.x(ind)'); 
   lon_or_y = cell2mat(B.y(ind)'); 
else
   [lat_or_x,lon_or_y] = ps2ll(cell2mat(B.x(ind)),cell2mat(B.y(ind)));
end


end