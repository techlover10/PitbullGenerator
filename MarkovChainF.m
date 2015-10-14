function MarkovChain = MarkovChain(MarkovMatrix,numberOfLinks)
%Generates Markov Chain using probabilities from a markov matrix and given
%some number of chain links
chain = cell(1,numberOfLinks);
chain{1} = [NaN,ceil(rand*MarkovMatrix.numberOfCategories)];
for index = 2:1:numberOfLinks
    max = MarkovMatrix.matrix(MarkovMatrix.numberOfCategories,chain{index-1}(2));
    randnum = abs(rand*max);
    rowBox = 1;
    while rowBox < MarkovMatrix.numberOfCategories && randnum > MarkovMatrix.matrix(rowBox,chain{index-1}(2))
        rowBox = rowBox + 1;
    end
    chain{index} = [chain{index-1}(2),rowBox];
end
MarkovChain = zeros(1,length(chain));
for i = 1:1:length(chain)
    MarkovChain(i) = chain{i}(2);
end

end

