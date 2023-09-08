% for 2 tracers data, fillup zeros, dt --> fulldt
function [fulldt,reduced_idx]=AB_getfulldt(dt,counts,A_num,B_num)

v1=repmat(0:B_num,1,A_num+1);
v2=reshape(repmat(0:A_num,B_num+1,1),1,(B_num+1)*(A_num+1));
cn=[v1;v2]';
cn=cn(:,[2,1]); %full list,iterate all A/B combinations
fulldt=[]; idx_r=[]; idx_j=[];
for j=1:size(cn,1)
    tp=find(ismember(counts,cn(j,:),'rows'));
    if isempty(tp)
       fulldt=[fulldt;zeros(1,size(dt,2))];
    else
       idx_r=[idx_r,tp];
       idx_j=[idx_j,j];
       fulldt=[fulldt;dt(tp,:)];
    end
end
[~,b]=sort(idx_r);
reduced_idx=idx_j(b);