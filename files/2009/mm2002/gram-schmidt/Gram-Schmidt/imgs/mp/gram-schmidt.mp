input jh
ahangle:=40;

input arrow
%input jh3d

beginfig(1) 
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

	label.bot (btex $proj_{\mu}(\nu)$ etex, (60,18));

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
	  label.rt(btex {$\nu-proj_{\mu}(\nu)$} etex,.618[z2,z10]);
endfig;


beginfig(2) % non-orthogonal basis for G-S
  numeric u;  %scaling factor
  numeric v;  %vertical scaling factor
  numeric w;  %horizontal scaling factor
  u:=.2in; v:=u; w:=v;

  path xaxis, yaxis;
  xaxis = (-.5w,0v)--(4.5w,0v); yaxis = (0w,-.5v)--(0w,3.5v);  
  pickup pensquare scaled line_width_light;
  draw xaxis;  updown_ticks(4,(1w,0),(1w,0));
  draw yaxis;  sidetoside_ticks(3,(0,1v),(0,1v));

  z0=(0w,0v);
  z1=(4w,2v);  % endpoint of beta_1
  z2=(1w,3v);  % endpoint of beta_2
  pickup pencircle scaled line_width_dark;
  drawarrow z0--z1; 
    label.lrt(btex {$\omega_1$} etex,z1);
  drawarrow z0--z2;
    label.lrt(btex {$\omega_2$} etex,z2);
endfig;

beginfig(3) % non-orthogonal's post G-S ortho basis
  numeric u;  %scaling factor
  numeric v;  %vertical scaling factor
  numeric w;  %horizontal scaling factor
  u:=.2in; v:=u; w:=v;

  path xaxis, yaxis;
  xaxis = (-.5w,0v)--(4.5w,0v); yaxis = (0w,-.5v)--(0w,3.5v);  
  pickup pensquare scaled line_width_light;
  draw xaxis;  updown_ticks(4,(1w,0),(1w,0));
  draw yaxis;  sidetoside_ticks(3,(0,1v),(0,1v));

  z0=(0w,0v);
  z1=(4w,2v);  % endpoint of beta_1
  z2=(1w,3v);  % endpoint of beta_2
  z3=(2w,1v);
  save b_three, b_two;
  circleit.b_three(nullpicture); b_three.c=z3; b_three.dx=b_three.dy=2pt;
  circleit.b_two(nullpicture); b_two.c=z2; b_two.dx=b_two.dy=2pt;

  pickup pencircle scaled line_width_light;
  z4=whatever[z0,z1]; x4=xpart(point 0 of xaxis);
  draw z0--z4;
  draw z3--z1 cutbefore bpath b_three; % line projected to
    %label.lrt(btex {$\omega_1$} etex,z1);
  
  pickup pencircle scaled line_width_dark;
  drawarrow z0--z3 cutafter bpath b_three; 
  drawarrow z0--z2 cutafter bpath b_two;
  drawarrow z3--z2 cutbefore bpath b_three cutafter bpath b_two;
    label.rt(btex {$\nu_2$} etex,.618[z3,z2]);
endfig;