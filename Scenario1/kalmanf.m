function [xhatt,P] = kalmanf(xhattmeas, xhattprev, vhattmeas, vhattprevmeas, Pprev, Q, R, T)

Kx = (Pprev(1) +Q(1))/ (Pprev(1) + Q(1) + R(1));
Ky = (Pprev(2) +Q(2))/ (Pprev(2) + Q(2) + R(2));

P = [(1-Kx)*Pprev(1),(1-Ky)*Pprev(2)];

xhattmod = xhattprev + T*( (vhattmeas + vhattprevmeas)/2 );

xhatt(1) = xhattmod(1) + Kx*( xhattmeas(1) - xhattmod(1) );
xhatt(2) = xhattmod(2) + Ky*( xhattmeas(2) - xhattmod(2) );
end
