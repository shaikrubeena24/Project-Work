clear;
%DM Transmitter 
fm=1;%frequency
fs=20*fm;%sampling frequncy
am=1;%amplitude
t=0:1/fs:1%time
x=am*cos(2*pi*fm*t)%Sinusoidal signal
plot(x,'m-');hold on;
d=(2*pi*fm*am)/fs;%Sinusoidal Signal
for n=1:length(x)
    if n==1
        e(n)=x(n);
        eq(n)=d*sign(e(n));
        xq(n)=eq(n);
    else
        e(n)=x(n)-xq(n-1);
        eq(n)=d*sign(e(n));
        xq(n)=eq(n)+xq(n-1);
    end
end
stairs(xq,'black');

%Transmitted  DM sequence
for n=1:length(x);
    if e(n)>0
        dm(n)=1;
    else
        dm(n)=0;
    end
end
