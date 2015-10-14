classdef SyllableChain < handle
    %Takes a Markov chain of only numbers (assumes it is set to become a
    %syllable chain, and limits the number of syllables per line
    
    properties
        syllableLimit
        sChain
        %endIdx
    end
    
    methods
        function self = SyllableChain(MarkovChain,syllableLimit)
            %---set properties---
            self.syllableLimit = syllableLimit;
            self.sChain = MarkovChain.endChain;
            
            
            
            sum = 0;
            endIdx = 0;
            for i = 1:1:length(self.sChain)
                sum = sum + self.sChain(i);
                if sum > syllableLimit
                    self.sChain(i) = self.sChain(i) - (sum-syllableLimit);
                    sum = syllableLimit;
                    for ind = i+1:1:length(self.sChain)
                        self.sChain(ind) = 0;
                    end
                    if endIdx == 0
                        endIdx = i;
                    end
                end
            end
            self.sChain = self.sChain(1:min(endIdx + 1,length(self.sChain)));
                
        end
    end
    
end

