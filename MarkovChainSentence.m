classdef MarkovChainSentence < handle
    %Completed MarkovChain object
    
    properties
        endChain
        categories
        converted
    end
    
    methods
        function mChain = MarkovChainSentence(MarkovMatrix,numberOfLinks,startVal)
            chain = cell(1,numberOfLinks);
            chain{1} = [NaN,startVal];
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
            for i = 2:1:length(chain)
                mChain.endChain(i) = chain{i}(2);
            end
            %---------------- complete endChain construction -----
            mChain.categories = MarkovMatrix.categoryArray;

            %---------------- complete categories construction ---
            
            mChain.converted = cell(1,length(mChain.endChain));
            %for i = 1:1:length(mChain.converted)
            %    mChain.converted{i} = mChain.categories{mChain.endChain(i)};
           % end
            
        end
        
    end
    
end

