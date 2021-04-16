function h = label_basins(basinDataset,varargin)
% label_basins places text labels in IMBIE or IMBIE refined ice basins. 
% 
%% Syntax
% 
%  label_basins(basinDataset)
%  label_basins(...,'largest',N)
%  label_basins(...,TextProperty,Value,...) 
%  h = label_basins(...)
%
%% Description 
% 
% label_basins(basinDataset) labels either 'imbie' or 'imbie refined' basins. 
%
% label_basins(...,'largest',N) labels only the N largest basins by area. 
%
% label_basins(...,TextProperty,Value,...) specifies text properties. 
%
% h = label_basins(...) returns a handle h of the text object(s). 
% 
%% Example
% 
%
%% Author Info
% Written by Chad A. Greene, November 2018. 
% 
% See also plot_basins and antbounds. 

%% Parse inputs: 

narginchk(1,Inf)

tmp = strncmpi(varargin,'largest',4); 
if any(tmp)
   N = varargin{find(tmp)+1}; 
   assert(isscalar(N),'Error: N largest values must be a scalar must be a scalar.') 
   tmp(find(tmp)+1) = 1; 
   varargin = varargin(~tmp); 
end

switch lower(basinDataset) 
   case 'imbie'
      filename = 'basins_IMBIE_v2.mat'; 
      
   case {'refined','imbie refined','imbierefined'} 
      filename = 'basins_refined_v2.mat'; 

   otherwise
      error('basinDataset can only be ''imbie'' or ''imbie refined''.') 
end

%% Load Data

B = load(filename); 

if strcmp(filename,'basins_refined_v2.mat')
   % Eliminate "Islands" 
   B.x(69)=[]; 
   B.y(69)=[]; 
   B.name(69)=[]; 
end   

%% Calculate statistics: 

Nb = length(B.x); % number of basins

if ~exist('N','var')
   N = Nb;
end

% Preallocate centroid locations and areas: 
xc = nan(Nb,1); 
yc = nan(Nb,1); 
A = nan(Nb,1); 

% Get centroid location and area of each polyshape: 
for k = 1:Nb
   pgon = polyshape(B.x{k},B.y{k},'Simplify',false); 
   [xc(k),yc(k)] = centroid(pgon); 
   A(k) = area(pgon); 
end

% Sort by area: 
[~,ind] = sort(A,'descend'); 
xc = xc(ind); 
yc = yc(ind); 
B.name = B.name(ind); 

%% Label basins: 

h = text(xc(1:N),yc(1:N),B.name(1:N),'vert','middle','horiz','center','fontsize',8,varargin{:}); 

%% Clean up:

if nargout==0 
   clear h
end
