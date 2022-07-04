clc
a=6378137; % semi-major axis GRS80
f=1/298.257222101; % flattening GRS80
ekw=2*f-f^2; % first eccentricity GRS80
b = a*sqrt(1-ekw);
deg = pi / 180;
rad = 180 / pi;

phi=39 + 52/60 + 20.176/3600;
lam=32 +  45/60 + 42.451/3600;

phi1 = phi * deg;
lam1 = lam * deg;
h1 = 100;

N = a ./ sqrt(1 - ekw .* sin(phi1).^2);
x = (N + h1) .* cos(phi1) .* cos(lam1);
y = (N + h1) .* cos(phi1) .* sin(lam1);
z = ((1 - ekw) .* N + h1) .* sin(phi1);

p = sqrt(x.^2+y.^2);
firad(1) = atan(z/p); % as 1st approximation of geodetic latitude - geocentric
h(1) = 0;
for i=1:5
  
  N(i) = a/sqrt(1-ekw*sin(firad(i))^2); % successive iterations of curvature radius N
  h(i+1) = p/cos(firad(i))-N(i); % successive iterations of ellipsoidal height
  firad(i+1) = atan((z/p)*(1-ekw*(N(i)/(N(i) + h(i+1))))^-1); % it. of geod. latitude
  
end
lastv = firad(end);
lastv1 = lastv * rad;
latitude = change(lastv1)

h1 = h(end)
longitude = change(lam)

% Plot
figure
[xe, ye, ze] = ellipsoid(0,0,0,a,a,b,30); % function for drawing the ellipsoid
surf(xe, ye, ze);
##alpha(0.5) % parameter of transparency
##axis equal
hold on
plot3(x,y,z,'bo','MarkerSize',20,'MarkerFaceColor','g');
hold on

% yellow dot denotes zero meridian
plot3(a,0,0,'ro','MarkerSize',20,'MarkerFaceColor','y');
hold off

fid = fopen('ofile.txt','w');
fprintf(fid,'%14.8f %14.8f %10.3f\n', [phi1, lam1, h1]');
fclose('all');