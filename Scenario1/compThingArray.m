function [posDiff,velDiff] = compThingArray(thing,pos,vel,next)
%Compares an object "Thing" with given pos and vel
if next==1
    [posGuess,velGuess] = thing.nextGuess(0.02);
else
    posGuess = thing.pos;
    velGuess = thing.vel;
end
posDiff = norm(pos-posGuess);
velDiff = norm(vel-velGuess);
end

