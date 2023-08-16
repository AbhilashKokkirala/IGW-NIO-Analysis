tic;
clc;clear all;close all;
format long;
dnum_start = datenum('01-Oct-2015 00:00:00','dd-mmm-yyyy HH:MM:SS');
DIR_INPUT='G:\Abhilash\IGW\data';
S = dir(fullfile(DIR_INPUT,'*avg_*.nc'));

z=nan(1440,51);
w=nan(1440,51);
ocean_time=nan(1,1440);
%%
ncid = netcdf.open([DIR_INPUT,'/',S(20).name]);

%
varid_lat_rho=netcdf.inqVarID(ncid,'lat_rho');
lat_rho = netcdf.getVar(ncid,varid_lat_rho);
%
varid_lon_rho=netcdf.inqVarID(ncid,'lon_rho');
lon_rho = netcdf.getVar(ncid,varid_lon_rho);

%
lon_rho=lon_rho(:,1);
lat_rho=lat_rho(1,:)';


%
varid_c_sigma=netcdf.inqVarID(ncid,'Cs_w');
c_sigma=netcdf.getVar(ncid,varid_c_sigma);

%
varid_h=netcdf.inqVarID(ncid,'h');
h=netcdf.getVar(ncid,varid_h);

%
varid_sigma=netcdf.inqVarID(ncid,'s_w');
sigma=netcdf.getVar(ncid,varid_sigma);

%
N=51;

%
varid_hc=netcdf.inqVarID(ncid,'hc');
hc=netcdf.getVar(ncid,varid_hc);

netcdf.close(ncid);

for i=1267:1440
    ncid = netcdf.open([DIR_INPUT,'/',S(i).name]);
    varid_ocean_time=netcdf.inqVarID(ncid,'ocean_time');
    ocean_time(i)= netcdf.getVar(ncid,varid_ocean_time);

    varid_zeta=netcdf.inqVarID(ncid,'zeta');
    zeta = netcdf.getVar(ncid,varid_zeta);
    zeta(zeta>10^3)=NaN;
    varid_w=netcdf.inqVarID(ncid,'w');
    temp_w = squeeze(netcdf.getVar(ncid,varid_w,[216,241,0,0],[1,1,51,1]));
    netcdf.close(ncid);
    z_w=set_depth_nihar_roms(hc,N,h,zeta,sigma,c_sigma);
    z_w=squeeze(z_w(217,242,:));
    %w(i,:)=squeeze(temp_w(217,242,:,1));
    w(i,:)=temp_w;
    %z(i,:)=z_w;
    disp(i);
end

%[217,242,1,0],[0,0,51,1]
% 
%%
dnum_start=datenum('01-Oct-2015 00:00:00','dd-mmm-yyyy HH:MM:SS');
dnum_avg=dnum_start+seconds(ocean_time);
figure(1)
set(gcf,'position',[2000 148 1519 816]);
pcolor(repmat(dnum_avg',[1,51]),z,w*86400);
shading interp;
set(gca,'layer','top','fontweight','bold','fontsize',10,'linewidth',2);
colormap winter;%(gca,cmocean('balance',256));
ylabel('Z (m)');
%axdate('x',30);
caxis([-10 10]);
ccc=colorbar();
ylim([-100 0]);


