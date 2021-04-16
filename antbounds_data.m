function [lat_or_x,lon_or_y,name] = antbounds_data(datatype,varargin)
% antbounds_data returns the coordinates of line data in the MEaSURES Antarctic Boundaries 
% for IPY 2007-2009 from Satellite Radar dataset Version 2. 
% 
% The dataset is described on the NSIDC site here: http://nsidc.org/data/NSIDC-0709
% 
%% Syntax
% 
%  [lat,lon] = antbounds_data(datatype)
%  [x,y] = antbounds_data(datatype,'xy')
%  [...,names] = antbounds_data('shelves')
% 
%% Description
% 
% [lat,lon] = antbounds_data(datatype) returns the geo coordinates (lat,lon) of any of the following
% datatypes: 
% 
%    'coast'     seaward limit of the ice sheet
%    'gl'        landward limit of flexure detected by InSAR
%    'shelves'   a cell array of all ice 181 ice shelves in the dataset
%    'IceShelfName' any of the shelf names in the dataset, must be exactly one of the following: 
%
%        'Abbot'                 'Getz 1'               'Porter'                    
%        'Abbot 1'               'Getz 2'               'PourquoiPas'               
%        'Abbot 2'               'Gillet'               'Prince Harald'             
%        'Abbot 3'               'Hamilton'             'Publications'              
%        'Abbot 4'               'Hamilton Piedmont'    'Quar'                      
%        'Abbot 5'               'Hannan'               'Quatermain Point'          
%        'Abbot 6'               'HarbordGlacier'       'Rayner Thyer'              
%        'Ainsworth'             'Harmon Bay'           'Rennick'                   
%        'Alison'                'Hayes Coats Coast'    'Richter'                   
%        'Amery'                 'Helen'                'Riiser-Larsen'             
%        'Andreyev'              'Holmes'               'Ronne'                     
%        'Arneb'                 'Holt'                 'Rose Point'                
%        'Astrolabe'             'HornBluff'            'Ross East'                 
%        'Atka'                  'Hoseason'             'Ross West'                 
%        'Aviator'               'Hovde'                'Rund Bay'                  
%        'Bach'                  'Hull'                 'Rydberg Peninsula 1'       
%        'Barber'                'Hummer Point'         'Rydberg Peninsula 2'       
%        'Baudouin'              'Ironside'             'Sandford'                  
%        'Borchgrevink'          'Jackson'              'Shackleton'                
%        'Brahms'                'Jelbart'              'Shirase'                   
%        'Britten'               'Kirkby'               'Skallen'                   
%        'Brunt Stancomb'        'Land'                 'Slava'                     
%        'Campbell'              'LarsenA'              'SmithInlet'                
%        'CapeWashington'        'LarsenB'              'Sorsdal'                   
%        'Cheetham'              'LarsenC'              'Stange'                    
%        'Chugunov'              'LarsenD'              'Sulzberger'                
%        'Cirque Fjord'          'LarsenD 1'            'Suter'                     
%        'ClarkeBay'             'LarsenE'              'Suvorov'                   
%        'Commandant Charcot'    'LarsenF'              'Swinburne'                 
%        'Conger Glenzer'        'LarsenG'              'Telen'                     
%        'Cook'                  'Lauritzen'            'Thomson'                   
%        'Cosgrove'              'Lazarev'              'Thwaites'                  
%        'Crosson'               'Lillie'               'Tinker'                    
%        'Dalk'                  'Liotard'              'Totten'                    
%        'Dawson Lambton'        'Mandible Cirque'      'Tracy Tremenchus'          
%        'Deakin'                'Manhaul'              'Tucker'                    
%        'Dennistoun'            'Marin'                'Underwood'                 
%        'Dibble'                'Mariner'              'Utsikkar'                  
%        'Dotson'                'Marret'               'Venable'                   
%        'Drury'                 'Matusevitch'          'Verdi'                     
%        'Drygalski'             'May Glacier'          'Vigrid'                    
%        'Edward VIII'           'McLeod'               'Vincennes Bay'             
%        'Ekstrom'               'Mendelssohn'          'Voyeykov'                  
%        'Eltanin Bay'           'Mertz'                'Walgreen Coast 1'          
%        'Erebus'                'Morse'                'Walgreen Coast 2'          
%        'Falkner'               'Moscow University'    'WattBay'                   
%        'Ferrigno'              'Moubray'              'West'                      
%        'Filchner'              'Mulebreen'            'Whittle'                   
%        'Fimbul'                'Myers'                'Wilkins'                   
%        'Fisher'                'Nansen'               'Williamson'                
%        'Fitzgerald'            'Nickerson'            'WilmaRobertDowner'         
%        'Flatnes' 'Fox Glacier' 'Ninnis'               'Withrow'                   
%        'Fox Ice Stream'        'Nivl'                 'Wordie (Airy Rotz Seller)' 
%        'Francais'              'Noll'                 'Wordie (Cape Jeremy)'      
%        'Frost'                 'Nordenskjold'         'Wordie (Harriott)'         
%        'Gannutz'               'Parker'               'Wordie (Harriott Headland)'
%        'Garfield'              'Paternostro'          'Wordie (Prospect)'         
%        'GeikieInlet'           'Perkins'              'Wylde'                     
%        'George VI'             'Philbin Inlet'        'Zelee'                     
%        'Getz'                  'Pine Island'          'Zubchatyy'  
%
% [x,y] = antbounds_data(datatype,'xy') returns polar stereographic (true lat 71 S) coordinates in meters. 
% 
% [...,names] = antbounds_data('shelves') also returns an array of ice shelf names. 
% 
%% Example 
% This example uses antbounds_data to determine make a mask of grid points in Wilkins Ice Shelf. 
% Consider a 10 km resolution grid, 700 km wide, centered on Wilkins Ice Shelf that looks like this: 
% 
%   [xgrid,ygrid] = psgrid('wilkins ice shelf',700,10,'xy'); 
% 
% That grid looks like this: 
% 
%   plot(xgrid,ygrid,'.','color',[.5 .5 .5])
%   axis image
%   hold on
% 
% Load and plot the grounding line data: 
% 
%   [gllat,gllon] = antbounds_data('gl'); 
%   plotps(gllat,gllon,'k')
% 
%   [clat,clon] = antbounds_data('coast'); 
%   plotps(clat,clon,'b')
% 
% Or we could have done the shortcut for plotting and just used antbounds like this: 
% 
%   antbounds('shelves')
% 
% But which of our grid points are actually part of Wilkins Ice Shelf?  Since our grid is in x,y values
% we should load the Wilkins outline in xy as well: 
%
%   [wx,wy] = antbounds_data('wilkins','xy'); 
%   plot(wx,wy,'r','linewidth',2)
% 
% And we can use inpolygon to determine which grid points are part of the ice shelf, then plot them as red circles: 
% 
%   in = inpolygon(xgrid,ygrid,wx,wy); 
%   plot(xgrid(in),ygrid(in),'ro')
% 
% This is functionally similar to isiceshelf, except that isiceshelf gives a true value for *all* ice shelves, 
% whereas the inpolygon method shown above returns true for only the specific ice shelf of interest. Here's what 
% it would look like with isiceshelf: 
% 
%   anyiceshelf = isiceshelf(xgrid,ygrid);
%   plot(xgrid(anyiceshelf),ygrid(anyiceshelf),'kx')
% 
%   labelshelves('fontweight','bold','fontsize',20)
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
% See also: isgrounded, labelshelves, and antbounds.

