clear;
%DPCM Transmitter and Reciever
%Input Sinusoidal signal
fm=4;%frequency
fs=20*fm;%sampling frequncy
am=2;%amplitude
t=0:1/fs:1%time
x=am*cos(2*pi*fm*t)%Sinusoidal signal
figure(1);
plot(t,x,'k-');hold on;
xlabel("Time");
ylabel("Amplitude");
title("Input Sinusoidal signal");
for n=1:length(x)
    if n==1
        e(n)=x(n);
        eq(n)=round(e(n));
        xq(n)=eq(n);
    else
        e(n)=x(n)-xq(n-1);
        eq(n)=round(e(n));
        xq(n)=eq(n)+xq(n-1);
    end
    

end

%DPCM reciever
for n=1:length(x)
    if n==1
        xqr(n)=eq(n);
    else
        xqr(n)=eq(n)+xqr(n-1);
    end
    

end
plot(t,xqr,'m.-');
xlabel("Time");
ylabel("Amplitude");
%title("Reconstructed signal");
legend("Original","Reconstructed");

% Low Pass Filtering
[num den]=butter(2,4*fm/fs);%ButterFilter
rec_op=filter(num,den,xqr);%LPF

figure(2);
plot(t,rec_op,'g-');
xlabel('Time');
ylabel('Amplitude');
title('Smoothed  signal');