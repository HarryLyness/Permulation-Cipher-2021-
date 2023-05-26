%Candidate Number: 21908
%CLASS PermutationKey: Creates key which can be used to directly encrypt
%and decrypt text.
classdef PermutationKey
    properties
        perm
    end
    methods
        %FUNCTION: PermutationKey (contructor): initialies key with PermutationKey class 
        %INPUTS: key as any perm (1:26), nothing, or string of key (upper or lowercase)
        %OUTPUTS: see FUNCTION(disp)
        function key = PermutationKey(p)
            %If bo arguments, key is random perm
            if nargin ==0
                key.perm = randperm(26);
            %Error checking input by the user
            else
                %Makes 'p' into an array of either (1:26) or (65:90)
                %depending on string or number input.
                Perms = double(upper(char(double(p))));
                %Key must be length of 26
                if length(Perms)~=26
                    disp('Invald key')
                    return
                %Checks for repeated letters or numbers in key, and if they
                %are in correct range. Also checks for p = [1,...,67,...26]
                %where len(p)=26 but not all characters/numebers are imputed correctly
                else
                    logic=0;
                    %Logic will determine whether array of either (1:26) or (65:90)
                    identity = (1:26);
                    for i=1:26
                        %if number is in (65:90) and no repeats =>else; continue
                        if all(Perms-64~=identity(i)) 
                            %number is not in (65:90), checks to see if it in(1:26)
                            if all(Perms~=identity(i))
                                %Not in either so must be invalid key
                                %Or repeat so Invalid
                                disp('Invald key')
                                return
                            else
                                %number was in correct range and input was (1:26) permutation
                                logic = 1;
                                
                            end
                        else
                            continue
                            %suspected form inputed by user is char. key
                        end
                    end
                    if logic == 1
                        %input was (1:26) permutation. Valid
                        key.perm = Perms;
                    else
                        %input was char. key. Valid
                        key.perm = Perms-64;
                    end
                end
            end
        end
        %FUNCTION: disp: display s key from contructor
        %INPUTS: Permutation key 
        %OUTPUTS: Permutation key
        function disp(key)
            %displays Permutation Key 
            disp(char(key.perm+64));
        end
        %FUNCTION: mtimes: computes composition of 2 permutations 
        %INPUTS: 2 Permutation keys
        %OUTPUTS: composed permutation key, see FUNCTION(disp)
        function b = mtimes(l,m)
            %pre-allocating for speed 
            NewKey = zeros(1,26);
            for i=1:26
                %computes permuatation for each individual digit.
                NewKey(i) = l.perm(m.perm(i));
            end
            %Displays new PermutationKey using FUNCTION(disp)
            b = PermutationKey(NewKey);
        end
        %FUNCTION: invertion: Computes the inverse of the key. 
        %INPUTS: PermutationKey
        %OUTPUTS: Inverse of PermutationKey imputed by user, see FUNCTION(disp)
        function c = invertion(K)
            %Preallocating for speed
            NewKey = zeros(1,26);
            %Identity permutation
            identity = (1:26);
            for i=1:26
                %Computing inverse for each digit and putting in correct
                %position in NewKey
                NewKey(K.perm(i))=identity(i);
            end
            %Displays new PermutationKey using FUNCTION(disp) 
            c = PermutationKey(NewKey);
        end
        %FUNCTION: encryption: encrypting text with PermutationKey
        %INPUTS: text and key
        %OUTPUTS: new encrypted text
        function d = encryption(k,m)
            identity = (1:26);
            %pre-allocating for speed since need array 1-n in length.
            mstring = double(m); 
            %Transforming text into numbers (1:26)
            NumberM=double(upper(m))-64;
            %Computing encryption
            for i=1:length(m)
                if all (identity ~=NumberM(i))
                    %character not in alphabet so no changes
                    mstring(i)=NumberM(i);
                else
                    %character in alphabet so encrypt with key
                    mstring(i)=k.perm(NumberM(i));
                end
            end
            %disp new encrypted text
            d = char(mstring+64);
        end
        %FUNCTION: decryption: decrypts text with key
        %INPUTS: Key and encrypted text
        %OUTPUTS: Decrypted text
        function e = decryption(k,m)
           %sets key to inverse key
           k.perm=k.invertion.perm; 
           %Calls FUNCTION(encryption) to 'encrypt' text with inverse key...
           %Displays decrypted text to user
           e = char(double(encryption(k,m)));
        end
        %FUNCTION: swap: swaps two letters in the key corresponding to identity key 
        %INPUTS: key, 2 letters from the alphabet, upper or lowercase
        %OUTPUTS: New PermutationKey with relivent swap, see FUNCTION(disp)
        function f = swap(k,a,b)
            %Error checking swap function inputs.
            %ANum and BNum are in range (1:26) if valid && len = 1 
            ANum = double(upper(a))-64;
            BNum = double(upper(b))-64;
            %Must be 2 characters of the alphabet.
            if (length(a)==1 && length(b)==1) && (any((1:26) == ANum) && any((1:26)==BNum))
                %Inputs valid so computes swap
                temp=k.perm(BNum);
                k.perm(BNum)=k.perm(ANum);
                k.perm(ANum)=temp;
                %Displays new PermutationKey using FUNCTION(disp)
                f=PermutationKey(k.perm);
            else
                disp('PermutationKey swap input not valid')
                %Displays original PermutationKey using FUNCTION(disp)
                f=PermutationKey(k.perm);
            end
        end    
    end
end  











