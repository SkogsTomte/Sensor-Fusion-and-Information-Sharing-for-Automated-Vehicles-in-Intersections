classdef Thing < handle

    properties
        lost%   1 if object wasn't detected last timestep
        pos
        lastPos
        vel
        detected%1 If object was detected this timestep
        found% 1 If object was detected and uppdated this timestep
        P%  P-value for kalman filter
        ego%    Data for the vehicle which detected the object
        egoNr%  Number for that vehicle
        lastEgo
    end
        
    methods
        function obj = Thing(p,v,e,en,le)
            obj.lastEgo = le;
            obj.ego = e;
            obj.egoNr = en;
            obj.pos = p;
            obj.lastPos = [];
            obj.vel = v;
            obj.P = [0.02,0.06];
            obj.found = 0;
            obj.lost = 0;
            obj.detected = 0;
        end
        
        function uppdate(obj,p,v,T,e,en)
            obj.lastEgo = obj.ego;
            obj.ego = e;
            obj.egoNr = en;
            Pprev=obj.P;
            
            if isempty(obj.lastPos)
                Q=[0.04,0.055];
                R=[0.0177,0.0397];
                obj.lastPos = obj.pos;
                [obj.pos,obj.P] = kalmanf(p, obj.pos, v, obj.vel,Pprev,Q,R,T);
            else
                Q=[0.0354,0.0794];
                R=[0.0177,0.0397];
                lastPos = obj.lastPos;
                obj.lastPos = obj.pos;
                [obj.pos,obj.P] = kalmanf(p, obj.pos, (obj.pos-lastPos)/T, (obj.pos-lastPos)/T,Pprev,Q,R,T);
            end
            obj.lastPos = obj.pos;
            obj.vel = v;
            obj.detected = 1;
            obj.found = 1;
            obj.lost = 0;
        end
        
        function [posGuess,velGuess] = nextGuess(obj,T)
            posGuess = obj.pos + obj.vel.*T;
            velGuess = obj.vel;
        end
        
        function thing = globalThing(obj)
            [x,y] = toGlobal(obj.pos(1),obj.pos(2),obj.ego,0);
            coord = [x;y];
            [x,y] = toGlobal(obj.vel(1),obj.vel(2),obj.ego,1);
            vel = [x;y];
            thing = Thing(coord,vel,obj.ego,obj.egoNr,obj.lastEgo);
            if ~isempty(obj.lastPos)
                [x,y] = toGlobal(obj.lastPos(1),obj.lastPos(2),obj.lastEgo,0);
                thing.lastPos = [x;y];
            end
        end
        function thing = localThing(obj,newEgo,newEgoNr,lastEgo)
            %SHOULD ONLY BE CALLED IF THE THING HAS GLOBAL COORDINATES
            [x,y] = toLocal(obj.pos(1),obj.pos(2),newEgo);
            coord = [x;y];
            [x,y] = toLocal(obj.vel(1),obj.vel(2),newEgo);
            vel = [x;y];
            thing = Thing(coord,vel,newEgo,newEgoNr,lastEgo);
            if ~isempty(obj.lastPos)
                [x,y] = toLocal(obj.lastPos(1),obj.lastPos(2),newEgo);
                thing.lastPos = [x;y];
            end
        end
    end
end

