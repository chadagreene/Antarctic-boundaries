
% There's probably no need to ever open or run this script, but I'm including it here
% just for anyone who's interested in how the sausage gets made. 
% 
% This script reformats shapefiles into .mat files, as to elimiate dependence 
% on Matlab's Mapping Toolbox. 
% 
% -Chad

%% Coastline: 

S = shaperead('Coastline_Antarctica_v2');

x = S.X(1:end-1); 
y = S.Y(1:end-1); 

note = 'This is Coastline_Antarctica_v2.shp data, from MEaSURES Antarctic Boundaries for IPY 2007-2009 from Satellite Radar, Version 2 (http://dx.doi.org/10.5067/AXE4121732AD. ).'; 

save('coastline_2008_v2.mat','x','y','note'); 

%% Grounding line: 

clear all

S = shaperead('GroundingLine_Antarctica_v2');

x = S.X(1:end-1); 
y = S.Y(1:end-1); 

note = 'This is GroundingLine_Antarctica_v1.shp data, from MEaSURES Antarctic Boundaries for IPY 2007-2009 from Satellite Radar, Version 2 (http://dx.doi.org/10.5067/AXE4121732AD. ).'; 

save('groundingline_2008_v2.mat','x','y','note'); 

%% Ice shelves 

clear all

S = shaperead('IceShelf_Antarctica_v2');

for k = 1:length(S)
      xtmp{k} = (S(k).X)'; 
      ytmp{k} = (S(k).Y)'; 
      nametmp{k} = S(k).NAME; 
end

nametmp{153} = 'Fox Glacier'; 
nametmp{172} = 'Fox Ice Stream'; 

% Sort alphabetically: 
[nametmp,ind] = sortrows(nametmp'); 
xtmp = xtmp(ind); 
ytmp = ytmp(ind); 

name = unique(nametmp); 


for k = 1:length(name) 
   tmp = find(strcmp(nametmp,name(k))); 
   if isscalar(tmp)
      x{k} = xtmp{tmp}; 
      y{k} = ytmp{tmp}; 
   else
      x{k} = xtmp{tmp}; 
      y{k} = ytmp{tmp}; 
      for kk = 2:length(tmp)
         x{k} = [x{k};xtmp{tmp(kk)}]; 
         y{k} = [y{k};ytmp{tmp(kk)}]; 
      end
   end
end

% Replace underscores with spaces: 
name = strrep(name,'_',' '); 

readme = 'This is IceShelf_Antarctica_v2.shp data, from MEaSURES Antarctic Boundaries for IPY 2007-2009 from Satellite Radar, Version 2 (http://dx.doi.org/10.5067/AXE4121732AD. ).'; 

save('iceshelves_2008_v2.mat','x','y','name','readme'); 
% plot(cell2mat(x(:)),cell2mat(y(:)),'r')

%% Basins IMBIE

clear all
S = shaperead('Basins_IMBIE_Antarctica_v2.shp');


for k = 1:length(S)
      xtmp{k} = (S(k).X)'; 
      ytmp{k} = (S(k).Y)'; 
      nametmp{k} = S(k).NAME; 
end

% Sort alphabetically: 
[nametmp,ind] = sortrows(nametmp'); 
xtmp = xtmp(ind); 
ytmp = ytmp(ind); 

name = unique(nametmp); 


for k = 1:length(name) 
   tmp = find(strcmp(nametmp,name(k))); 
   if isscalar(tmp)
      x{k} = xtmp{tmp}; 
      y{k} = ytmp{tmp}; 
   else
      x{k} = xtmp{tmp}; 
      y{k} = ytmp{tmp}; 
      for kk = 2:length(tmp)
         x{k} = [x{k};xtmp{tmp(kk)}]; 
         y{k} = [y{k};ytmp{tmp(kk)}]; 
      end
   end
end

% Replace underscores with spaces: 
name = strrep(name,'_',' '); 

note = 'This is Basins_IMBIE_Antarctica_v2.shp data, from MEaSURES Antarctic Boundaries for IPY 2007-2009 from Satellite Radar, Version 2 (http://dx.doi.org/10.5067/AXE4121732AD. ).'; 

save('basins_IMBIE_v2.mat','x','y','name','note'); 


%% Basins 

clear all

S = shaperead('Basins_Antarctica_v2.shp');


for k = 1:length(S)
      xtmp{k} = (S(k).X)'; 
      ytmp{k} = (S(k).Y)'; 
      nametmp{k} = S(k).NAME; 
end

% Sort alphabetically: 
[nametmp,ind] = sortrows(nametmp'); 
xtmp = xtmp(ind); 
ytmp = ytmp(ind); 

name = unique(nametmp); 


for k = 1:length(name) 
   tmp = find(strcmp(nametmp,name(k))); 
   if isscalar(tmp)
      x{k} = xtmp{tmp}; 
      y{k} = ytmp{tmp}; 
   else
      x{k} = xtmp{tmp}; 
      y{k} = ytmp{tmp}; 
      for kk = 2:length(tmp)
         x{k} = [x{k};xtmp{tmp(kk)}]; 
         y{k} = [y{k};ytmp{tmp(kk)}]; 
      end
   end
end

% Replace underscores with spaces: 
name = strrep(name,'_',' '); 

note = 'This is Basins_Antarctica_v2.shp data, from MEaSURES Antarctic Boundaries for IPY 2007-2009 from Satellite Radar, Version 2 (http://dx.doi.org/10.5067/AXE4121732AD. ).'; 

save('basins_refined_v2.mat','x','y','name','note'); 


%% Ice Boundaries: REDUNDANT WITH OTHER SHAPEFILES.  

% clear all
% 
% S = shaperead('IceBoundaries_Antarctica_v1');
% 
% hold on
% for k = 1:178
%    x{k} = S(k).X; 
%    y{k} = S(k).Y; 
%    name{k} = S(k).NAME; 
%    plot(x{k},y{k})
% end
% 
% note = 'This is IceBoundaries_Antarctica_v1.shp data, from MEaSURES Antarctic Boundaries for IPY 2007-2009 from Satellite Radar, Version 2 (http://dx.doi.org/10.5067/AXE4121732AD. ).'; 

% save('iceboundaries_2008_v2.mat','x','y','note'); 



