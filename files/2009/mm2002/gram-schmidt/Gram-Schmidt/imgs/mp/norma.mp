input jh
ahangle:=40;

input arrow
%input jh3d

beginfig(1) % a vec as sum of two others; illustrate Triangle Inequality
  numeric u;  %scaling factor
  numeric v;  %vertical scaling factor
  numeric w;  %horizontal scaling factor
  u:=.2in; v:=u; w:=v;

  numeric n; %what percentage of arrow ends to knock off?
  n:=.01;
  pickup pencircle scaled line_width_light;
  z0=(0w,0v); z1=(5w,.65v);
  drawarrow (.5n[z0,z1])--((1-n)[z0,z1]);
    label.bot(btex {$\mu$} etex,.5[z0,z1]);
  z2=(6w,3v);
  drawarrow (n[z1,z2])--((1-n)[z1,z2]);
    label.rt(btex {$\nu$} etex,.5[z1,z2]);
  pickup pencircle scaled line_width_dark;
  z4=0.02*(-1*(y2-y0),x2-x0);  % perp to hyp to offset from w's arrow
  drawarrow (.5n[z0,z2]+z4)--((1-n)[z0,z2]+z4);
    label.ulft(btex {$\nu+\mu$} etex,.5[z0+z4,z2+z4]);
  z5=whatever[z0,z1]=whatever[n[z0,z2]+z4,(1-n)[z0,z2]+z4];
  drawpoint(z5);
    label.lft(btex {inicio} etex,z5);
  z6=whatever[z1,z2]=whatever[n[z0,z2]+z4,(1-n)[z0,z2]+z4];
  drawpoint(z6);
    label.rt(btex {{fin}} etex,z6);
endfig;