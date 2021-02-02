%Matlab program to plot pdf of uniformly distributed random variables
%Hstogram Approach
n=1000;
a=2;%lower limit
b=3;%upper limit
x=a+(b-a).*rand(1,n);%uniformly distributed random variable
nob=10;%Number of bins
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
subplot(211);
%plot probability density function of  uniformly distributed random variables
bar(y,count(1:end-1)/length(x));

[bin val]=hist(x,y);
subplot(212);
bar(y,bin/length(x));