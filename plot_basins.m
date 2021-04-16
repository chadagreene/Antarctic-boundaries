function h = plot_basins(basinDataset,varargin) 
% plot_basins returns the coordinates of line data in the MEaSURES Antarctic Boundaries 
% for IPY 2007-2009 from Satellite Radar dataset Version 2. 
% 
% The dataset is described on the NSIDC site here: http://nsidc.org/data/NSIDC-0709
% 
% (For Zwally's basins instead use these functions: https://www.mathworks.com/matlabcentral/fileexchange/47639)
% 
%% Syntax 
% 
%  plot_basins(basinDataset)
%  plot_basins(basinDataset,'basin',BasinName) 
%  plot_basins(...,PropertyName,PropertyValue,...)
%  plot_basins(...,'polyshape')
%  plot_basins(...,'km') 
%  plot_basins('demo') 
%  h = plot_basins(...) 
% 
%% Description 
% 
% plot_basins(basinDataset) plots either 'imbie' or 'imbie refined' basins. 
% (For Zwally's basins instead use these functions: https://www.mathworks.com/matlabcentral/fileexchange/47639)
% 
% plot_basins(basinDataset,'basin',BasinName) plots a single basin by name. For a visual
% depiction of basin names, type plot_basins('demo'). 
% 
% plot_basins(...,PropertyName,PropertyValue,...) specifies line or patch properties. 
% 
% plot_basins(...,'polyshape') plots outlines as filled polyshape (patch) objects rather
% than the default line objects. 
% 
% plot_basins(...,'km') plots in polar stereographic kilometers rather than the default meters. 
% 
% plot_basins('demo') opens a figure showing labeled IMBIE and IMBIE refined basins. 
% 
% h = plot_basins(...) returns a handle h of plotted object(s). 
% 
%% Examples 
% For examples type 
% 
%  amt plot_basins
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
% See also basin_data, antbounds, and inbasin. 

%% Error checking

narginchk(1,Inf) 
nargoutchk(0,1) 

%% Input parsing

switch lower(basinDataset) 
   case 'demo'
      assert(verLessThan('matlab','9.3')==0,'Sorry, the plot_basins demo requires Matlab R2017b or later.') 
      RunBasinDemo
      return
      
   case 'imbie'
      filename = 'basins_IMBIE_v2.mat'; 
      
   case {'refined','imbie refined','imbierefined'} 
      filename = 'basins_refined_v2.mat'; 

   otherwise
      error('basinDataset can only be ''imbie'' or ''imbie refined''.') 
end

% Plot all basins or just one? 
tmp = strcmpi(varargin,'basin'); 
if any(tmp)
   basinName = varargin{find(tmp)+1}; 
   tmp(find(tmp)+1)=1; 
   varargin = varargin(~tmp);   
   OneBasin = true; 
else 
   OneBasin = false; 
end

% Plot as line plot or filled polygons? 
tmp = strncmpi(varargin,'polyshape',4); 
if any(tmp)
   varargin = varargin(~tmp);   
   plotpoly = true; 
else 
   plotpoly = false; 
end

tmp = strcmpi(varargin,'km'); 
if any(tmp)
   varargin = varargin(~tmp);   
   plotkm = true; 
else 
   plotkm = false; 
end

%% Load data

if OneBasin
   [x,y] = basin_data(basinDataset,basinName,'xy'); 
else
   [x,y] = basin_data(basinDataset,'xy'); 
end
   
%% Adjust data

% Convert to kilometers: 
if plotkm
   x = x/1000; 
   y = y/1000; 
end

%% Get initial conditions of the plot: 

da = daspect; 
da = [1 1 da(3)]; 
hld = ishold; 
hold on

mapisopen = ~isequal(axis,[0 1 0 1]); 
if mapisopen
   ax = axis; 
else
   axis([min(x) max(x) min(y) max(y)])
   ax = axis; 
end

%% 

if plotpoly
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

axis(ax); 

%% Clean up: 

if nargout==0
   clear h
end


end

%% Subfunctions 

function RunBasinDemo 

figure

B = load('basins_IMBIE_v2.mat'); 
      
smplot(1,2,1) 
hold on
for k = 1:length(B.x)
      
   pgon = polyshape(B.x{k},B.y{k},'Simplify',false); 
   [xc,yc] = centroid(pgon); 
   h = plot(pgon); 
   text(xc,yc,B.name{k},'vert','middle','horiz','center','fontsize',8,'color',h.FaceColor*.25)
end
axis image off
ax = axis; 
title 'IMBIE'      
ax1 = gca; 

B = load('basins_refined_v2.mat'); 
    
smplot(1,2,2) 
hold on
for k = 1:length(B.x)
      
   pgon = polyshape(B.x{k},B.y{k},'Simplify',false); 
   [xc,yc] = centroid(pgon); 
   h = plot(pgon); 
   text(xc,yc,B.name{k},'vert','middle','horiz','center','fontsize',8,'color',h.FaceColor*.25)
end
axis image off
axis(ax) 
title 'IMBIE refined'    

ax2 = gca; 
linkaxes([ax1 ax2],'xy') 

end




function h = smplot(rows,cols,p,varargin)
% smplot creates axes in tiled positions. This is similar to subplot, but
% uses the entire figure window with no space between subplots.  The name
% smplot is used to invoke "Small Multiples" which are touted by Tufte. 
% 
%% Syntax
% 
%  smplot(rows,cols,p)
%  smplot(...,Edge,MarginWidth)
%  smplot(...,'axis','on') 
%  h = smplot(...)
% 
%% Description 
% 
% smplot(rows,cols,p) breaks the figure window into a rows-by-cols matrix
% of small axes and selects the p-th axes for the current plot. This is the
% same as calling subplot(m,n,p), except that smplot does not put any space
% between axes. 
%
% smplot(...,Edge,MarginWidth) leaves empty space on one or more sides of the
% figure, such as for a colorbar. Edge can be 'left', 'right', 'top', or 'bottom'.
% MarginWidth is the fraction of the figure's width or height to leave empty. For 
% example, smplot(3,4,1,'right',0.2,'bottom',0.5) breaks the figure into 3-by-4 
% axes with 20% of the figure width left empty on the right-hand edge and the 
% bottom half of the figure left empty.  
%
% smplot(...,'axis','on') inserts room between subplots for axis labels. Default 
% is 'axis','off'.  
%
% h = smplot(...) returns a handle of the new axes. 
% 
%% Example 1: Tight subplots
% Here's a 7-by-3 set of small multiples that fill the entire figure
% window: 
% 
% for k = 1:21
%     smplot(7,3,k)
%     imagesc(peaks(300))
%     axis off 
% end
%
%% Example 2: Sharing a colorbar
% Sometimes we want to see a gridded field as it changes over time. Given 24 snapshots
% of a gridded field we'll arrange them in a 6-by-4 grid.  Start by
% creating some example data: 
% Plot all 24 datasets in a 6-by-4 grid with smplot(6,4,.... We'll
% leave 10% of the figure width on the right-hand-side empty so we can put
% a colorbar there.  That extra space on the right-hand-side is obtained by
% 'right',0.1. All subplots will share the same
% colorbar, so be sure to set the same values of caxis for each subplot. 
% 
% % Create some example data: 
% [X,Y,Z] = peaks(300);
% xv=[-66,-104,-151,-193,-133,-125,-75,-6,133,234,196,204,132,117]/100;
% yv=[276,220,89,-38,-134,-222,-268,-280,-259,-213,-104,66,162,252]/100; 
% in = inpolygon(X,Y,xv,yv); 
% Z(~in) = NaN; 
% 
% % Plot 24 datasets: 
% for k = 1:24
%     smplot(6,4,k,'right',0.1)
%     pcolor(X,Y,Z+3*randn(1)+3*sin(k/4))
%     shading flat
%     caxis([-12 12])
%     axis off
% end
% cb = colorbar('east'); 
% set(cb,'Position',[0.92 0.1 0.04 0.8])
% 
%% Example 3: Leave room for axis labels
% If you want a little bit of room for axis labels between each subplot,
% specify 'axis', 'on' when you call smplot: 
%  
% for k = 1:12
%     smplot(3,4,k,'axis','on')
%     plot(rand(6,2),'p');
%     axis tight 
% end
% 
%% Author Info
% This function was written by Chad A. Greene of the University of Texas at
% Austin's Institute for Geophysics (UTIG), September 2015. 
% http://www.chadagreene.com 
% 
% See also subplot, figure, axes, and axis. 

%% Initial error checks: 

narginchk(3,inf)

%% Set default margins: 

left = 0;
right = 0; 
top = 0; 
bottom = 0; 
RoomForAxisLabels = false; 

%% Parse inputs: 

if nargin>3
    BadMarginMsg = 'Margin width must be a scalar value between zero and one.'; 
    
    tmp = strncmpi(varargin,'left',3);
    if any(tmp)
        left = varargin{find(tmp)+1}; 
        assert(isscalar(left)==1,BadMarginMsg)
        assert(left>=0,BadMarginMsg)        
        assert(left<=1,BadMarginMsg)
    end
    
    tmp = strncmpi(varargin,'right',3);
    if any(tmp)
        right = varargin{find(tmp)+1};  
        assert(isscalar(right)==1,BadMarginMsg)
        assert(right>=0,BadMarginMsg)        
        assert(right<=1,BadMarginMsg)
    end
    
    tmp = strncmpi(varargin,'top',3);
    if any(tmp)
        top = varargin{find(tmp)+1};  
        assert(isscalar(top)==1,BadMarginMsg)
        assert(top>=0,BadMarginMsg)        
        assert(top<=1,BadMarginMsg)
    end
    
    tmp = strncmpi(varargin,'bottom',3);
    if any(tmp)
        bottom = varargin{find(tmp)+1};  
        assert(isscalar(bottom)==1,BadMarginMsg)
        assert(bottom>=0,BadMarginMsg)        
        assert(bottom<=1,BadMarginMsg)
    end
    
    assert(left+right<1,'Left plus right margins cannot exceed unity. Because then there''d be no room for any data.')
    assert(top+bottom<1,'Top plus bottom margins cannot exceed unity. Because then there''d be no room for any data.')

    tmp = strncmpi(varargin,'axis',2); 
    if any(tmp)
        AxInput = varargin{find(tmp)+1}; 
        switch lower(AxInput)
            case {'on',true}
                RoomForAxisLabels = true; 
                
            case {'off',false} 
                RoomForAxisLabels = false; 
                
            otherwise
                error('Unrecognized ''axis'' property. This probably means you followed the word ''axis'' with some word that is not ''on'' or ''off''.')
                            
        end
    end
        
end

%%

coli = rem(p,cols); 
if coli==0
    coli=cols; 
end

coli(coli==0)=1; 
coli = coli-1; 

rowi = rows - (ceil(p/cols));

if RoomForAxisLabels
    axes('OuterPosition',[(1-(left+right))*coli/cols+left (1-(top+bottom))*rowi/rows+bottom (1-(left+right))/cols (1-(top+bottom))/rows],'units','normalized'); 
else
    axes('Position',[(1-(left+right))*coli/cols+left (1-(top+bottom))*rowi/rows+bottom (1-(left+right))/cols (1-(top+bottom))/rows],'units','normalized'); 
end

%% Make outputs: 

if nargout~=0
    h = gca; 
end

end