%% Parse inputs: 

narginchk(1,inf)
nargoutchk(2,3) 

if strcmpi(varargin,'xy')
   xyout = true; 
else
   xyout = false; 
end

%% Load data

switch lower(datatype)
   case 'gl'
      D = load('groundingline_2008_v2.mat'); 
      
   case 'coast'
      D = load('coastline_2008_v2.mat'); 
      
   otherwise 
      D = load('iceshelves_2008_v2.mat'); 
end
      
%% Figure out how to output the data: 

switch lower(datatype)
   case {'gl','coast'} 
      if xyout
         lat_or_x = D.x; 
         lon_or_y = D.y; 
      else
         [lat_or_x,lon_or_y] = ps2ll(D.x,D.y); 
      end
      
   case 'shelves'
      if xyout
         lat_or_x = cell2mat(D.x(:)); 
         lon_or_y = cell2mat(D.y(:)); 
      else
         [lat_or_x,lon_or_y] = ps2ll(cell2mat(D.x(:)),cell2mat(D.y(:)));
      end
      
      if nargout==3
         name = D.name; 
      end
      
   otherwise
      tmp = strcmpi(D.name,datatype); 
      if sum(tmp)==0
         tmp = strncmpi(D.name,datatype,2); 
         if any(tmp)
            disp('Is this the ice shelf you are looking for?')
            disp(char(D.name(tmp)))
         end
            error(['Error: Cannot find dataset ',datatype,'. Check the list of ice shelf names and make sure it is spelled exactly right.']) 
      end
      
      if xyout
         lat_or_x = D.x{tmp}; 
         lon_or_y = D.y{tmp}; 
      else
         [lat_or_x,lon_or_y] = ps2ll(D.x{tmp},D.y{tmp}); 
      end
end


end