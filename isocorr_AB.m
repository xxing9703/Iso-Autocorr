% A and B are two tracers
% distin input isotopmer distribution matrix, one sample per column
%n: A number, m: B number
%im_A: A impurity, im_A: B impurity;
function [distout,distout_pct]=isocorr_AB(distin,n,m,ab_A,ab_B,im_A,im_B)
if nargin<6
   im_A=0.01;  %impurity for A 
   im_B=0.01;  %impurity for B
end

%D matrix
dim=(n+1)*(m+1);
M=zeros(dim,dim);
mm=zeros(dim,dim,4);
mmp=zeros(dim,dim,4);
for i=1:dim
   A_num_row=floor((i-1)/(m+1));
   B_num_row=mod((i-1),(m+1));
    for j=1:i
         A_num_col=floor((j-1)/(m+1));
         B_num_col=mod((j-1),(m+1));
         
         a1=n-A_num_col;
         b1=A_num_row-A_num_col;    
        
      
         a2=m-B_num_col;
         b2=B_num_row-B_num_col;      
      mm(i,j,:)=[a1,b1,a2,b2];
      if b1>=0 && b2>=0     
        M(i,j)=dbinom(a1,b1,ab_A)*dbinom(a2,b2,ab_B);
      end
    end
end

Mp=zeros(dim,dim);
for i=1:dim
   A_num_row=floor((i-1)/(m+1));
   B_num_row=mod((i-1),(m+1));
    for j=i:dim
         A_num_col=floor((j-1)/(m+1));
         B_num_col=mod((j-1),(m+1));
         
         a1=A_num_col;
         b1=A_num_col-A_num_row;    
        
      
         a2=B_num_col;
         b2=B_num_col-B_num_row;      
      mmp(i,j,:)=[a1,b1,a2,b2];
      if b1>=0 && b2>=0     
        Mp(i,j)=dbinom(a1,b1,im_A)*dbinom(a2,b2,im_B);
      end        

    end
end

N=M*Mp;
distout=distin;
 for i=1:size(distin,2)
     distout(:,i)=lsqnonneg(N,distin(:,i));%non-negative least square fitting
 end
 distout_pct=distout./(sum(distout,1)+1e-10);

% distout=max(distout,0); %nonzero
% distout=distout./sum(distout,2); 


function out=dbinom(a,b,r)
out=nchoosek(a,b)*(1-r)^(a-b)*r^b;
