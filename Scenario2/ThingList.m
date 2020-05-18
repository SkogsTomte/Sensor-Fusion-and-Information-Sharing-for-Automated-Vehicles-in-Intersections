classdef ThingList < handle
    %This class is basicly just a list which holds Thing-objects
    properties
        list
        len
    end
    
    methods
        function obj = ThingList(thing)
            obj.list = thing;
            obj.len = 1;
        end
        
        function obj = addThing(obj,thing)
            obj.list = [obj.list,thing];
            obj.len = obj.len+1;
        end
    end
end

