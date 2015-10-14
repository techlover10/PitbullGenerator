classdef MarkovChain < handle
    %Completed MarkovChain object
    
    properties
        endChain
        categories
        converted
        endVal
    end
    
    methods
        function mChain = MarkovChain(MarkovMatrix,numberOfLinks,startVal)
            if (nargin == 2)
            chain = cell(1,numberOfLinks);
            chain{1} = [NaN,ceil(rand*MarkovMatrix.numberOfCategories)];
            elseif (nargin == 3)
                chain = cell(1,numberOfLinks);
            chain{1} = [NaN,startVal];
            end
            rowBox = 1;
            for index = 2:1:numberOfLinks
                max = MarkovMatrix.matrix(MarkovMatrix.numberOfCategories,chain{index-1}(2));
                randnum = abs(rand*max);
                rowBox = 1;
                while rowBox < MarkovMatrix.numberOfCategories && randnum > MarkovMatrix.matrix(rowBox,chain{index-1}(2))
                    rowBox = rowBox + 1;
                end
                chain{index} = [chain{index-1}(2),rowBox];
            end
            mChain.endChain = zeros(1,length(chain));
            for i = 1:1:length(chain)
                mChain.endChain(i) = chain{i}(2);
            end
            %---------------- complete endChain construction -----
            mChain.categories = MarkovMatrix.categoryArray;
            mChain.endVal = rowBox;
            %---------------- complete categories construction ---
            
            mChain.converted = cell(1,length(mChain.endChain));
            for i = 1:1:length(mChain.converted)
                mChain.converted{i} = mChain.categories{mChain.endChain(i)};
            end
            
        end
        
    end
    
end

