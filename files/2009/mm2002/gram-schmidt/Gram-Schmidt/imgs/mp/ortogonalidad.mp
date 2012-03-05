input jh
input arrow
ahangle:=40;

beginfig(1) % two vectors in plane, orthogonal
  numeric u;  %scaling factor
  numeric v;  %vertical scaling factor
  numeric w;  %horizontal scaling factor
  u:=.14in; v:=u; w:=v;

  % onetwo_axes without the negative x's
  pickup pencircle scaled line_width_light;
  draw (-.5w,0v)--(3.5w,0v);
  draw (0w,-.5v)--(0w,3.5v);
  updown_ticks(3,(1w,0v),(1w,0v));
  sidetoside_ticks(3,(0w,1v),(0w,1v));

  pickup pencircle scaled line_width_dark;
  z0=(0w,2v); z1=(1w,1v); 
  drawarrow z0--z1;
  z3=(2w,2v); z4=(3w,3v); 
  drawarrow z3--z4;
%  label.rt(btex {\scriptsize
%              $\colvec{1 \\ -1}\dotprod\colvec{1 \\ 1}=0$} etex,(3w,1.5v));
endfig;