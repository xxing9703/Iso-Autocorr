function plot1_bar(axe,mat,grp_name,flag)

[G,TD]=findgroups(grp_name);
iso=[];y=[];err=[];
%mat=meta(num).(fieldname);
for i=1:length(TD)
    idx=find(G==i);
    subset=mat(:,idx);
    for j=1:size(subset,1)
        y(j,i)=mean(subset(j,:));
        err(j,i)=std(subset(j,:));
    end
end

x = categorical(TD);
hold (axe,'off')
if length(x)==1  %when there's only one group
    x=[x,'dup'];
    y=[y,y];
    err=[err,err];
end
bar(axe,x,y','stacked');
set(axe,'TickLabelInterpreter','none')
hold (axe,'on')
if length(x)<length(grp_name)  %show errorbars 
 if size(y,1)==1
  errorbar(axe,y,err','.k');
 else
 errorbar(axe,cumsum(y)',err','.k');
 end
end

 for i=1:size(y,1)
  iso{i}=['M',num2str(i-1)];
 end
 if flag==1
   legend(axe,iso,'location','eastoutside')
 end
 xtickangle(axe,45);
