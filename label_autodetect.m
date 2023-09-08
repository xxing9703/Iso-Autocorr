function out=label_autodetect(lb)
type=[0,0,0,0];
lb=strjoin(lb);
if contains(lb,'C13')
    type(1)=1;
end
if contains(lb,'N15')
    type(2)=1;
end
if contains(lb,'D2')
    type(3)=1;
end
if contains(lb,'O18')
    type(4)=1;
end
out=find(type);
