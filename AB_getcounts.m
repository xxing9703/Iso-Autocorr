%lb is cellarray from IsotopeLabel.  A, B: from C,N,D,O
function counts=AB_getcounts(lb,A,B)

counts=zeros(length(lb),2);
for j=1:length(lb)
      str=lb{j};
      [Alb,Blb,errmsg]=str2AB(str,A,B);
      if errmsg==0
         counts(j,1)=Alb;
         counts(j,2)=Blb; 
      else
         fprintf('erros in isotopeLabel detected');
         return
      end
end