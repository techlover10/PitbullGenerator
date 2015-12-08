function [chorus,title] = PitbullChorus(syllables,lines)
%Generates a chorus based on Pitbull dictionaries
n = lines; %number of lines
s = syllables; %number of syllables per line


%define sentence structures

S1 = makeSentenceStruct('S1','firstpron');
S2 = makeSentenceStruct('S2','secondpron');
S3 = makeSentenceStruct('S3','thirdpron');
S4 = makeSentenceStruct('S4','posspron');
S5 = makeSentenceStruct('S5','demonstrative');
VL = makeSentenceStruct('VL','verb');
AL = makeSentenceStruct('AL','adj');

sentenceStructArray = {S1 S2 S3 S4 S5 VL AL};

%generate sentence structures
sentenceTypes = sentenceStructArray;
sentenceProbs = [20 25 25 20 5 1 2 ;...
    20 15 10 15 20 7 2 ;...
    10 15 2 7 5 11 30 ;...
    5 5 15 20 3 20 17 ;...
    15 25 10 5 5 20 10 ;...
    10 10 10 10 7 23 20 ;...
    10 15 15 10 7 23 20];
sStructs = MarkovMatrix(7,sentenceTypes,sentenceProbs);
sSequence= MarkovChain(sStructs,n);






%generate syllable divisions

syllableTypes = {1 2 3};
syllableProbs = ...
    [3 3 4;...
    5 2 2;...
    2 1 0];
syllableStructs = MarkovMatrix(n,syllableTypes,syllableProbs);
for i = 1:1:n
    
    sylSentences = MarkovChain(syllableStructs,s);
    sentenceChain{i} = SyllableChain(sylSentences,s);
    
    
end




%generate parts of speech
wordTypes = {'Subject' 'Verb' 'Object' 'Adjective' 'Adverb'};
LineProb = ...
    [0 3 0 5 0;...
    6 4 6 0 4;...
    0 2 0 2 0;...
    3 6 3 3 2;...
    3 1 2 0 3];
wordTypesMatrix = MarkovMatrix(length(wordTypes),wordTypes,LineProb);
for sentence = 1:1:length(sentenceChain)
    i = (length(sentenceChain{sentence}.sChain));
    for line = 1:1:length(sentenceChain)
        if sSequence.endChain(line) <=3
            wordTypesStruct{sentence} = MarkovChain(wordTypesMatrix,i,1);
        elseif sSequence.endChain(line) == 4
            wordTypesStruct{sentence} = MarkovChain(wordTypesMatrix,i,1);
            
            wordTypesStruct{sentence}.converted = ['possPron' wordTypesStruct{sentence}.converted];
        elseif sSequence.endChain(line) == 5
            wordTypesStruct{sentence} = MarkovChain(wordTypesMatrix,i,2);
        elseif sSequence.endChain(line) == 6
            wordTypesStruct{sentence} = MarkovChain(wordTypesMatrix,i,3);
        elseif sSequence.endChain(line) == 7
            wordTypesStruct{sentence} = MarkovChain(wordTypesMatrix,i-1,1);
            wordTypesStruct{sentence}.converted = ['demonstrative' wordTypesStruct{sentence}.converted];
        end
    end
    
end

%set up dictionaries
adj1 = dictionary('res/adj1.txt');
adj2 = dictionary('res/adj2.txt');
adj3 = dictionary('res/adj3.txt');
adjDict = {adj1 adj2 adj3};
adv1 = dictionary('res/adv1.txt');
adv2 = dictionary('res/adv2.txt');
adv3 = dictionary('res/adv3.txt');
advDict = {adv1 adv2 adv3};
noun1 = dictionary('res/noun1.txt');
noun2 = dictionary('res/noun2.txt');
noun3 = dictionary('res/noun3.txt');
nounDict = {noun1 noun2 noun3};
verb1 = dictionary('res/verb1.txt');
verb2 = dictionary('res/verb2.txt');
verb3 = dictionary('res/verb3.txt');
verbDict = {verb1 verb2 verb3};
pronDict = dictionary('res/pronouns.txt');
posspronDict = dictionary('res/possProns.txt');
demonstrativeDict = dictionary('res/demonstratives.txt');
fullDict = {adj1 adj2 adj3 noun1 noun2 noun3 verb1 verb2 verb3 pronDict...
           posspronDict demonstrativeDict adv1 adv2 adv3};

