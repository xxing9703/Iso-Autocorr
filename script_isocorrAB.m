%-----  setup by user
clear
fname='g3p w 2h and 13c label.csv'; %file name from elmaven output
tracers={'C','N','D','O'}; %tracer symbles (do not change)
tracer_A=1;  % specify 1st tracer A: 13C=1, 15N=2, 2D=3, 18O=4
tracer_B=3;  % specify 2nd tracer B

impurity_A=0.01;
impurity_B=0.01;

%-----------------------------------------------------
abundance=[0.0107,0.00364,0.00001,0.00187];
ab_A=abundance(tracer_A);
ab_B=abundance(tracer_B);
start_col=find(strcmp(T.Properties.VariableNames,'parent'))+1;
autogrouping=0;
%%---------------------------------------------
T=readtable(fname,'readvariablename',true); 
T=T(1:length(find([T.medMz]>0)),:); %cut empty rows.
sample_name=T.Properties.VariableNames(start_col:end)';
grp_name=sample_name;
if autogrouping==1
     for i=1:length(sample_name)
         C=strsplit(sample_name{i},'_');
         if length(C)>1
             grp_name{i,1}=sample_name{i}(1:length(sample_name{i})-length(C{end})-1);
         else
             grp_name{i,1}=sample_name{i};
         end
     end 
end
grpHead=find(strcmp(T.isotopeLabel,'C12 PARENT'));
grpHead(end+1)=size(T,1)+1;
% read formula, extra A/B number   
      for i=1:length(grpHead)-1          
          ID(i)=i;          
          ids= grpHead(i):grpHead(i+1)-1;
          T.metaGroupId(ids)=ones(1,length(ids))*i;
        A_sub=T(ids,:); %A_sub: data sheet for the selected metabolite ID 
        try  %8/16/2020  added warning message for incorrect formulas
            [~,~,tp]=formula2mass(A_sub.formula{1});
            
        catch
            fprintf(['check row#',num2str(ids(1)+1),' for errors in the formula name: ',A_sub.formula{1}],'Error detected!');
            return
        end
        A_num=tp(tracer_A);  % A num
        B_num=tp(tracer_B);  % B num
     %short table-->full table (C+1)(N+1), insert rows with zero signals
        lb=A_sub.isotopeLabel; %string analysis to get number of C/N label
        counts=zeros(length(lb),2);
         for j=1:length(lb)
             str=lb{j};
             [Alb,Blb,errmsg]=str2AB(str,tracers{tracer_A},tracers{tracer_B});
             if errmsg==0
               counts(j,1)=Alb;
               counts(j,2)=Blb; 
             else
               fprintf('erros in isotopeLabel detected');
               return
             end
        end
     v1=repmat(0:B_num,1,A_num+1);
     v2=reshape(repmat(0:A_num,B_num+1,1),1,(B_num+1)*(A_num+1));
     cn=[v1;v2]';
     cn=cn(:,[2,1]); %full list,iterate all A/B combinations
     dt=A_sub{:,start_col:end};
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
        
        meta(i).ID=ID(i);      
        meta(i).name=A_sub.compound{1};
        meta(i).formula=A_sub.formula{1};
        meta(i).mz=A_sub.medMz(1);
        meta(i).rt=A_sub.medRt(1);
        meta(i).A_num=A_num;
        meta(i).B_num=B_num; 
        meta(i).original_abs=fulldt;
        meta(i).original_pct=fulldt./sum(fulldt,1);
        meta(i).tic=sum(fulldt,1);
        meta(i).reduced_idx=reduced_idx;        
      end
      
cat_abs=[];cat_pct=[];
for i=1:length(meta)  
 [corr_abs,~,corr_pct]=isocorr_AB(meta(i).original_abs,meta(i).A_num,meta(i).B_num,ab_A,ab_B,impurity_A,impurity_B);
 idx=meta(i).reduced_idx;  
 meta(i).corr_abs=corr_abs;
 meta(i).corr_pct=corr_pct;
 meta(i).corr_abs_short=corr_abs(idx,:); %shottable for output
 meta(i).corr_pct_short=corr_pct(idx,:); %shorttable for output
 meta(i).corr_tic=sum(meta(i).corr_abs,1);
  
 cat_abs=[cat_abs;corr_abs(idx,:)];  %concatenate for csv output
 cat_pct=[cat_pct;corr_pct(idx,:)];  
end

A_part1=T(:,1:start_col-1);
A_part2=T(:,start_col:end);

A_part2{:,:}=cat_abs;
A_corr_abs=[A_part1,A_part2];

A_part2{:,:}=cat_pct;
A_corr_pct=[A_part1,A_part2];

% make 3rd table as total ion/////////////
for i=1:length(meta)
  A_corr_total{i,1}=meta(i).ID;
  A_corr_total{i,2}=meta(i).name;
  A_corr_total{i,3}=meta(i).formula;
  for j=1:length(meta(i).tic)
  A_corr_total{i,3+j}=meta(i).tic(j);
  end
end
A_corr_total=cell2table(A_corr_total);
A_corr_total.Properties.VariableNames=[{'ID','Name','formula'},T.Properties.VariableNames(start_col:end)];
% end 3rd table  ////////////////////////

%save 
[filepath,name,~] = fileparts(fname);

fname_all=fullfile(filepath,[name,'_cor','.xlsx']);
writetable(T,fname_all,'Sheet','original');
writetable(A_corr_pct,fname_all,'Sheet','cor_pct');
writetable(A_corr_abs,fname_all,'Sheet','cor_abs');
writetable(A_corr_total,fname_all,'Sheet','total');

fprintf('done!\n')




