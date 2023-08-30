function plot2bar(meta,fieldname,CN,grp_name,dim,filepath)
%M=3;N=4;
M=dim(1);N=dim(2);
fig=0;
f=figure('units','normalized','outerposition',[0 0 1 1]);
for i=1:length(meta)
   md=mod(i,M*N);
     if md==1        
       % f=figure('units','normalized','outerposition',[0 0 1 1]);
        fig=fig+1; 
        clf(f,'reset')
        fname=['output',num2str(fig)];
        set(f,'NumberTitle', 'off','name',fname);
     elseif md==0
         md=M*N;
     end
     ax=subplot(M,N,md,'parent',f);
     mydt=meta(i).(fieldname);
     [Conly,Nonly]=sumCN(mydt,meta(i).C_num,meta(i).N_num);
     if CN==1
         mat=Conly;
     elseif CN==2
         mat=Nonly;
     end
      plot1_bar(ax,mat,grp_name,0);
      title(ax,[meta(i).name,' (',meta(i).formula,')']);     
     
     drawnow();
     if md==M*N
         filename=fullfile(filepath,fname);
         print(f,filename,'-dpng')
     end
end
%export last figure
     if md<M*N
         filename=fullfile(filepath,fname);
         print(f,filename,'-dpng')
     end