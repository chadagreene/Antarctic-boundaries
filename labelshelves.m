function h = labelshelves(varargin)
% labelshelves simply labels ice shelves on an Antarctic polar stereographic (ps71) map. 
% Ice shelf names are from the MEaSURES Antarctic Boundaries for IPY 2007-2009 from Satellite Radar, Version 2 dataset. 
% 
% The dataset is described on the NSIDC site here: http://nsidc.org/data/NSIDC-0709
% 
%% Syntax
% 
%  labelshelves
%  labelshelves(...,TextPropertyName,TextPropertyValue,...)
%  labelshelves(...,'km')
%  h = labelshelves(...) 
%
%% Description 
% 
% labelshelves places text labels on all 147 Antarctic ice shelves in the dataset. 
%
% labelshelves(...,TextPropertyName,TextPropertyValue,...) specifies text properties such as fontsize
% or color. 
%
% labelshelves(...,'km') plots in kilometers rather than meters. 
% 
% h = labelshelves(...) returns a handle h of the text object. 
%
%% Example 
% 
% mapzoomps('amundsen sea','mapwidth',1000,'sw') 
% antbounds('coast','k') 
% antbounds('gl','k')
% antbounds('shelves','k')
% labelshelves('color','red','fontangle','italic','fontweight','bold')
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
% Update May 2018: Fixed Fox Glacier vs Fox Ice Stream ambiguity. Also now plots labels at the 
% centroid rather than the mean location. 
% 
% See also: textps and isiceshelf. 

%% Input parsing; 

tmp = strcmpi(varargin,'km'); 
if any(tmp)
   plotkm = true; 
   varargin = varargin(~tmp); 
else
   plotkm = false; 
end

%% Get initial conditions: 

da = daspect; 
da = [1 1 da(3)]; 
hld = ishold; 
hold on

mapisopen = ~isequal(axis,[0 1 0 1]); 

%% Load data and adjust dataset as necessary

load iceshelves_2008_v2.mat

if verLessThan('matlab','9.3')
   % Use the mean location for text label placement: 
   xc = cellfun(@nanmean,x); 
   yc = cellfun(@nanmean,y); 
else
   % Use the centroid: 
   xc = nan(size(name)); 
   yc = nan(size(name)); 
   for k = 1:length(name)
      [xc(k),yc(k)] = centroid(polyshape(x{k},y{k},'Simplify',false)); 
   end
end

% Convert to kilometers: 
if plotkm
   xc = xc/1000; 
   yc = yc/1000; 
end


% If a map is already open, trim the dataset to the current limits: 
if mapisopen
   in = inpsquad(xc,yc,xlim,ylim); 
   xc = xc(in); 
   yc = yc(in); 
   name = name(in); 
else
   axis([min(xc) max(xc) min(yc) max(yc)])
end

%% Place labels

h = text(xc,yc,name,'horiz','center','vert','middle',varargin{:}); 

%% Put things back the way we found them: 

daspect(da)
if ~hld
   hold off
end

%% Clean up: 

if nargout==0
   clear h
end

end
