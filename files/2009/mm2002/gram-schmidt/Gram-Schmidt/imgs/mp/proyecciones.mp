input jh
ahangle:=40;

input arrow
%input jh3d

beginfig(1) % stick figure
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
  label.lrt(btex {$\ell$} etex,.618[z0,z2]);


  z4=whatever[z0,z2]; x4=xpart(point 1 of xaxis); % other endpoint of line
  pickup pencircle scaled line_width_light;
  draw z3--z4;
  pickup pencircle scaled line_width_dark; % white out a part of line
  save cps;
  boxit.cps(nullpicture); cps.c=z2; cps.dx=cps.dy=1pt;
    draw z0--z2 withcolor white;
  pickup pencircle scaled line_width_dark; % vector projected to
  drawarrow z0--z2 cutafter bpath cps;

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

  % draw the dotted line
  save circlepath; path circlepath;
    circlepath=makepath(pencircle scaled (2.1*u)) shifted z2;
  save perppath; path perppath;
    z11=whatever[z10,z2]; y11=ypart(point 1 of yaxis); % end of dotted line
    z12=whatever[z10,z2]; y12=ypart(point 0 of yaxis); % other end
    perppath=z11--z12;
  save inttime; numeric inttime[];
    inttime1=ypart(circlepath intersectiontimes perppath);
    inttime2=xpart(perppath intersectiontimes (z3--z4));
  pickup pencircle scaled line_width_light; % 
  draw (point 0 of perppath)--(point inttime1 of perppath) dashed withdots scaled .5;
  draw (point inttime2 of perppath)--(point 1 of perppath) dashed withdots scaled .5;
    
  pickup pencircle scaled line_width_light; % little person
  drawstickfigure(u) shifted z1 rotated 20;
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

	label.bot (btex $c\mu$ etex, z2);
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
	    label.ulft(btex {$\nu$} etex,.618[z0,z10]);

	  % draw the dotted line
	  save perppath; path perppath;
	    z11=whatever[z10,z2]; y11=ypart(point 1 of yaxis); % end of dotted line
	    z12=whatever[z10,z2]; y12=ypart(point 0 of yaxis); % other end
	    perppath=z11--z12;
	  pickup pencircle scaled line_width_light; % 
	  %draw perppath dashed withdots scaled .5;
	  pickup pencircle scaled line_width_dark; % 
	  drawarrow z2--z10 cutbefore bpath cps cutafter bpath v; 
	  label.rt(btex {$\nu-c\mu$} etex,.618[z2,z10]);
endfig;

beginfig(3)  % projection from (2,3) to line thru (1,2)
  numeric u;  %scaling factor
  numeric v;  %vertical scaling factor
  numeric w;  %horizontal scaling factor
  u:=.2in; v:=u; w:=v;

  path xaxis, yaxis;
  xaxis = (-.5w,0v)--(2.5w,0v); yaxis = (0w,-.5v)--(0w,3.75v);  
  pickup pensquare scaled line_width_light;
  draw xaxis;  draw yaxis;
    updown_ticks(2,(w,0),(w,0));  sidetoside_ticks(3,(0w,1v),(0w,1v));
  
  z0=(0,0); 
  z2=(8w/5,16v/5);  % endpoint of vector projected from
  z3=whatever[z0,z2]; y3=ypart(point 0 of yaxis); % endpoint of line
  z4=whatever[z0,z2]; y4=ypart(point 1 of yaxis); % other endpoint of line
  pickup pencircle scaled line_width_light;
  draw z3--z4;
  pickup pencircle scaled line_width_dark; % white out a part of line
  save cps; 
  boxit.cps(nullpicture); cps.c=z2; cps.dx=cps.dy=1pt;
    draw .5[z0,z2]--z2 withcolor white;
  pickup pencircle scaled line_width_dark; % vector projected to
  drawarrow z0--z2 cutafter bpath cps;

  z5=(2w,3v);
  z6=whatever[z0,z5]; y6=ypart(point 0 of yaxis); % endpoint of line
  z7=whatever[z0,z5]; y7=ypart(point 1 of yaxis); % other endpoint of line
  %pickup pencircle scaled line_width_light;
  %draw z6--z7;

  save v;
  boxit.v(nullpicture); v.c=z5; v.dx=v.dy=1pt;
  pickup pencircle scaled line_width_dark; % white out a part of line
    draw .5[z0,z5]--z5 withcolor white;
  pickup pencircle scaled line_width_dark; % vector projected to
  drawarrow z0--z5 cutafter bpath v;

  % draw the dotted line
  save perppath; path perppath;
    z11=whatever[z5,z2]; y11=ypart(point 1 of yaxis); % end of dotted line
    z12=whatever[z5,z2]; y12=xpart(point 1 of xaxis); % other end
    perppath=z11--z12;
  pickup pencircle scaled line_width_light; % 
  draw perppath dashed withdots scaled .5;
endfig;

end


