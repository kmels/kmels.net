transform pagecoords;

% CH3.mp
%  MetaPost input file with chapter three pictures.

%&latex
\documentclass{book}
\usepackage{dvidrv} \usepackage{hrefout}
% \usepackage{bookjh,linalgjh}
\usepackage{verbatim}
\begin{document}
etex

input jh
ahangle:=40;

input arrow
%input jh3d

pagecoords:=identity scaled 15mm shifted (100mm,150mm);
beginfig (1);
    % declare paths to be used
    path p[],p[]t;
    % set up points by defining relationships
    z1=(0,0);   z2=z1+2up;
    z3=z1+whatever*dir (60)=z2+whatever*dir (-50);
    z4=z3+(-1.5,-.5);
    z5=z1+dir (135);
    z0=whatever[z1,z2]=whatever[z3,z4];
    % set up paths
    p0=fullcircle yscaled .5 rotated 45 shifted z0 ;
    p1=z2--z4..z0..z3---z1;
    p2=p1 cutbefore p0 cutafter p0;
    p3=p0 cutbefore p1 cutafter p1;
    p4=p2--p3--cycle;
    % define transformed versions of paths and points
    for i=0 upto 4: p[i]t=p[i] transformed pagecoords; endfor
    for i=0 upto 5: z[i]t=z[i] transformed pagecoords; endfor
    % do some drawing
    fill p4t withcolor (1,1,0.2);
    draw z1t--z2t withcolor .5white;
    draw z3t--z4t withcolor .5white;
    pickup pencircle;
    draw p0t dashed withdots scaled .3;
    draw p1t dashed evenly;
    draw p2t withcolor blue;
    draw p3t withcolor red;
    label.lrt (btex $c_{\vec{p}}\vec{s}$ etex, z0t);
    label.llft (btex $z_90$ etex, z1t);
    label.top (btex $z_20$ etex, z2t);
    label.rt (btex $z_3$ etex, z3t);
    label.llft (btex $z_4$ etex, z4t);
    for i=0 upto 4:
        drawdot z[i]t withpen pencircle scaled 2;
    endfor
endfig;

beginfig(2) 
numeric u;  %scaling factor
  numeric v;  %vertical scaling factor
  numeric w;  %horizontal scaling factor
  u:=.2in; v:=u; w:=v;

  path xaxis, yaxis;
  xaxis = (-.5w,0v)--(4.5w,0v); yaxis = (0w,-.5v)--(0w,3.5v);  
  pickup pensquare scaled line_width_light;
  draw xaxis;  draw yaxis;
  
  z0=(0,0); z1=(3u,0v);
  z2=z1 rotated 20;  % endpoint of vector projected onto
  z3=whatever[z0,z2]; x3=xpart(point 0 of xaxis); % endpoint of line
  z4=whatever[z0,z2]; x4=xpart(point 1 of xaxis); % other endpoint of line
  pickup pencircle scaled line_width_light;
  draw z3--z4;
  pickup pencircle scaled line_width_dark; % white out a part of line
  save cps;
  boxit.cps(nullpicture); cps.c=z2; cps.dx=cps.dy=1pt;
  draw z0--z2 withcolor white;
  pickup pencircle scaled line_width_dark; % vector projected to
  drawarrow z0--z2 cutafter bpath cps;

	label.bot (btex $c_{\vec{p}}\vec{s}$ etex, z2);
	z5=z1 rotated 55;
	  z6=whatever[z0,z5]; y6=ypart(point 0 of yaxis); % endpoint of line
	  z7=whatever[z0,z5]; y7=ypart(point 1 of yaxis); % other endpoint of line
	  %pickup pencircle scaled line_width_light;
	  %draw z6--z7;

	  % find endpoint of vector on z6--z7 that projects to z0--z2 vector 
	  z10=whatever[z6,z7]; z10-z2=whatever*(z2-z0) rotated 90; % MFBook ex 9.6 
	  save v;
	  boxit.v(nullpicture); v.c=z10; v.dx=v.dy=1pt;
	  pickup pencircle scaled line_width_dark; % white out a part of line
	    draw z0--z10 withcolor white;
	  pickup pencircle scaled line_width_dark; % vector projected to
	  drawarrow z0--z10 cutafter bpath v;
	    label.ulft(btex {$\vec{v}$} etex,.618[z0,z10]);

	  % draw the dotted line
	  save perppath; path perppath;
	    z11=whatever[z10,z2]; y11=ypart(point 1 of yaxis); % end of dotted line
	    z12=whatever[z10,z2]; y12=ypart(point 0 of yaxis); % other end
	    perppath=z11--z12;
	  pickup pencircle scaled line_width_light; % 
	  %draw perppath dashed withdots scaled .5;
	  pickup pencircle scaled line_width_dark; % 
	  drawarrow z2--z10 cutbefore bpath cps cutafter bpath v; 
	  label.rt(btex {$\vec{v}-c_{\vec{p}}\vec{s}$} etex,.618[z2,z10]);
endfig;
bye
