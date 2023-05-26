%Candidate Number: 21908
%CLASS ATTACK: Class to help decipher text encrypted using a permutation
%key. 
%***NOTE: CONTAINS LOTS OF NEW FUNCTIONALITY (3 new methods and changes to contructor)***
classdef Attack
    properties
        ciphertext %Stores the decrypted text make with an unknown key.
        key %Stores the trial key for encryted text.
        past %Stores a list of the previous swaps.
        dictionary
    end
    methods %function upper() for uppercase stuff? invesigate nargin
        %FUNCTION: Attack (constructor) 
        %INPUTS: Ciphertext, Key (upper, lowercase or perm 1-26), Past swaps (in form of ['ab'] or
        %        ['a','b'] upper or lowercase.
        %OUTPUTS: see DISP()
        %**Assummed that if the user wants prev. swaps they also input key and dictionary...
        function obj = Attack(CipherText, varargin)
            obj.ciphertext = upper(CipherText);
            obj.past = List;
            obj.dictionary = {};
            %If 'CipherText' is only input, PermutationKey is assummed to
            %be identity key.
            if isempty(varargin)
                obj.key=PermutationKey((1:26));
            %User is only allowed to type 4 inputs
            elseif nargin >4 
                disp("Too many inputs.")
                return
            %Error checking permutation key inputed by the user
            else
                %PermutationKey CLASS has its own error checking system, so
                %Only need to check the nature of the output.
                IsValid = PermutationKey(varargin{1}).perm;
                if length(IsValid)==26 %if NotValid, length = 1...
                    obj.key = PermutationKey(varargin{1});
                    %Checking if dictionary was entered
                    if nargin >2 
                        %Error checking dictionary
                        temp=varargin(2);
                        if iscellstr(temp{1}) ==1 
                            %No errors found in dictionary input
                            obj.dictionary = upper(temp{1});
                            %Checking if a past swap was imputed by user
                            if nargin == 4
                                %Error checking past swap imputed by user
                                ValidLetters = double(upper(varargin{3}))-64;
                                %A valid letter would be a number 1-26 ^
                                %Inputs should be 2 letters from alphabet 
                                if (length(varargin{3})==2) && (any((1:26) == ValidLetters(1)) && any((1:26) ==ValidLetters(2)))
                                    %Setting past as a list of 2 letters
                                    ValidLetters = char(varargin{3});
                                    obj.past = List(ValidLetters(1),ValidLetters(2));
                                else
                                    disp('Swap input invalid. Set to empty.')
                                end
                            end
                        else
                            disp('Dictionary input invalid')
                        end
                    end
                else
                    disp('Assigning key as identity.')
                    obj.key=PermutationKey((1:26));
                end
            end 
        end
        %FUNCTION: disp(), Displays outputs/properties made in contructor 
        %INPUTS: obj.(key/ciphertext)
        %OUTPUTS: ciphertext (<300 characters) decrypted with key, Permutation Key 
        function disp(obj)
            %Decrypts ciphertext with key and shortends too 300 characters
            %if necassery. 
            decrypt = decryption(obj.key,obj.ciphertext);
            if length(double(decrypt)) >300
                decrypt = decrypt(1:300);
            end
            %displays OUTPUTS with userfriendly formatting
            Formatting = [char(13),'Partial decoding: ',char(13)]; 
            disp('PermutationKey: ')
            disp(obj.key)
            disp(Formatting)
            disp(decrypt)
        end
        %FUNCTION: lettercount, counts the frequency of letters in ciphertext
        %INPUTS: obj.ciphertext
        %OUTPUTS: Array called 'Frequency', a permutation (1:26) of letter frequencies in ciphertext
        function a = lettercount(Text)
            Frequency = zeros(1,26);
            identity = (1:26);
            %All letters corresponding to a number (1:26)
            CipherNum = double(Text.ciphertext)-64;
            %For-Loop counts letter frequencies
            for i=1:length(CipherNum)
                %If character is not in alphabet, doesnt count
                if all (identity ~= CipherNum(i))
                    continue
                %Records presence of character in frequency array
                else
                    Frequency(CipherNum(i)) = Frequency(CipherNum(i))+1;
                end
            end
            %disp(Frequency) to the user 
            a = Frequency;
        end    
        %FUNCTION: attack, 'carries out a frequency attack on ciphertext'
        %INPUTS: obj.ciphertext
        %OUTPUTS: see FUNCTION disp()
        function b = attack(str)
            %Common characters of the English language accending order
            CommonLetters = 'ZQXJKVBPYGFWMUCLDRHSNIOATE';
            %Permutation of CommomLetters class PermutationKey
            PermCommonLetters = PermutationKey(double(CommonLetters)-64);
            %PermLetterCount = An array with least freq. letter in position 1 and most freq.
            %in position 26. with others following accending order
            PermLetterCount = PermutationKey(permutation(str.lettercount));
            %Computes the most likely key using PermutationKey class operations
            p = PermLetterCount*PermCommonLetters.invertion;
            %Calls Attack to display new ciphertext decrypted with new key 
            b = Attack(str.ciphertext,p.perm,str.dictionary);
            
        end
        %FUNCTION: sample, selects a random sample of ciphertext length 300 characters 
        %INPUTS: obj.ciphertext
        %OUTPUTS: Random sample of ciphertext with max length of 300 characters
        function sample(text)
            len = length(text.ciphertext);%pre-allocate for efficency
            %if ciphertext is less than 300 characters, disp. decryption with key
            if len<301
                disp(decryption(PermutationKey(text.key.perm),text.ciphertext));
            else
                n = randi(len-300); %random number between 1:len-300
                ShortText = (1:300);%array to alocate text to 
                %For-Loop which builds an array containing 300 characters
                %in order from initial random position in text 'n'
                for i=1:300
                    ShortText(i)=double(text.ciphertext(i+n)); 
                end
                %disp. decryption with key
                disp(decryption(PermutationKey(text.key.perm),char(ShortText))); 
            end
        end
        %FUNCTION: swap, see PermutationKey FUNCTION(swap) for more details
        %INPUTS: 2 letters and obj.(key/ciphertext/past)
        %OUTPUTS: see FUNCTION disp()
        function c = swap(k,a,b)
            %Error checking swap function
            ANum = double(upper(a))-64;
            BNum = double(upper(b))-64;
            if (length(a)==1 && length(b)==1) && (any((1:26) == ANum) && any((1:26)==BNum))
                %swap inputs valid
                k.past = [double(upper(a)),double(upper(b))];
                %Calls PermutationKey swap to swap 2 letters
                d = swap(k.key,a,b);
                %Outputs ciphertext decrypted with new key, also disp. key
                %Saves letters swapped in property 'past' as a 'List'.
                c = Attack(k.ciphertext,d.perm,k.dictionary,k.past);

            else
                %A swap input was invalid
                disp('Swap input valid')
                c = Attack(k.ciphertext,k.key.perm,k.dictionary);
                
            end
        end
        %FUNCTION: undo, reverses functionality of FUNCTION(swap)
        %INPUTS: obj.(key/ciphertext/past)
        %OUTPUTS: see FUNCTION disp()
        function d = undo(k)
            %Past property should not be empty
            if k.past.isNil == 1
                disp('No undo information')
                d = k;
                return
            %undo swap using Past property data
            else
                NewKey = swap(k.key,k.past.head,k.past.tail);
                %Outputs ciphertext decrypted with new key, also disp. key
                d = Attack(k.ciphertext,NewKey.perm,k.dictionary);
            end
        end
        %FUNCTION: DictionaryAttack: Counts the number of words in 
        %          dictionary that appear in ciphertext decrypted with a key  
        %INPUTS:  obj.(key/ciphertext/past/dictionary)
        %OUTPUTS: Number of words in dictionary found in ciphertext
        function DictionaryAttack(k)
            %Checks to see if dictionary is empty
            if isempty(k.dictionary)
                disp('Dictionary is empty')
                return
            end
            sum = zeros(length(k.dictionary),1);
            for i=1:length(k.dictionary)
                %searches text for ith word in dictionary
                NumWordsInDictionary = strfind(decryption(k.key,k.ciphertext), k.dictionary(i));
                %adds the number of words counted to the running total 'sum'
                sum(i) = length(NumWordsInDictionary);
            end
            %Creating correct formatting for table
            Word_In_Dictionary = {};
            for i=1:length(k.dictionary)
                Word_In_Dictionary(i,:) = k.dictionary(i);
            end
            %Replacing 'sum' for the correct title
            How_Many_Times_Word_Appears_In_Ciphertext_Decrypted_With_key=sum;
            %Displaying results on table
            disp(table(Word_In_Dictionary,How_Many_Times_Word_Appears_In_Ciphertext_Decrypted_With_key))

        end
        %FUNCTION: AddDictionary: adds words/text/numbers/dates to dictionary
        %INPUTS: strings of 'numbers' 'text' 'DoB' lower or uppercase ... and obj.(key/ciphertext/past/dictionary) 
        %OUTPUTS: obj.dictionary, see FUNCTION(disp)
        function f = AddDictionary(k,varargin)
            sum=0;
            %Checks to see if dictionary is empty
            if ~isempty(k.dictionary)
                %Dicitonary is not empty, checks to see if word imputed is already in dictionary
                for i=1:nargin-1
                    for j=1:length(k.dictionary)
                        %strcmpi compares if 2 strings are the same
                        if strcmpi(k.dictionary{j},varargin{i})==1
                            sum = 1;
                        end
                        %NOTE: could just append this word here because not
                        %in dictionary, but dont need to write same code
                        %twise... (see below)
                    end
                end
                if sum >0
                    %An imputed word was in the dictionary 
                    disp('An input is already in dictionary')
                    f = Attack(k.ciphertext,k.key.perm,k.dictionary);
                    return
                end
            end
            %Starts process of appending words to dictionary
            array = k.dictionary;
            %appending each input by the user to the next avaliable slot
            for j=1:nargin-1
                array(j+length(k.dictionary)) = {(upper(varargin{j}))};
            end
            %Running new dictionary through the constructor
            f = Attack(k.ciphertext,k.key.perm,array);
        end
        %FUNCTION: RemoveDictionary: Removes words from dictionary
        %INPUTS: 'text/numbers/8989...' for removing from dictionary
        %OUTPUTS: obj.dictionary, see FUNCTION(disp)
        function g = RemoveDictionary(k,varargin)
            %Checks to see if dictionary is empty
            if ~isempty(k.dictionary)
                sum=0;
                %Dicitonary is not empty, checks to see if word imputed is already in dictionary
                for j=1:nargin-1
                    for i=1:length(k.dictionary)
                        %If in dict. replaces word with '%\\\Removed Word\\\%'
                        if strcmpi(k.dictionary{i},varargin{j})==1
                            k.dictionary{i} = '%\\\Removed Word\\\%';
                            %Sum counts how many words been removed
                            sum=1+sum;
                            %Used to show appropriate message to user
                        end
                    end 
                end
                %If atleast 1 word imputed is not in dictionary
                if sum==0 || length(varargin)>sum
                    disp('At least 1 word imputed not in dictionary')
                    %Saves appropriate dictionary
                    g=Attack(k.ciphertext,k.key.perm,k.dictionary);
                else
                    %No issues or warnings to the user, correct imputs...
                    %Saves appropriate new dictionary
                    g=Attack(k.ciphertext,k.key.perm,k.dictionary);
                end
            else
                %Nothing changes since dictionary is empty
                disp('Dictionary is empty')
                g=Attack(k.ciphertext,k.key.perm,k.dictionary);
            end
        end 
    end
end 

        
        
        
        