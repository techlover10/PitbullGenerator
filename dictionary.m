classdef dictionary < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        syllables
        content
        dictName
    end
    
    methods
        function dict = dictionary(filename)
            %Makes dictionary from file of words
            %Takes one text file, first line is name and second line is number of syllables of the dictionary,
            %and all subsequent lines are contents of dictionary
            dictFile = fopen(filename,'r');
            dict.dictName = fgetl(dictFile);
            dict.syllables = str2double(fgetl(dictFile));
            
            %generates actual dictionary
            i = 1;
            while ~feof(dictFile)
                dict.content{i} = fgetl(dictFile);
                i = i + 1;
            end
            fclose(dictFile);            
            
        end
        
        function word = getWord(self)
            randNum = ceil(rand*length(self.content));
            word = self.content{randNum};
        end
    end
    
end

