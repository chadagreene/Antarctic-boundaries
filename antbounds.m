function h = antbounds(datatype,varargin)
% antbounds plots line data from the line data in the MEaSURES Antarctic Boundaries 
% for IPY 2007-2009 from Satellite Radar dataset Version 2. 
% 
% The dataset is described on the NSIDC site here: http://nsidc.org/data/NSIDC-0709
% 
%% Syntax 
% 
%  antbounds 
%  antbounds(datatype) 
%  antbounds(datatype,PropertyName,PropertyValue,...)
%  antbounds(...,'polyshape') 
%  antbounds(...,'km') 
%  h = antbounds(...)
% 
%% Description 
% 
% antbounds without any inputs plots grounded and floating ice shelves as gray 
% polygons. (Requires Matlab R2017b or later.)
% 
% antbounds(datatype) plots line objects of the datatype specified by 'coast', 'gl', 'shelves', or 'shelfname'. 
% 
%    'coast'          seaward limit of the ice sheet
%    'gl'             landward limit of flexure detected by InSAR
%    'shelves'        180 ice shelves in the dataset
%    'shelfname'      any of the shelf names in the dataset, must be exactly one of the following: 
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
% antbounds(datatype,PropertyName,PropertyValue,...) formats the line properties with linewidth, color, etc. 
% 
% antbounds(...,'polyshape') plots the grounding line, coast line, or ice shelves as polyshape objects
% rather than as line objects. This option requires Matlab version R2017b or newer. Polyshape properties
% are equivalent to patch or fill properties (e.g., FaceColor, EdgeColor, FaceAlpha, etc.)
%
% antbounds(datatype,'km') plots in polar stereographic kilometers rather than meters. 
% 
% h = antbounds(...) returns a handle h of the plotted object(s) 
% 
%% Examples 
% 
% % Plot a coastline like this: 
% 
%   antbounds('coast') 
% 
% % Plot a red grounding line like this: 
% 
%   antbounds('gl','color','r') 
% 
% % Outline Amery Ice Shelf with a fat magenta line like this: 
% 
%   antbounds('amery','m','linewidth',4)
% 
% % Fill in the outlines using the polyshape option (requires 2017b+)
% 
%   antbounds('shelves','polyshape') 
% 
% % Or format the filled-in ice shelves real pretty: 
% 
%    antbounds('shelves','polyshape',...
%       'facecolor','r',...
%       'facealpha',1,...
%       'linewidth',3,...
%       'edgecolor','g')
% 
%% Citing this dataset
% If this function is useful to you, please cite the following: 
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
% Version History: 
% Nov. 2016: Created
% May 2018: Now allows plotting boundaries as polyshape objects. 
% Sept 2018: New option: antbounds without inputs makes simple map.
% 
% See also: antbounds_data and labelshelves.

%% Shortcut to a simple map: 

if nargin==0
   h(1) = antbounds('gl','poly','facecolor',[0.5725    0.5843    0.5686]*.5);
   h(2) = antbounds('shelves','poly','facecolor',[0.8471    0.8627    0.8392]*.5);
   if nargout==0
      clear h 
   end
   return
end

%% Input parsing; 

tmp = strcmpi(varargin,'km'); 
if any(tmp)
   plotkm = true; 
   varargin = varargin(~tmp); 
else
   plotkm = false; 
end

polygon = false; 
tmp = strncmpi(varargin,'polyshape',4); 
if any(tmp)
   varargin = varargin(~tmp); 
   if verLessThan('matlab','9.3')
      warning('Matlab R2017b or later is required for plotting as polyshape. Attempting to plot as line data instead.')
   else
      polygon = true; 
   end
end

%% Get initial conditions: 

da = daspect; 
da = [1 1 da(3)]; 
hld = ishold; 
hold on

mapisopen = ~isequal(axis,[0 1 0 1]); 
ax = axis; 

%% Load data and adjust dataset as necessary

[x,y] = antbounds_data(datatype,'xy'); 

% Convert to kilometers: 
if plotkm
   x = x/1000; 
   y = y/1000; 
end

if ~mapisopen
   axis([min(x) max(x) min(y) max(y)])
   ax = axis; 
end

if ~polygon
   % If a map is already open, trim the dataset to the current limits:
   % But trimming polygons could have undesired results, so let's only trim data if it'll be plotted as line data.  
   if mapisopen
      % Preserve NaNs to prevent disjointed segements from linking: 
      in = inpsquad(x,y,xlim,ylim); 
      x(~in) = NaN; 
      y(~in) = NaN; 
      if isrow(x)
         trim = isnan(x) & [0,diff(isnan(x))]==0; 
      else
         trim = isnan(x) & [0;diff(isnan(x))]==0; 
      end

      x = x(~trim); 
      y = y(~trim); 

   %else
    %  axis([min(x) max(x) min(y) max(y)])
   end
end

%% Place labels

if polygon
   pgon = polyshape(x,y,'Simplify',false);
   h = plot(pgon,varargin{:}); 
else
   h = plot(x,y,varargin{:}); 
end

%% Put things back the way we found them: 

daspect(da)
if ~hld
   hold off
end

if mapisopen
   axis(ax); 
end

%% Clean up: 

if nargout==0
   clear h
end

end
