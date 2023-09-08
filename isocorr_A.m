function [distout,distout_pct]=isocorr_A(distin,n,ab_A,im_A)
r=ab_A;  % natural isotope abundance
r1=im_A; % impurity default 0.01
if size(distin,1)==1
    distin=distin';
end
%C matrix
M=zeros(n+1,n+1);
for i=1:n+1
    for j=1:i
      a=n+1-j;
      b=i-j;
      M(i,j)=nchoosek(a,b)*(1-r)^(a-b)*r^b;
    end
end
Mp=zeros(n+1,n+1);
for i=1:n+1
    for j=i:n+1
      a=n+1-(n+2-j);
      b=j-i;
      Mp(i,j)=nchoosek(a,b)*(1-r1)^(a-b)*r1^b;
    end
end

N=M*Mp;
distout=distin;
 for i=1:size(distin,2)
     distout(:,i)=lsqnonneg(N,distin(:,i));
 end
 distout_pct=distout./(sum(distout,1)+1e-10);
