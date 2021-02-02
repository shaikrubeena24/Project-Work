%Matlab program to plot pdf of normal distribution
%Hstogram Approach
n=1000;
norm_mean=1;
norm_var=2;
x=norm_mean+sqrt(norm_var)*randn(1,n);
nob=10;%Number of bins
a=min(x);
b=max(x);
aa=linspace(a,b,nob);%linearly spaced vectors
count(size(aa))=0;%Initializing the counters
for i=1:length(aa)-1%bins
    for j=1:length(x)%input random variable
        if x(j)>=aa(i) && x(j)<aa(i+1)
            count(i)=count(i)+1;
        end
    end
    y(i)=(aa(i)+aa(i+1))/2;
end
%plotting
subplot(211);

bar(y,count(1:end-1)/n);
[bin val]=hist(x,y);
subplot(212);
bar(y,bin/length(x));
