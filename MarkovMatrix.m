classdef MarkovMatrix < handle
    %Markov Matrix object for which Markov Chains can be generated
    %Takes one argument, numberOfCategories, and asks the user to enter
    %each category
    
    properties
        numberOfCategories
        categoryArray
        matrix
    end
    
    methods
        function mm = MarkovMatrix(numberOfCategories,catArray,probMatrix)
            if (nargin < 2)
                mm.categoryArray = cell(1,numberOfCategories);
                for i = 1:1:length(mm.categoryArray)
                    promptstr = sprintf('Enter category %d:  ',i);
                    mm.categoryArray{i} = input(promptstr);
                end
            elseif (nargin >= 2)
                mm.categoryArray = catArray;
                mm.numberOfCategories = length(catArray);
            end
            if (nargin == 3)
                mm.matrix = probMatrix;
            else
                mm.matrix = zeros(mm.numberOfCategories,mm.numberOfCategories);
                for colInd = 1:1:length(mm.categoryArray)
                    for rowInd = 1:1:length(mm.categoryArray)
                        promptstr = sprintf('Probability of %s given %s:  ',mm.categoryArray{colInd},mm.categoryArray{rowInd});
                        mm.matrix(rowInd,colInd) = input(promptstr);
                    end
                    
                end
            end
            
            for colInd = 1:1:length(mm.categoryArray)
                for rowInd = 2:1:length(mm.categoryArray)
                    mm.matrix(rowInd,colInd) = mm.matrix(rowInd,colInd) + mm.matrix(rowInd-1,colInd);
                end
            end
        end
        
        
        
    end
end