%create title
title = generateTitle(sentenceChain{1}.sChain,nounDict,verbDict,adjDict,demonstrativeDict,pronDict);


%create poem cell array
%sSequence = sequence of sentence structures
%sentenceChain{sentence} = array of syllable chains
%wordTypesStruct{sentence} = array of word types
for i = 1:1:length(sSequence.converted)
    chorus{i} = cell(1,length(sSequence.converted));
    for word = 1:1:(length(sentenceChain{i}.sChain))
        if sentenceChain{i}.sChain(word)==0
            chorus{i}{word} = 'lineBreak';
        else
            if strcmp(wordTypesStruct{i}.converted{word},'Verb')
                chorus{i}{word} = verbDict{sentenceChain{i}.sChain(word)}.getWord;
            elseif strcmp(wordTypesStruct{i}.converted{word},'Subject')
                chorus{i}{word} = nounDict{sentenceChain{i}.sChain(word)}.getWord;
            elseif strcmp(wordTypesStruct{i}.converted{word},'Adjective')
                chorus{i}{word} = adjDict{sentenceChain{i}.sChain(word)}.getWord;
            elseif strcmp(wordTypesStruct{i}.converted{word},'Adverb')
                chorus{i}{word} = advDict{sentenceChain{i}.sChain(word)}.getWord;
            elseif strcmp(wordTypesStruct{i}.converted{word},'Object')
                chorus{i}{word} = nounDict{sentenceChain{i}.sChain(word)}.getWord;
            else
                chorus{i}{word} = fullDict{ceil(abs(rand*length(fullDict)))}.getWord;
            end
        end
    end
end
%add title phrase to chorus
titleLines = ceil(rand*2);
for i = titleLines:2:4
    indexConst = length(chorus{i})-length(title);
    if length(chorus{i})<length(title)
        currTitle = cell(1,length(chorus{i}));
        for ind = 1:1:length(currTitle)
            currTitle{ind} = title{ind};
        end
    else
        currTitle = title;
    end
    for word = 1:1:length(currTitle)
        chorus{i}{indexConst+word} = currTitle{word};
    end
    
end

for i = 1:1:length(chorus)
    chorus{i} = [chorus{i} 'lineBreak'];
end

titleNoSpace = currTitle;
for i = 1:1:length(titleNoSpace)
    titleNoSpace{i}(1)=upper(titleNoSpace{i}(1));
end
title = cell(1,length(titleNoSpace)*2 - 1);
ind = 1;
for i = 1:1:length(title)
    if rem(i,2) == 0
        title{i} = ' ';
    else
        title{i} = titleNoSpace{ind};
        ind = ind + 1;
    end
end

end



function title = generateTitle(sylArray,nounDict,verbDict,adjDict,demonstrativeDict,pronDict)
%Generates Pitbull style title based on array of syllables
%T1 = Noun; T2 = Adjective, Noun; T3 = Verb, Demonstrative, Noun; T4 =
%Pronoun,Verb, Noun

%find length of sylArray
maxInd = 1;
for i = 1:1:length(sylArray)
    if sylArray(i) ~=0
        maxInd = i;
    end
end
titleType = ceil(rand*maxInd);
if titleType ==1
    title = {nounDict{sylArray(1)}.getWord()};
elseif titleType ==2
    title = cell(1,2);
    title{1} = adjDict{sylArray(1)}.getWord();
    title{2} = nounDict{sylArray(2)}.getWord();
elseif titleType == 3
    title = cell(1,3);
    title{1} = verbDict{sylArray(1)}.getWord();
    title{2} = demonstrativeDict.getWord();
    title{3} = nounDict{sylArray(2)}.getWord();
    
else
    title = cell(1,3);
    title{1} = pronDict.getWord();
    title{2} = verbDict{sylArray(2)}.getWord();
    title{3} = nounDict{sylArray(3)}.getWord();
end



end




