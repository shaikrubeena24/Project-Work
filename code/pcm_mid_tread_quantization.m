%PCM with mid tread quantizer
fm=2;%message frequency
fs=1000*fm;%sampling frequency
t=0:1/fs:1;%time
a=3.5;%amplitude
x=a*sin(2*pi*fm*t);
figure(1);
plot(t,x,'k-');
xlabel('Time');
ylabel('Amplitude');
title('Original Message signal');
enc=[];
%Mid-Tread Quantization
for i=1:length(x)
    if x(i)>0.5 && x(i)<=1.5
        xq(i)=1;
        e=[1 0 0];
    elseif x(i)>1.5 && x(i)<=2.5
        xq(i)=2;
        e=[1 0 1];
    elseif x(i)>2.5 && x(i)<=3.5
        xq(i)=3;
        e=[1 1 0];
    elseif x(i)>=-3.5 && x(i)<=-2.5
        xq(i)=-3;
        e=[0 0 0];
    elseif x(i)>-2.5 && x(i)<=-1.5
        xq(i)=-2;
        e=[0 0 1];
    elseif x(i)>-1.5 && x(i)<=-0.5
        xq(i)=-1;
        e=[0 1 0];
    elseif x(i)>-0.5 && x(i)<0.5
        xq(i)=0;
        e=[0 1 1];
    end
    enc=[enc e];
end
figure(2);
plot(t,xq,'m-');
xlabel('Time');
ylabel('Amplitude');
title('Uniform Quantized signal');

figure(3);
plot(x,x-xq,'r-');
xlabel('Time');
ylabel('Error Amplitude');
title('Quantized Error');
%PCM reciever
rec=enc;
xq_r=[];
for j=1:3:length(rec)-2
    if rec(j)==0 &&rec(j+1)==0 && rec(j+2)==0
        xq1=-3;
    elseif rec(j)==0 &&rec(j+1)==0 && rec(j+2)==1
        xq1=-2;
    elseif rec(j)==0 &&rec(j+1)==1 && rec(j+2)==0
        xq1=-1;
    elseif rec(j)==0 &&rec(j+1)==1 && rec(j+2)==1
        xq1=0;
    elseif rec(j)==1 &&rec(j+1)==0 && rec(j+2)==0
        xq1=1;
    elseif rec(j)==1 &&rec(j+1)==0 && rec(j+2)==1
        xq1=2;
    elseif rec(j)==1 &&rec(j+1)==1 && rec(j+2)==0
        xq1=3;
    end
    xq_r=[xq_r xq1];
end
figure(4);
plot(t,xq_r,'k-');
xlabel('Time');
ylabel('Error Amplitude');
title('Demaped signal');

% Low Pass Filtering
[num den]=butter(4,5*fm/fs);%ButterWorth LPF
rec_op=filter(num,den,xq_r);

figure(5);
plot(t,rec_op,'g-');
xlabel('Time');
ylabel('Amplitude');
title('Reconstructed  signal');
