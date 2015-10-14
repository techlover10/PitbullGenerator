classdef MarkovCitiesChain < handle
   %Markov chain consisting of cities
    
    properties
        converted
        endVal
    end
    
    methods
        function c = MarkovCitiesChain(length,endVal)
       
        c.converted = cell(1,length);
        for i = 1:1:length
            c.converted{i} = 'city';
        end
        c.endVal = endVal;
        end
    end
    
end

