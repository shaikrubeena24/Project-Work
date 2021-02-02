%Matlab program to plot pdf of Rayleigh distribution
%Hstogram Approach
clear;
n=100000;
norm_mean=0;
norm_var=1/2;x1=norm_mean+sqrt(norm_var)*randn(1,n);
x2=norm_mean+sqrt(norm_var)*randn(1,n);
h=x1+j*x2; %complex gaussian

z=abs(h);
nob=100;%Number of bins
a=min(z);
b=max(z);
aa=linspace(a,b,nob);%linearly spaced vectors
count(size(aa))=0;%Initializing the counters
for i=1:length(aa)-1%bins
    for j=1:n
        if z(j)>=aa(i) && z(j)<aa(i+1)
            count(i)=count(i)+1;
        end
    end
    y(i)=(aa(i)+aa(i+1))/2;
end
%plotting
subplot(211);

bar(y,count(1:end-1)/n);
[bin val]=hist(z,y);
subplot(212);
bar(y,bin/n);
