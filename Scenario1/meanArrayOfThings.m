function [posMean,velMean] = meanArrayOfThings(things)
%Things is a ThingList
%Calculates mean value of position and velocity
xsumPos = 0;
ysumPos = 0;
xsumVel = 0;
ysumVel = 0;
for i=1:things.len
    xsumPos = xsumPos + things.list(i).pos(1);
    ysumPos = ysumPos + things.list(i).pos(2);
    xsumVel = xsumVel + things.list(i).vel(1);
    ysumVel = ysumVel + things.list(i).vel(2);
end
posMean = [xsumPos/things.len;ysumPos/things.len];
velMean = [xsumVel/things.len;ysumVel/things.len];
end

