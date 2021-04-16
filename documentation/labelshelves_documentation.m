%% |labelshelves| documentation 
% The |labelshelves| function simply labels ice shelves on an Antarctic polar stereographic (ps71) map. 
% Ice shelf names are from the MEaSURES Antarctic Boundaries for IPY 2007-2009 from Satellite Radar, Version 2 dataset. 
% 
% The Antarctic Boundaries dataset is described on the NSIDC site <http://nsidc.org/data/NSIDC-0709 here>. 
% An overview of the tools in this AMT plugin can be found <Antbounds_Contents.html here>.
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
% |labelshelves| places text labels on all 147 Antarctic ice shelves in the dataset. 
%
% |labelshelves(...,TextPropertyName,TextPropertyValue,...)| specifies text properties such as fontsize
% or color. 
%
% |labelshelves(...,'km')| plots in kilometers rather than meters. 
% 
% |h = labelshelves(...)| returns a handle h of the text object. 
%
%% Example 1: Whole continent 

labelshelves 

%% Example 2: Formatting text

figure
mapzoomps('amundsen sea','mapwidth',1000,'sw') 
antbounds('coast','k') 
antbounds('gl','k')
antbounds('shelves','k')
labelshelves('color','red','fontsize',10)

%% Example 3: Polyshape 

figure
mapzoomps('amundsen sea','mapwidth',1000,'sw') 
antbounds('gl','k')
antbounds('shelves','polyshape','facecolor','r')
labelshelves('color','b',...
   'fontangle','italic',...
   'fontweight','bold',...
   'fontsize',10)

%% Citing this dataset
% If you use this dataset, please cite the following: 
% 
% * *The dataset:* Mouginot, J., B. Scheuchl, and E. Rignot. 2017. MEaSUREs Antarctic Boundaries for IPY 2007-2009 from 
% Satellite Radar, Version 2. [Indicate subset used]. Boulder, Colorado USA. NASA National Snow and Ice Data Center Distributed 
% Active Archive Center. http://dx.doi.org/10.5067/AXE4121732AD. 
% 
% * *Literature citation:* Rignot, E., S. S. Jacobs, J. Mouginot, and B. Scheuchl. 2013. Ice-shelf melting around Antarctica, 
% Science. 341. 266-270. http://dx.doi.org/10.1126/science.1235798. 
% 
% * *Antarctic Mapping Tools:* Greene, C. A., Gwyther, D. E., & Blankenship, D. D. Antarctic Mapping Tools for Matlab. 
% _Computers & Geosciences_. 104 (2017) pp.151-157. <http://dx.doi.org/10.1016/j.cageo.2016.08.003 doi:10.1016/j.cageo.2016.08.003>.
% 
%% Author Info
% This function and supporting documentation were written by <http://www.chadagreene.com Chad A. Greene> of the University
% of Texas Institute for Geophysics (UTIG), November 2016. Updated May 2017. 