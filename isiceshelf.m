function tf = isiceshelf(lati_or_xi,loni_or_yi,varargin)
% isiceshelf returns logical true wherever there is floating glacial ice (ice shelves or tongues) 
% according to MEaSURES Antarctic Boundaries for IPY 2007-2009 from Satellite Radar, Version 2. 
% 
% The dataset is described on the NSIDC site here: http://nsidc.org/data/NSIDC-0709
% 
%% Syntax
% 
%  tf = isiceshelf(lati,loni)
%  tf = isiceshelf(xi,yi) 
%  tf = isiceshelf(...,IceShelfName) 
%  tf = isiceshelf(...,'RumplesTrue') 
% 
%% Description
% 
% tf = isiceshelf(lati,loni) returns true for all geo locations (lati,loni) identified as ice shelf or ice 
% tongue in the Mask_Antarctica_v1.tif dataset. 
%  
% tf = isiceshelf(xi,yi) returns true for all locations identified as ice shelf or ice tongue in Mask_Antactica_v2.tif (sic), 
% where input coordinates are automatically determined to be polar stereographic (true lat 71 S) meters if their values
% exceed the normal lat,lon range.  
%
% tf = isiceshelf(...,IceShelfName) only returns true for points corresponding to the given ice shelf. 
% This method is computationally slower because it uses inpolygon (rather than interp2 of Mask_Antactica_v2.tif) 
% to find points within an ice shelf boundary. 
% 
% tf = isiceshelf(...,'RumplesTrue') lets ice rumples within an ice shelf be true. By default, 
% an pinning points or ice rumples are grounded and are therefore not considered part of the ice shelf, but 
% with the 'RumplesTrue' option, pinning points and rumples such as those in Pine Island and Totten ice shelves
% are true. 
% 
%% Examples: 
% For examples, type:  
% 
%  amt isiceshelf
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
% Updated May 2018 to allow specifying a single ice shelf. 
% 
% See also: isice, istidal, isopenocean, and isgrounded. 

%% Error checks and input parsing: 

narginchk(2,4) 
assert(isequal(size(lati_or_xi),size(loni_or_yi))==1,'Input error: Dimensions of input coordinates must match.') 

if islatlon(lati_or_xi,loni_or_yi)
   [xi,yi] = ll2ps(lati_or_xi,loni_or_yi); 
else
   xi = lati_or_xi; 
   yi = loni_or_yi; 
end

% Set defaults: 
Rumples = false; % by default, rumples and pinning points are not considered ice shelf. 
useInpolygon = false; 

% Check user-defined options:    
if nargin>2
   
   tmp = strcmpi(varargin,'RumplesTrue'); 
   if any(tmp)
      Rumples = true; 
      varargin(tmp) = []; 
   end
   
   if ~isempty(varargin)
      IceShelfName = varargin{1}; 
      assert(isnumeric(IceShelfName)==0,'Input error: Third input of isiceshelf must be an ice shelf name.') 
      useInpolygon = true; 
   end
end

%% Mathematics: 

if ~useInpolygon % Use interp2 with the mask.tif for the entire continent: 
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

   % Turn the multi-level Mask_Antarctica_v2 into a true/false mask
   mask = Z==125; 
   
   % Fill holes, which are interpreted as ice rumples: 
   if Rumples 
      if license('test','image_toolbox')
         mask = imfill(mask,'holes'); 
      else
         warning('Cannot find image processing toolbox, which is required for filling holes (rumples) in the ice shelf mask. Ice rumples will be false. To use the RumplesTrue option, specify a single ice shelf of interest.')
      end
   end
   
   % Interpolate: 
   tf = interp2(x,y,mask,xi,yi,'nearest',0); 

   
else % Do the inpolygon method for a single ice shelf: 
   
   [x,y] = antbounds_data(IceShelfName,'xy'); 
   
   if Rumples
      firstNan = find(isnan(x)); 
      x = x(1:firstNan-1); 
      y = y(1:firstNan-1); 
   end
      
   tf = inpolygon(xi,yi,x,y); 
   
end

end