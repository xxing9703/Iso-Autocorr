%This function parses string of isotopeLabel(from Maven output) and
%finds out A and B labels. Deliminator '-' is used to make the judgement.
%examples:  str='C13-label-1', [Anum,Bnum]=[1,0]
%str='N15-label-1',[Anum,Bnum]=[0,1]
%str='C13N15-label-2-1',[Anum,Bnum]=[2,1]
%str='C12 PARENT', [Anum,Bum]=[0,0]

function [Anum,Bnum,errmsg]=str2AB(str,A,B)
      errmsg=0;
      sub_str=split(str,'-');
      num=length(sub_str);
      if num==1
          Anum=0;
          Bnum=0;          
      elseif num==3
          if strcmp(str(1),A)              
              Anum=str2num(sub_str{end});             
              Bnum=0; 
          elseif strcmp(str(1),B)
              Anum=0;
              Bnum=str2num(sub_str{end}); 
          else
              fprintf(['Error: it works for ', A,'/',B,', but you have ',str(1),'\n']); 
              errmsg=1;
          end
      elseif num==4          
            Anum=str2num(sub_str{end-1});
            Bnum=str2num(sub_str{end});          
      else
          fprintf('something is wrong with the string');
          errmsg=2;          
      end
      if isempty(Anum)||isempty(Bnum)
          fprintf('labeling not a number');
          errmsg=3;          
      end
