% input is the full table of A/B labeled intensities
%Conly Nonly sums up along each dimension.
function [Aonly, Bonly,total]=sumAB(input,Anum,Bnum)
  for i=1:Anum+1
     Aonly(i,:)=sum(input((i-1)*(Bnum+1)+1:i*(Bnum+1),:),1);
  end
  for i=1:Bnum+1
     Bonly(i,:)=sum(input(i:Bnum+1:(Bnum+1)*Anum+i,:),1);
  end
 total=sum(input,1);
      